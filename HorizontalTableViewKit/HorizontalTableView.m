//
//  HorizontalTableView.m
//  HorizontalTableView
//
//  Created by luyuanshuo on 13-6-7.
//  Copyright (c) 2013年 luyuanshuo. All rights reserved.
//

#import "HorizontalTableView.h"
#import "WKMutableStack.h"

#define DEFAULT_CELL_WIDTH 50
#define CELL_PRELOAD_BUFFER 0

typedef struct {
    NSInteger firstIndex;
    NSInteger lastIndex;
} CellIndexRange;

@interface HorizontalTableView()<UIScrollViewDelegate>{
    CGFloat* _cellRightBoundArray;
}

@property (nonatomic) CellIndexRange visibleCellRange;
@property (nonatomic) NSInteger numberOfCell;

//
@property (nonatomic, retain) NSMutableArray* visibleCellArray;
@property (nonatomic, retain) NSMutableDictionary* cellRecyclePool;

//
@property (nonatomic) BOOL isLoaded;

@end

@implementation HorizontalTableView

-(void)dealloc{
    //Remove KVO safely
    @try {
        [self removeObserver:self forKeyPath:@"contentOffset"];
    }
    @catch (NSException *exception) {
        NSLog(@"HorizontalTableView not reload!\n %@", exception);
    }
    
    //
    self.dataSource = nil;
    self.delegate = nil;
    //
    self.visibleCellArray = nil;
    self.cellRecyclePool = nil;
    //
    free(_cellRightBoundArray);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //initialize
        self.visibleCellArray = [NSMutableArray array];
        self.cellRecyclePool = [NSMutableDictionary dictionary];
        
        //KVO for contentOffset
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

#pragma mark - Public methods
-(void)reloadData{    
    //Clear
    [self clearAllCells];
    
    //Build intial cell map
    self.numberOfCell = [self.dataSource numberOfColumnInHTableView:self];
    
    //Build cell map by recording the right bound of each cell
    _cellRightBoundArray = malloc( sizeof(CGFloat) * self.numberOfCell );
    for (int i=0; i<self.numberOfCell; i++){
        //Get cell width at index i
        CGFloat cellWidth = DEFAULT_CELL_WIDTH;
        if ([self.delegate respondsToSelector:@selector(hTableView:widthForColumnAtIndex:)]) {
            cellWidth = [self.delegate hTableView:self widthForColumnAtIndex:i];
        }
        
        //Record right bound of each cell
        if (i>=1) {
            _cellRightBoundArray[i] = _cellRightBoundArray[i-1] + cellWidth;
        }else{
            _cellRightBoundArray[i] = cellWidth;
        }
    }
    
    //Set contentSize
    CGSize contentSize = CGSizeMake(0, CGRectGetHeight(self.bounds));
    contentSize.width = _cellRightBoundArray[self.numberOfCell-1]>CGRectGetWidth(self.bounds) ? _cellRightBoundArray[self.numberOfCell-1] : CGRectGetWidth(self.bounds)+1;
    self.contentSize = contentSize;
    
    [self initvisibleCellArray];
    
    self.isLoaded = YES;
}

-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    if (self.cellRecyclePool[identifier] && [self.cellRecyclePool[identifier] isKindOfClass:[WKMutableStack class]]) {
        return [(WKMutableStack*)self.cellRecyclePool[identifier] pop];
    }
    
    return nil;
}

-(NSArray *)visibleCells{
    return [NSArray arrayWithArray:self.visibleCellArray];
}

-(HTableViewCell *)cellForColumnAtIndex:(NSInteger)index{
    if ( index >= self.visibleCellRange.firstIndex && index <= self.visibleCellRange.lastIndex ) {
        return self.visibleCellArray[ index - self.visibleCellRange.firstIndex ];
    }else{
        return nil;
    }
}

-(NSInteger)indexForCell:(HTableViewCell *)cell{
    if ([self.visibleCellArray containsObject:cell]) {
        return self.visibleCellRange.firstIndex + [self.visibleCellArray indexOfObject:cell];
    }else{
        return NSNotFound;//Error
    }
}

//Todo
//
-(void)reloadColumnsAtIndexSet:(NSIndexSet *)indexSet{
    
}
//

#pragma mark - Recyle and reuse cell in scroll
-(void)initvisibleCellArray{
    //构造一个change
    NSDictionary* change = @{@"old": [NSValue valueWithCGPoint:CGPointMake(0., 0.)]};
    
    //Find first and last visible cell after set contentSize because contentOffset may change after set contentSize
    CellIndexRange visibleRange = [self visibleCellRangeWithOffsetChange:change];
    
    //Add cells in visible range
    for (int i=visibleRange.firstIndex; i<=visibleRange.lastIndex; i++) {
        HTableViewCell* cell = [self.dataSource hTableView:self cellForColumnAtIndex:i];
        
        [self prepareForAddingCell:cell atIndex:i];
        
        [self.visibleCellArray addObject:cell];
        
        [self addSubview:cell];
    }
    
    self.visibleCellRange = visibleRange;
}

-(void)layoutCellsWithContentOffsetChange:(NSDictionary*)change{
    CellIndexRange newVisibleRange = [self visibleCellRangeWithOffsetChange:change];
    
    //Heads up! ：在回收和添加cell的时候要注意一个极端情况，当翻动特别快的时候，可能会出现
    //1、向后滑动，老的lastIndex比新的firstIndex还小
    //2、向前滑动，老的firstIndex笔新的lastIndex
    //在这种情况下很可能会数组越界，因此在循环index的时候一定要处理范围越界，下面正是这么处理的
    
    //Do recycle first
    //Recyle invisible cell on left
    if (self.visibleCellRange.firstIndex < newVisibleRange.firstIndex) {
        CellIndexRange recycleRange;
        recycleRange.firstIndex = self.visibleCellRange.firstIndex;
        recycleRange.lastIndex = MIN(newVisibleRange.firstIndex-1, self.visibleCellRange.lastIndex);
        
        for (int i=recycleRange.firstIndex; i<=recycleRange.lastIndex; i++){
            HTableViewCell* cellToRecycle = self.visibleCellArray[0];
            
            [self recycleCell:cellToRecycle];

            [self.visibleCellArray removeObject:cellToRecycle];
                        
            [cellToRecycle removeFromSuperview];
        }
    }
    
    //Recycle visible cell on right
    if (self.visibleCellRange.lastIndex > newVisibleRange.lastIndex) {
        CellIndexRange recycleRange;
        recycleRange.firstIndex = MAX(newVisibleRange.lastIndex+1, self.visibleCellRange.firstIndex);
        recycleRange.lastIndex = self.visibleCellRange.lastIndex;
        
        for (int i=recycleRange.firstIndex; i<=recycleRange.lastIndex; i++) {
            HTableViewCell* cell = self.visibleCellArray.lastObject;
            
            [self recycleCell:cell];
            
            [self.visibleCellArray removeObject:cell];
            
            [cell removeFromSuperview];
        }
    }
    
    //Do add after recycle
    //Add visible cell on left
    if (self.visibleCellRange.firstIndex > newVisibleRange.firstIndex) {
        CellIndexRange addRange;
        addRange.firstIndex = newVisibleRange.firstIndex;
        addRange.lastIndex = MIN(self.visibleCellRange.firstIndex-1, newVisibleRange.lastIndex);
        
        for (int i=addRange.lastIndex; i>=addRange.firstIndex; i--) {
            HTableViewCell* cell = [self.dataSource hTableView:self cellForColumnAtIndex:i];
            
            [self prepareForAddingCell:cell atIndex:i];
            
            [self.visibleCellArray insertObject:cell atIndex:0];
            
            [self addSubview:cell];
        }
    }
    
    //Add visible cell on right
    if (self.visibleCellRange.lastIndex < newVisibleRange.lastIndex) {
        CellIndexRange addRange;
        addRange.firstIndex = MAX(self.visibleCellRange.lastIndex+1, newVisibleRange.firstIndex);
        addRange.lastIndex = newVisibleRange.lastIndex;
        
        for (int i=addRange.firstIndex; i<=addRange.lastIndex; i++) {
            HTableViewCell* cell = [self.dataSource hTableView:self cellForColumnAtIndex:i];
            
            [self prepareForAddingCell:cell atIndex:i];
            
            [self.visibleCellArray addObject:cell];
            
            [self addSubview:cell];
        }
    }
    
    self.visibleCellRange = newVisibleRange;
}

-(void)clearAllCells{
    for (HTableViewCell* cell in self.visibleCellArray){
        [cell removeFromSuperview];
    }
    
    [self.visibleCellArray removeAllObjects];
    [self.cellRecyclePool removeAllObjects];
    free(_cellRightBoundArray);
    _cellRightBoundArray = NULL;
    
    CellIndexRange cellRange;
    cellRange.firstIndex = 0;
    cellRange.lastIndex = 0;
    self.visibleCellRange = cellRange;
}

-(void)recycleCell:(HTableViewCell*)cell{
    if (!self.cellRecyclePool[cell.reuseIdentifier] || ![self.cellRecyclePool[cell.reuseIdentifier] isKindOfClass:[WKMutableStack class]]) {
        [self.cellRecyclePool setObject:[WKMutableStack stack] forKey:cell.reuseIdentifier];
    }
    
    [(WKMutableStack*)self.cellRecyclePool[cell.reuseIdentifier] push:cell];
}

-(void)prepareForAddingCell:(HTableViewCell*)cell atIndex:(NSInteger)index{
    cell.frame = [self frameForCellAtIndex:index];
}

#pragma mark - Utils
//Calculate current visible cell range according to the offset change
-(CellIndexRange)visibleCellRangeWithOffsetChange:(NSDictionary*)change{
    CGFloat newXOffset = self.contentOffset.x;
    CGFloat oldXOffset = [change[@"old"] CGPointValue].x;
    
    //可见区域判断规则：
    //起点：首先判断哪个cell使得左可见边界>=cell左界，<cell右界，然后以cell中线为分割，中线以左为上一个cell，中线以右为本cell
    //止点：首先判断哪个cell使得右可见边界>cell左界，<=cell右界，然后以cell中线为分割，中线以右为下一个cell，中线以左为本cell
    NSInteger firstVisibleCellIndex = self.visibleCellRange.firstIndex;
    NSInteger lastVisibleCellIndex = self.visibleCellRange.lastIndex;
    
    if (newXOffset >= oldXOffset) {
        //向后查找
        while ( firstVisibleCellIndex < self.numberOfCell
               &&  _cellRightBoundArray[firstVisibleCellIndex] < newXOffset ) {
            
            firstVisibleCellIndex++;
            
        }
        
        //向后查找
        while ( lastVisibleCellIndex < self.numberOfCell
               &&  _cellRightBoundArray[lastVisibleCellIndex] < newXOffset + CGRectGetWidth(self.bounds) ) {
            
            lastVisibleCellIndex++;
            
        }
        
    }else if (newXOffset < oldXOffset){
        //向前查找
        while ( firstVisibleCellIndex >= 0
               && [self leftBoundOffsetOfCellAtIndex:firstVisibleCellIndex] > newXOffset ) {
            
            firstVisibleCellIndex--;
            
        }
        
        //向前查找
        while ( lastVisibleCellIndex >= 0
               && [self leftBoundOffsetOfCellAtIndex:lastVisibleCellIndex] > newXOffset + CGRectGetWidth(self.bounds) ) {
            
            lastVisibleCellIndex--;
            
        }
        
    }
    
    //判断和中线的位置
    if (newXOffset < [self xCenterOfCellAtIndex:firstVisibleCellIndex])
    {
        firstVisibleCellIndex--;
    }
    //判断和中线的位置
    if (newXOffset + CGRectGetWidth(self.bounds) > [self xCenterOfCellAtIndex:lastVisibleCellIndex])
    {
        lastVisibleCellIndex++;
    }
    
    CellIndexRange visibleCellRange;
    visibleCellRange.firstIndex = MAX(0, firstVisibleCellIndex - CELL_PRELOAD_BUFFER);
    visibleCellRange.lastIndex = MIN(self.numberOfCell - 1, lastVisibleCellIndex + CELL_PRELOAD_BUFFER);
    
    return visibleCellRange;
}

//Frame for cell with indexPath
-(CGRect)frameForCellAtIndex:(NSInteger)index{
    return CGRectMake([self leftBoundOffsetOfCellAtIndex:index], 0, [self widthOfCellAtIndex:index], CGRectGetHeight(self.bounds));
}

//Get cell's left bound
-(CGFloat)leftBoundOffsetOfCellAtIndex:(NSInteger)index{
    if (index == 0) {
        return 0.;
    }else if (index > 0){
        return _cellRightBoundArray[index-1];
    }else{
        return -1.;//Error
    }
}

//Get cell's width
-(CGFloat)widthOfCellAtIndex:(NSInteger)index{
    return _cellRightBoundArray[index] - [self leftBoundOffsetOfCellAtIndex:index];
}

//Get cell's center position x value
-(CGFloat)xCenterOfCellAtIndex:(NSInteger)index{
    return _cellRightBoundArray[index] - [self widthOfCellAtIndex:index]/2;
}

#pragma mark - Cell selected event
-(void)hTableViewCellDidSelected:(HTableViewCell*)cell{
    if ([self.delegate respondsToSelector:@selector(hTableView:didSelectColumnAtIndex:)]) {
        [self.delegate hTableView:self didSelectColumnAtIndex:[self indexForCell:cell]];
    }
}

#pragma mark - Listen KVO scrollEvent
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (self.isLoaded && [keyPath isEqualToString:@"contentOffset"]) {
        [self layoutCellsWithContentOffsetChange:change];
    }
}

@end

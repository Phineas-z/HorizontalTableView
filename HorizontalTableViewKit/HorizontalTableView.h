//
//  HorizontalTableView.h
//  HorizontalTableView
//
//  Created by luyuanshuo on 13-6-7.
//  Copyright (c) 2013年 luyuanshuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTableViewCell.h"

@protocol HorizontalTableViewDataSource, HorizontalTableViewDelegate;

@interface HorizontalTableView : UIScrollView
@property (nonatomic, assign) id<HorizontalTableViewDataSource> dataSource;
@property (nonatomic, assign) id<HorizontalTableViewDelegate> delegate;

@property (nonatomic, readonly) NSArray* visibleCells;

-(void)reloadData;

//Not implemented
//-(void)reloadColumnsAtIndexSet:(NSIndexSet *)indexSet;

-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

-(HTableViewCell*)cellForColumnAtIndex:(NSInteger)index;// returns nil if cell is not visible

-(NSInteger)indexForCell:(HTableViewCell *)cell;// returns nil if cell is not visible

@end

@protocol HorizontalTableViewDataSource <NSObject>
- (NSInteger)numberOfColumnInHTableView:(HorizontalTableView *)tableView;
- (HTableViewCell*)hTableView:(HorizontalTableView *)tableView cellForColumnAtIndex:(NSInteger)index;
@optional
//Not implemented yet
//- (NSInteger)numberOfSectionsInHTableView:(UITableView *)tableView;
@end

@protocol HorizontalTableViewDelegate <NSObject, UIScrollViewDelegate>
@optional
- (void)hTableView:(HorizontalTableView *)tableView didSelectColumnAtIndex:(NSInteger)index;
- (CGFloat)hTableView:(HorizontalTableView *)tableView widthForColumnAtIndex:(NSInteger)index;
//Not implemented yet
//- (CGFloat)hTableView:(HorizontalTableView *)tableView heightForHeaderInSection:(NSInteger)section;
//- (CGFloat)hTableView:(HorizontalTableView *)tableView heightForFooterInSection:(NSInteger)section;

//- (UIView *)hTableView:(HorizontalTableView *)tableView viewForHeaderInSection:(NSInteger)section;
//- (UIView *)hTableView:(HorizontalTableView *)tableView viewForFooterInSection:(NSInteger)section;

@end

//
//  ViewController.m
//  HorizontalTableView
//
//  Created by luyuanshuo on 13-6-7.
//  Copyright (c) 2013年 luyuanshuo. All rights reserved.
//

#import "ViewController.h"
#import "HorizontalTableView.h"
#import "LabelCell.h"

@interface ViewController ()<HorizontalTableViewDataSource, HorizontalTableViewDelegate, UIScrollViewDelegate>
@property (nonatomic) NSInteger count;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    HorizontalTableView* tableView = [[[HorizontalTableView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 200)] autorelease];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor redColor];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [tableView reloadData];
    
    [self.view addSubview:tableView];
}

-(NSInteger)numberOfColumnInHTableView:(HorizontalTableView *)tableView{
    return 1000;
}

-(HTableViewCell *)hTableView:(HorizontalTableView *)tableView cellForColumnAtIndex:(NSInteger)index{
    //NSLog(@"call dequeue %d", indexPath.row);
    LabelCell* cell = [tableView dequeueReusableCellWithIdentifier:@"hehe"];
    if (!cell) {
        cell = [[[LabelCell alloc] initWithReuseIdentifier:@"hehe"] autorelease];
        self.count++;
        NSLog(@"alloc cell %d", self.count);
    }
    
    cell.label.text = [NSString stringWithFormat:@"%d", index];
    
    return cell;
}

-(CGFloat)hTableView:(HorizontalTableView *)tableView widthForColumnAtIndex:(NSInteger)index{
    return 100;
}

-(void)hTableView:(HorizontalTableView *)tableView didSelectColumnAtIndex:(NSInteger)index{
    NSLog(@"%d", index);
}

@end

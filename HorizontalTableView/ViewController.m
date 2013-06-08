//
//  ViewController.m
//  HorizontalTableView
//
//  Created by luyuanshuo on 13-6-7.
//  Copyright (c) 2013年 luyuanshuo. All rights reserved.
//

#import "ViewController.h"
#import "HorizontalTableView.h"
#import <QuartzCore/QuartzCore.h>

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
    
    [tableView reloadData];
    
    [self.view addSubview:tableView];
}

-(NSInteger)hTableView:(HorizontalTableView *)tableView numberOfColumnInSection:(NSInteger)section{
    return 1000;
}

-(HTableViewCell *)hTableView:(HorizontalTableView *)tableView cellForColumnAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"call dequeue %d", indexPath.row);
    HTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"hehe"];
    if (!cell) {
        cell = [[[HTableViewCell alloc] initWithReuseIdentifier:@"hehe"] autorelease];
        self.count++;
        NSLog(@"alloc cell %d", self.count);
    }
    cell.backgroundColor = [UIColor blueColor];
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 1.;
    
    return cell;
}

-(CGFloat)hTableView:(HorizontalTableView *)tableView widthForColumnAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

@end

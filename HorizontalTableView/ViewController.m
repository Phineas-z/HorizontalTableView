//
//  ViewController.m
//  HorizontalTableView
//
//  Created by luyuanshuo on 13-6-7.
//  Copyright (c) 2013年 luyuanshuo. All rights reserved.
//

#import "ViewController.h"
#import "HorizontalTableView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    HorizontalTableView* tableView = [[[HorizontalTableView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 200)] autorelease];
    tableView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:tableView];
}

@end

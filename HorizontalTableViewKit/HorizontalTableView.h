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

-(void)reloadData;
-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end

@protocol HorizontalTableViewDataSource <NSObject>
- (NSInteger)hTableView:(HorizontalTableView *)tableView numberOfColumnInSection:(NSInteger)section;
- (HTableViewCell *)hTableView:(HorizontalTableView *)tableView cellForColumnAtIndexPath:(NSIndexPath *)indexPath;
@optional
//Not implemented yet
//- (NSInteger)numberOfSectionsInHTableView:(UITableView *)tableView;
@end

@protocol HorizontalTableViewDelegate <NSObject, UIScrollViewDelegate>
@optional
- (void)hTableView:(HorizontalTableView *)tableView didSelectColumnAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)hTableView:(HorizontalTableView *)tableView widthForColumnAtIndexPath:(NSIndexPath *)indexPath;
//Not implemented yet
//- (CGFloat)hTableView:(HorizontalTableView *)tableView heightForHeaderInSection:(NSInteger)section;
//- (CGFloat)hTableView:(HorizontalTableView *)tableView heightForFooterInSection:(NSInteger)section;

//- (UIView *)hTableView:(HorizontalTableView *)tableView viewForHeaderInSection:(NSInteger)section;
//- (UIView *)hTableView:(HorizontalTableView *)tableView viewForFooterInSection:(NSInteger)section;

@end

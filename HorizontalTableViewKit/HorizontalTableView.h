//
//  HorizontalTableView.h
//  HorizontalTableView
//
//  Created by luyuanshuo on 13-6-7.
//  Copyright (c) 2013年 luyuanshuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalTableViewDataSource, HorizontalTableViewDelegate;

@interface HorizontalTableView : UIScrollView
@property (nonatomic, assign) id<HorizontalTableViewDataSource> dataSource;
@property (nonatomic, assign) id<UIScrollViewDelegate ,HorizontalTableViewDelegate> delegate;

@end

@protocol HorizontalTableViewDataSource <NSObject>
@optional
@end

@protocol HorizontalTableViewDelegate <NSObject>
@optional
@end

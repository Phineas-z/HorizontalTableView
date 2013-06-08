//
//  HTableViewCell.h
//  HorizontalTableView
//
//  Created by luyuanshuo on 13-6-7.
//  Copyright (c) 2013年 luyuanshuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTableViewCell : UIView

@property (nonatomic, retain) NSString* reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end

//
//  HTableViewCell.m
//  HorizontalTableView
//
//  Created by luyuanshuo on 13-6-7.
//  Copyright (c) 2013年 luyuanshuo. All rights reserved.
//

#import "HTableViewCell.h"

@implementation HTableViewCell

-(void)dealloc{
    self.reuseIdentifier = nil;
    
    [super dealloc];
}

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.reuseIdentifier = reuseIdentifier;
    }
    
    return self;
}

@end

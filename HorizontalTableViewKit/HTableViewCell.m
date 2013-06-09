//
//  HTableViewCell.m
//  HorizontalTableView
//
//  Created by luyuanshuo on 13-6-7.
//  Copyright (c) 2013年 luyuanshuo. All rights reserved.
//

#import "HTableViewCell.h"
#import "HorizontalTableView.h"

@interface HTableViewCell()
@end

@implementation HTableViewCell

-(void)dealloc{
    self.reuseIdentifier = nil;
    
    [super dealloc];
}

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.reuseIdentifier = reuseIdentifier;
        
        UITapGestureRecognizer* tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)] autorelease];
        [self addGestureRecognizer:tapRecognizer];
    }
    
    return self;
}

-(void)tap:(UITapGestureRecognizer*)recoginzer{
    if ([self.superview isKindOfClass:[HorizontalTableView class]]) {
        [self.superview performSelector:@selector(hTableViewCellDidSelected:) withObject:self];
    }
}

@end

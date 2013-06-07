//
//  HorizontalTableView.m
//  HorizontalTableView
//
//  Created by luyuanshuo on 13-6-7.
//  Copyright (c) 2013年 luyuanshuo. All rights reserved.
//

#import "HorizontalTableView.h"

@implementation HorizontalTableView

-(void)dealloc{
    //Remove KVO
    [self removeObserver:self forKeyPath:@"contentOffset"];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //KVO for contentOffset
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

#pragma mark - Listen KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"] && [object valueForKeyPath:keyPath] != [NSNull null]) {
        NSLog(@"%f", [[object valueForKeyPath:keyPath] floatValue]);
    }
}

@end

//
//  LabelCell.m
//  HorizontalTableView
//
//  Created by luyuanshuo on 13-6-8.
//  Copyright (c) 2013年 luyuanshuo. All rights reserved.
//

#import "LabelCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation LabelCell

-(void)dealloc{
    self.label = nil;
    
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.label = [[[UILabel alloc] initWithFrame:self.bounds] autorelease];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.label];
        
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end

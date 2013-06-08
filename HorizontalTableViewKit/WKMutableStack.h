//
//  WKMutableStack.h
//  ipadWenku
//
//  Created by luyuanshuo on 13-4-9.
//  Copyright (c) 2013年 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKMutableStack : NSObject

@property (nonatomic, readonly) id stackTop;

@property (nonatomic, readonly) NSInteger count;

@property (nonatomic, retain) NSMutableArray* array;


+(WKMutableStack*)stack;

-(void)push:(id)object;

-(id)pop;

-(void)clearStack;

@end

//
//  WKMutableStack.m
//  ipadWenku
//
//  Created by luyuanshuo on 13-4-9.
//  Copyright (c) 2013年 Neusoft. All rights reserved.
//

#import "WKMutableStack.h"

@interface WKMutableStack()
//@property (nonatomic, retain) NSMutableArray* array;
@end

@implementation WKMutableStack

-(void)dealloc{
    self.array = nil;
    
    [super dealloc];
}

+(WKMutableStack *)stack{
    return [[[WKMutableStack alloc] init] autorelease];
}

-(id)init{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    
    return self;
}

-(id)pop{
    if (self.array.count >= 1) {
        id object = [self.array.lastObject retain];
        [self.array removeLastObject];
        return [object autorelease];
    }
    
    return nil;
}

-(void)push:(id)object{
    [self.array addObject:object];
}

-(id)stackTop{
    return self.array.lastObject;
}

-(void)clearStack{
    [self.array removeAllObjects];
}

-(NSInteger)count{
    return self.array.count;
}

@end

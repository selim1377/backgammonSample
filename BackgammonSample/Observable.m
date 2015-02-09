//
//  Observable.m
//  BackgammonSample
//
//  Created by Selim on 09.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "Observable.h"

@interface Observable ()

@property (nonatomic, strong ) NSMutableArray *observers;

@end

@implementation Observable


-(instancetype)init
{
    if ([super init]) {
        
        self.observers = [NSMutableArray new];
    }
    
    return self;
}

-(void)addObserver:(Observer *)observer
{
    [self.observers addObject:observer];
}

-(void)removeObserver:(Observer *)observer
{
    [self.observers removeObject:observer];
}


#pragma mark this method should override
-(void)notify:(Event *)event
{
    for (Observer *observer in self.observers) {
        
        if (observer) {
            [observer onNotify:event];
        }
    }
}


@end

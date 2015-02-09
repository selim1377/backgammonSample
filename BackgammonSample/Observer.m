//
//  Observer.m
//  BackgammonSample
//
//  Created by Selim on 09.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "Observer.h"
#import "Observable.h"

@implementation Observer

-(void)dealloc
{
    [self.observable removeObserver:self];
}

-(void)onNotify:(Event *)event
{
    self.completion = event.completion;
}

@end

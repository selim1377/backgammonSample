//
//  BaseController.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "BaseController.h"

@implementation BaseController


-(id)initWithGameEngine:(GameEngine *)engine
{
    if ([super init]) {
        
        self.gameEngine = engine;
        
    }
    
    return self;
}
@end

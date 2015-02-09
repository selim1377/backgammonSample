//
//  BaseController.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameEngine.h"
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Actions.h"
#import "UIDelegate.h"
#import "UIView+Subview.h"


@interface BaseController : NSObject

// Every controller has access to game engine instance
@property (assign, nonatomic) GameEngine *gameEngine;

// every controller has a connection to game engine
-(id)initWithGameEngine:(GameEngine *)engine;

//every controller has the delegate to obtain an interface to the game controller
@property (assign, nonatomic) id<UIDelegate> uidelegate;

@end

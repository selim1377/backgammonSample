//
//  PlayerController.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "BaseController.h"
#import "Player.h"


@interface PlayerController : BaseController

// initialize with views
-(void)generateViewsFromView:(UIView *)parentView;

-(void)createBindings;

@end


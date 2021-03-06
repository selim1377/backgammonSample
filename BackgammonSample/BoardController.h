//
//  BoardController.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "BaseController.h"
#import "UIView+Subview.h"
#import "LineView.h"
#import "ChipView.h"
#import "Board.h"

@interface BoardController : BaseController <ChipViewDelegate>

// initialize with views
-(void)generateViewsFromView:(UIView *)parentView;

-(void)createBindings;


@end

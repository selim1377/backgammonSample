//
//  DiceView.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Subview.h"
#import "Observer.h"

@interface DiceView : Observer


-(void)presentDiceValue:(int)value;
-(void)animateWithValue:(int)value;


@end

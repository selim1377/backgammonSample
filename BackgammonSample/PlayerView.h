//
//  PlayerView.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Subview.h"
#import "Observer.h"

@interface PlayerView : Observer

-(UIButton *)rollDiceButton;

-(void)turnAnimation:(BOOL)hasTurn;

-(void)showPlayerInfo:(NSString *)playerName;
-(void)showRollDiceButton;
-(void)hideRollDiceButton;

@end

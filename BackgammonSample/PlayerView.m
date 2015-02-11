//
//  PlayerView.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "PlayerView.h"

// animation key definitions
#define DURATION_ANIMATION_TURN 0.5f

@implementation PlayerView



-(void)turnAnimation:(BOOL)hasTurn
{
    CGFloat targetAlpha = hasTurn ? 1.0f : 0.3f;
    UIColor *targetColor = hasTurn ? [UIColor greenColor] : [UIColor blackColor];
    
    [UIView animateWithDuration:DURATION_ANIMATION_TURN
                     animations:^{
                         
                         self.alpha     = targetAlpha;
                         self.backgroundColor = targetColor;
                         
                     } completion:^(BOOL finished) {
                         
                         
                         
                     }];
    
    // show turn button, and hide the others
    if(hasTurn)
        [self showRollDiceButton];
    else
        [self hideRollDiceButton];
}

-(UIButton *)rollDiceButton
{
    UIButton *roll = (UIButton *) [self viewWithTag:2];
    return roll;
}

-(void)showPlayerInfo:(NSString *)playerName
{
    UILabel *label = (UILabel*) [self viewWithTag:1];
    if (label)
        label.text = playerName;
}

-(void)showRollDiceButton
{
    [self rollDiceButton].hidden = NO;
}

-(void)hideRollDiceButton
{
    [self rollDiceButton].hidden = YES;
}

-(void)onNotify:(Event *)event
{
    
    if (event.eventType == EVENT_TYPE_PLAYER_TURN) {
        BOOL turn = [event.entity boolValue];
        [self turnAnimation:turn];
    }
    
}

@end

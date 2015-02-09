//
//  OneDiceAction.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "OneDiceAction.h"

@interface OneDiceAction ()

@property (nonatomic, readwrite,strong) Dice *dice;
@property (nonatomic, readwrite,assign) PlayerType type;

@end


@implementation OneDiceAction

+(OneDiceAction *)actionWithDice:(Dice *)d ForPlayer:(PlayerType)type
{
    OneDiceAction *action = [OneDiceAction new];
    action.dice = d;
    action.type = type;
    
    return action;
}

@end

//
//  RollDiceAction.m
//  BackgammonSample
//
//  Created by Selim on 07.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "RollDiceAction.h"

@interface RollDiceAction ()

@property (nonatomic, readwrite,strong) Dices *dices;

@end

@implementation RollDiceAction

+(RollDiceAction *)actionWithDices:(Dices *)dices
{
    RollDiceAction *action = [RollDiceAction new];
    action.dices = dices;    
    return action;
}

@end

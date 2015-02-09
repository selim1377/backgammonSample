//
//  OneDiceAction.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "Action.h"
#import "Dice.h"

@interface OneDiceAction : Action

@property (nonatomic, readonly,strong) Dice *dice;
@property (nonatomic, readonly,assign) PlayerType type;
@property (assign, nonatomic) BOOL determined;

+(OneDiceAction *)actionWithDice:(Dice *)d ForPlayer:(PlayerType)type;

@end

//
//  RollDiceAction.h
//  BackgammonSample
//
//  Created by Selim on 07.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "Action.h"
#import "Dices.h"

@interface RollDiceAction : Action

@property (nonatomic, readonly,strong) Dices *dices;


+(RollDiceAction *)actionWithDices:(Dices *)dices;

@end

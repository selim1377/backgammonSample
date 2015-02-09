//
//  Dices.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "BaseModel.h"
#import "Dice.h"
#import "Move.h"

@interface Dices : BaseModel


-(void)rollDicesWithCompletion:(void(^)(void))block;
-(void)rollDice:(PlayerType)type;
-(BOOL)consume:(Move *)move;
-(BOOL)movesFinished;

-(Dice *)diceForType:(PlayerType)type;
-(NSArray *)valuesOfDices;

@end

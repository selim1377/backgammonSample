//
//  Dice.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "BaseModel.h"


@interface Dice : BaseModel

@property (assign, nonatomic,readonly) int value;

-(void)rollDiceWithCompletion:(EventCompletion)completion;


@end

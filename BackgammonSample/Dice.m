//
//  Dice.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "Dice.h"

@interface Dice ()

@property (assign, nonatomic,readwrite) int value;


@end

@implementation Dice

-(void)rollDiceWithCompletion:(EventCompletion)completion
{
    int result =  ( (int)(arc4random() % 6) + 1);
    self.value = result;
    
    Event *event = [[Event alloc] initWithEntity:[NSNumber numberWithInt:self.value] withType:EVENT_TYPE_DICE_ROLL];
    event.completion = completion;
    [self notify:event];
}


@end

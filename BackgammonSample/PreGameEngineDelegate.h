//
//  PreGameEngineDelegate.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Dice.h"

@protocol PreGameEngineDelegate <NSObject>

-(void)initializePregame;
-(void)preGameTurn:(Player *)player;
-(void)preGameDiceRoll:(Dice *)dice determine:(BOOL)shouldDetermine;

@end

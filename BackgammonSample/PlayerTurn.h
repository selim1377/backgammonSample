//
//  PlayerTurn.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "Action.h"
#import "Player.h"

@interface PlayerTurn : Action

@property (nonatomic, readonly,strong) Player *player;

+(PlayerTurn *)actionWithPlayer:(Player *)player;

@end

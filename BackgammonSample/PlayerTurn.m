//
//  PlayerTurn.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "PlayerTurn.h"

@interface PlayerTurn ()

@property (nonatomic, readwrite,strong) Player *player;

@end

@implementation PlayerTurn

+(PlayerTurn *)actionWithPlayer:(Player *)player
{
    PlayerTurn *turn = [PlayerTurn new];
    turn.player = player;
    
    return turn;
}

@end

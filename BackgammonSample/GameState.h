//
//  GameState.h
//  BackgammonSample
//
//  Created by Selim on 07.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#ifndef BackgammonSample_GameState_h
#define BackgammonSample_GameState_h

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, GameState) {
    GAMESTATE_SETUP,
    GAMESTATE_PREGAME,
    GAMESTATE_GAME,
    GAMESTATE_GAME_PLAYER_MOVING,
    GAMESTATE_GATHERING,
    FINISHED
};

#endif

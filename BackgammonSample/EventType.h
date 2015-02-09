//
//  EventType.h
//  BackgammonSample
//
//  Created by Selim on 09.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#ifndef BackgammonSample_EventType_h
#define BackgammonSample_EventType_h

#import <Foundation/Foundation.h>

// Define enum types for players
typedef enum : NSUInteger {
    EVENT_TYPE_PLAYER_TURN,
    EVENT_TYPE_DICE_ROLL,
    EVENT_TYPE_CHIP_MOVE
} EventType;


#endif

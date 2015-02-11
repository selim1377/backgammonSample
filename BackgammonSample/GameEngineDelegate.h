//
//  GameEngineDelegate.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dices.h"
#import "Player.h"

@protocol GameEngineDelegate <NSObject>

-(void)initializeGame;
-(void)gameTurn:(Player *)player;
-(void)dicesRolled:(Dices *)dices;
-(void)playerMoved:(Move *)move;
-(void)playerCannotMove:(Player *)player;

@end

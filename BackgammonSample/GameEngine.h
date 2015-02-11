//
//  GameEngine.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//


#import "BaseModel.h"
#import "GameEngineDelegate.h"
#import "PreGameEngineDelegate.h"
#import "Dices.h"
#import "Player.h"
#import "Board.h"
#import "Move.h"


@interface GameEngine : BaseModel


@property (nonatomic, strong,readonly) NSMutableArray *players;
@property (nonatomic, strong,readonly) Dices          *dices;
@property (nonatomic, strong,readonly) Board          *board;

@property (assign, nonatomic) id<GameEngineDelegate> gameDelegate;
@property (assign, nonatomic) id<PreGameEngineDelegate> preGameDelegate;

@property (assign, nonatomic,readonly) GameState gameState;
@property (assign, nonatomic,readonly) PlayerType currentTurn;

@property (assign, nonatomic) BOOL shouldPersistGame;

// initial setup
-(void)setup;


//game flow methods
-(void)startPreGame;
-(BOOL)shouldDetermineWhoStarts;
-(PlayerType)checkWhoStartsFirst;

-(void)rollDice;

-(NSMutableArray *)movesForLine:(int)lineIndex;
-(void)moveChipFromIndex:(int)from toIndex:(int)to;


//data methods
-(Player *)playerForType:(PlayerType)type;
-(Board *)getBoard;


@end

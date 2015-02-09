//
//  GameEngine.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim ;;. All rights reserved.
//

#import "GameEngine.h"

@interface GameEngine ()


// non public properties
@property (nonatomic, strong,readwrite) NSMutableArray *players;
@property (nonatomic, strong,readwrite) Dices          *dices;
@property (nonatomic, strong,readwrite) Board          *board;

// pre game variables
@property (assign, nonatomic) int preGameDiceRollCount;

@property (assign, nonatomic,readwrite) GameState gameState;
@property (assign, nonatomic,readwrite) PlayerType currentTurn;


// non public methods


@end


@implementation GameEngine

@synthesize players,dices,board;

#pragma mark inital setup
-(void)setup
{
    [self createPlayers];
    [self createBoard];
    [self createDices];
    
    self.gameState = GAMESTATE_SETUP;
}

-(void)createPlayers
{
    // create black player first
    
    Player *blackPLayer = [[Player alloc] initWithType:kBlackPLayer WithName:@"Black One"];
    Player *whitePLayer = [[Player alloc] initWithType:kWhitePlayer WithName:@"White Horse"];
    
    self.players = [NSMutableArray arrayWithObjects:blackPLayer,whitePLayer, nil];
    
}

-(void)createDices
{
    self.dices = [[Dices alloc] init];
}

-(void)createBoard
{
    self.board = [Board new];
}

#pragma mark game flow methods
-(void)startPreGame
{
    // change game state;
    self.gameState = GAMESTATE_PREGAME;
    
    // reset turn status
    // pre game will start with black player again,  after a call to turn.
    [self turn:kBlackPLayer];
}

-(void)turn
{
    if (self.currentTurn == kBlackPLayer) {
        self.currentTurn = kWhitePlayer;
    } else {
        self.currentTurn = kBlackPLayer;
    }
    
    [self turn:self.currentTurn];
}

-(void)turn:(PlayerType)type
{
    self.currentTurn = type;
    
    Player *player = [self playerForType:self.currentTurn];
    [player turn];
    
    player = [self playerForType:[self oppositeType:self.currentTurn]];
    [player loseTurn];
    
}

-(PlayerType)oppositeType:(PlayerType)playerType
{
    int index = ( (int)playerType + 1 ) % 2;
    return index;
}
#pragma mark actual game methods

-(void)startActualGame:(PlayerType)playerType
{
    self.gameState = GAMESTATE_GAME;
    
    // update board
    [self.board positionChipsForGameStart];
    
    // turn to winner
    [self turn:playerType];
    
    if(self.gameDelegate)
        [self.gameDelegate initializeGame];
}

-(void)rollDice
{
    
    if (self.gameState == GAMESTATE_PREGAME) // in pre game every player rolls 1 dice
    {
        
        Dice *dice = [self.dices diceForType:self.currentTurn];         // roll the dice
        [dice rollDiceWithCompletion:^{
            
            self.preGameDiceRollCount ++;                               // hold single dice roll count
            
            BOOL shouldDetermine = [self shouldDetermineWhoStarts];
            if (shouldDetermine) {
                
                self.preGameDiceRollCount = 0;
                
                PlayerType preGameWinner = [self checkWhoStartsFirst];
                
                int type = (int)preGameWinner;
                
                if (type != -1) {
                    [self startActualGame:preGameWinner];
                }
                else                                                // both player rolls the same, roll again
                {
                    [self turn];
                }
            }
            else
            {
                [self turn];
            }
            
        }];
        
    }
    else if (self.gameState == GAMESTATE_GAME) // in  game every player rolls 2 dices both
    {
        self.preGameDiceRollCount = 0;
        
        self.gameState = GAMESTATE_GAME;
        
        [self.dices rollDicesWithCompletion:^{
            
            self.gameState = GAMESTATE_GAME_PLAYER_MOVING;
        }];
        
        
    }
}


-(BOOL)shouldDetermineWhoStarts
{
    return (self.preGameDiceRollCount == 2);
}

-(PlayerType)checkWhoStartsFirst
{
    int blackValue = [self.dices diceForType:kBlackPLayer].value;
    int whiteValue = [self.dices diceForType:kWhitePlayer].value;
    
    if (blackValue == whiteValue)  // if dices equally, return invalid value, to turn again
        return -1;
    
    if(blackValue > whiteValue)
        return kBlackPLayer;
    else
        return kWhitePlayer;
}

-(void)preparePlayerMove
{
    self.gameState = GAMESTATE_GAME_PLAYER_MOVING;
}

-(void)playerShouldMove:(Move *)move
{
    // update models
    [self.board updateMove:move];
    
    //consume in dices
    BOOL consumed = [self.dices consume:move];
    
    if (consumed)
    {
        self.gameState = GAMESTATE_GAME;
        [self turn];
    }
    
}


#pragma mark move calculation methods

-(NSMutableArray *)movesForPlayer:(PlayerType)player withDiceValues:(NSArray *)values fromLine:(int)moveFrom
{
    NSMutableArray *moves = [NSMutableArray new];                     // available moves
    
    for (NSNumber * number in values) {
        
        int diceValue = [number intValue];                              // get desired dice value
        
        Move *move = [self moveWithStart:moveFrom                       // calculate moves due to the player
                             forPlayer:player                           // cw or ccw
                         withDiceValue:diceValue];                      // either the target is safe or not

        if(move)
            [moves addObject:move];
        
    }    
    
    return moves;
}


-(Move *)moveWithStart:(int)startIndex forPlayer:(PlayerType)playerType withDiceValue:(int)value
{
    
    // check the starting line belongs to correct user
    Line *starterLine = [self.board lineForIndex:startIndex];
    
    if(starterLine.owner != playerType)
        return nil;
    
    
    int result = 0;
    
    if (playerType == kBlackPLayer)                                     // game rolls to clockwise
    {
        result = startIndex - value;
    }
    else                                                                // game rolls to ccw
    {
        result = startIndex + value;
    }
    
    Move *move = [Move createMoveFrom:startIndex to:result];            // check move can happen or will break
    
    Line *line = [self.board lineForIndex:result];
    if(!line)                                               // if target is no line, move can not happen
        move.canHappen = NO;
    else
    {
        if(line.owner == playerType)                        // if target is owned by player, move always
            move.canHappen = YES;
        else
        {
            if(!line.isSafe)                                // if target is owned by opponent , but not safe
            {
                move.canHappen = YES;
                
                if(line.owner != kPLayerNone)
                    move.willBreak = YES;
            }
            else                                            // if target is owned by opponent , and also safe
            {
                move.canHappen = NO;
            }
        }
    }
    
    return move;
    
}

-(NSMutableArray *)movesForLine:(int)lineIndex
{
    
    if (self.gameState == GAMESTATE_GAME_PLAYER_MOVING) {
        
        NSMutableArray *availableMoves = [self movesForPlayer:self.currentTurn
                                               withDiceValues:[self.dices valuesOfDices]
                                                     fromLine:lineIndex];
        return availableMoves;
    }
    
    return nil;
}


#pragma mark player methods
-(Player *)playerForType:(PlayerType)type
{
    for (Player *pl in self.players) {
        
        if (pl.playerType == type) {
            return pl;
        }
        
    }    
    return nil;
}

#pragma mark board methods
-(Board *)getBoard
{
    return self.board;
}

-(NSString *)description
{
    return [self.players description];
}

@end

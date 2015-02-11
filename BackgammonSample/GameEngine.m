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
    self.shouldPersistGame = YES;
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

-(void)forceTurnAfterNoMoves
{
    self.gameState = GAMESTATE_GAME;
    [self.gameDelegate playerCannotMove:[self playerForType:self.currentTurn]];
    [self turn];
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
            
            [self preCalculationsBeforeMove];
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

-(void)preCalculationsBeforeMove
{
    // check user has any broken chips
    BOOL userHasBrokenChips = [self.board hasPlayerBrokenChips:self.currentTurn];
    
    
    // check available moves to get inside
    if (userHasBrokenChips)
    {
        int lineIndex = (self.currentTurn == kBlackPLayer)  ? BROKEN_LINE_INDEX_BLACK : BROKEN_LINE_INDEX_WHITE;
        BOOL playerHasMove = [self playerHasAvailableMovesForLine:lineIndex];
        
        if (!playerHasMove)      // user does not have any valid move
        {
            [self forceTurnAfterNoMoves];
        }
    }
    else   // user does not have broken  chips, but rolled very bad, so there is no available move
    {
        BOOL playerHasMove = [self playerHasAvailableMoves];
        if (!playerHasMove)
        {
            [self forceTurnAfterNoMoves];
        }
    }
    
}

-(void)moveChipFromIndex:(int)from toIndex:(int)to
{
    
    NSMutableArray *availableMoves = [self movesForLine:from];
    
    Move *activeMove = nil;
    
    if(availableMoves)
    {
        for (Move *move in availableMoves) {
            
            if(move.from == from &&  move.to == to)
            {
                if(move.canHappen)
                {
                    activeMove = move;
                    [self playerMove:move];
                    break;
                }
                
                
            }
        }
    }

}

-(void)playerMove:(Move *)move
{
    // update models
    [self.board updateMove:move];
    
    //consume in dices
    BOOL consumed = [self.dices consume:move];
    
    // check we have any winner
    BOOL isWinner = [self isWinner:self.currentTurn];
    if (isWinner) {
        NSLog(@"%@ Wins",[self playerForType:self.currentTurn].name);
        return;
    }
    
    if (consumed)
    {
        self.gameState = GAMESTATE_GAME;
        [self turn];
    }
    else
    {
        [self preCalculationsBeforeMove];
    }
    
}


-(BOOL)isWinner:(PlayerType)playerType
{
    NSInteger points = [self.board pointsOfPlayer:playerType];
    if (points == 0)
        return YES;
    
    return NO;
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
    
    BOOL hasBroken = [self.board hasPlayerBrokenChips:playerType];
    BOOL playerIsAtHome = [self playerIsInHome];
    
    if (hasBroken) {

        return [self brokenMoveWithStart:startIndex forPlayer:playerType withDiceValue:value];          // broken chip logic
    }
    else if (playerIsAtHome)                                                                            // collecting logic
    {

        return [self collectMoveWithStart:startIndex forPlayer:playerType withDiceValue:value];
    }
    else                                                                                                // normal moving logic
    {

        return [self normalMoveWithStart:startIndex forPlayer:playerType withDiceValue:value];
    }
    
    
}

-(Move *)normalMoveWithStart:(int)startIndex forPlayer:(PlayerType)playerType withDiceValue:(int)value
{
    Line *starterLine = [self.board lineForIndex:startIndex];
    
    if(starterLine.owner != playerType)
        return nil;
    
    int result = [self calculateMoveFromStart:startIndex forPlayer:playerType withValue:value];
    
    Move *move = [Move createMoveFrom:startIndex to:result value:value];            // check move can happen or will break
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
    
    if ([line isBrokenLine])                  // do not move to the broken lines
        move.canHappen = NO;
    
    return move;
}

-(Move *)brokenMoveWithStart:(int)startIndex forPlayer:(PlayerType)playerType withDiceValue:(int)value
{
    int brokenLineIndex = (playerType == kBlackPLayer) ? BROKEN_LINE_INDEX_BLACK : BROKEN_LINE_INDEX_WHITE;
    
    if(brokenLineIndex != startIndex)
        return nil;
    
    int result = [self calculateMoveFromStart:startIndex forPlayer:playerType withValue:value];
    
    
    Move *move = [Move createMoveFrom:startIndex to:result value:value];            // check move can happen or will break
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

-(Move *)collectMoveWithStart:(int)startIndex forPlayer:(PlayerType)playerType withDiceValue:(int)value
{
    Line *starterLine = [self.board lineForIndex:startIndex];
    
    if(starterLine.owner != playerType)
        return nil;
    
    
    int result = [self calculateMoveFromStart:startIndex forPlayer:playerType withValue:value];
    
    int modifiedResult = result;
    int difference = 0;
    
    if ((self.currentTurn == kBlackPLayer) && (result < 1)) {
        modifiedResult = COLLECT_LINE_INDEX_BLACK;
        difference = 0 - result;
    }
    if ((self.currentTurn == kWhitePlayer) && (result > 24)) {
        modifiedResult = COLLECT_LINE_INDEX_WHITE;
        difference = result - 25;
    }
    
    BOOL canCollect = (modifiedResult != result);       // user can collect via this move
    BOOL forceMoveDisable = NO;
    
    if (canCollect) {
        
        if (difference > 0)   // we check whether the chip can be collected even with bigger dices
        {
            canCollect = [self line:startIndex canCollectWithBiggderDicesByPlayer:playerType];
            
            if(!canCollect)
            forceMoveDisable = YES;

        }
    }
    
    Move *move = [Move createMoveFrom:startIndex to:modifiedResult value:value];      // check move can happen or will break
    Line *line = [self.board lineForIndex:modifiedResult];
    
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
    
    if (forceMoveDisable) {
        move.canHappen = NO;
    }
    
    
    return move;
}

-(int)calculateMoveFromStart:(int)startIndex forPlayer:(PlayerType)playerType withValue:(int)value
{
    int result = 0;
    
    if (playerType == kBlackPLayer)                                     // game rolls to clockwise
    {
        result = startIndex - value;
    }
    else                                                                // game rolls to ccw
    {
        result = startIndex + value;
    }
    
    return result;
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

-(BOOL)playerHasAvailableMovesForLine:(int)lineIndex
{
    NSMutableArray *moves = [self movesForLine:lineIndex];

    BOOL canMove  = NO;
    
    for (Move *move in moves) {
        
        if (move.canHappen) {
            canMove = YES;
        }
    }

    return canMove;
}

-(BOOL)playerHasAvailableMoves
{
    // get all the lines of the player
    NSMutableArray *lineIndices = [self.board linesForPlayer:self.currentTurn];
    BOOL hasMoves = NO;
    
    for (NSNumber *indice in lineIndices) {
        
        int lineIndex = [indice intValue];
        BOOL hasMoveForLine = [self playerHasAvailableMovesForLine:lineIndex];
        if (hasMoveForLine) {
            hasMoves = YES;
        }
    }
    
    return hasMoves;
}

-(BOOL)playerIsInHome
{
    BOOL hasBroken = [self.board hasPlayerBrokenChips:self.currentTurn];  // if player  has broken chips. he can not gather chip
    if (hasBroken) {
        return NO;
    }
    
    
    NSMutableArray *lineIndices = [self.board linesForPlayer:self.currentTurn];
    
    BOOL inHome = YES;
    
    for (NSNumber *indice in lineIndices)
    {
        int lineIndex = [indice intValue];
        BOOL lineAtHome = [self.board index:lineIndex IsAtHomeForPlayer:self.currentTurn];
         
        if (!lineAtHome) {
            inHome = NO;
        }
    }
    
    return inHome;
}

-(BOOL)line:(int)index canCollectWithBiggderDicesByPlayer:(PlayerType)playerType
{
    BOOL canCollect = YES;
    
    NSMutableArray *lineIndices = [self.board linesForPlayer:playerType];
    if (playerType == kBlackPLayer) {
        
        for (NSNumber *indice in lineIndices) {
            
            int ind = [indice intValue];
            if (ind > index)
                canCollect = NO;
            
        }
        
    }
    if (playerType == kWhitePlayer) {
        
        for (NSNumber *indice in lineIndices) {
            
            int ind = [indice intValue];
            if (ind < index)
                canCollect = NO;
            
        }
        
    }
    
    return canCollect;
    
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

#pragma mark resurrection method
-(void)restoreWithDictionary:(NSMutableDictionary *)dictionary
{
    [super restoreWithDictionary:dictionary];
    
    PlayerType type = [[dictionary objectForKey:@"gameTurn"] integerValue];
    [self turn:type];
    
    self.gameState   = [[dictionary objectForKey:@"gameState"] integerValue];
    
    [self.dices restoreWithDictionary:[dictionary objectForKey:@"dices"]];
    [self.board restoreWithDictionary:[dictionary objectForKey:@"board"]];
}
-(NSDictionary *)saveDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInt:self.currentTurn]     forKey:@"gameTurn"];
    [dictionary setObject:[NSNumber numberWithInt:self.gameState]       forKey:@"gameState"];

    
    [dictionary setObject:[self.dices saveDictionary] forKey:@"dices"];
    [dictionary setObject:[self.board saveDictionary] forKey:@"board"];
    
    return dictionary;
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

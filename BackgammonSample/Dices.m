//
//  Dices.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "Dices.h"


@interface Dices ()

@property (nonatomic, strong) NSMutableArray *dices;

@property (assign, nonatomic) int maxMove;
@property (assign, nonatomic) int rolledDiceCount;
@property (assign, nonatomic) BOOL rolledDouble;
@property (nonatomic, strong) NSMutableArray *possibleMoves;

@end

@implementation Dices
@synthesize dices;

-(instancetype)init
{
    if ([super init]) {
        
        
        // initialize two dices
        Dice *dice1 = [Dice new];
        Dice *dice2 = [Dice new];
        
        self.dices = [NSMutableArray arrayWithObjects:dice1,dice2, nil];
        
    }
    
    return self;
}

-(void)rollDicesWithCompletion:(void(^)(void))block
{
    self.rolledDiceCount = 0;
    
    Dice *dice0 = [self.dices objectAtIndex:0];
    
    EventCompletion completion =^{
        
        self.rolledDiceCount ++;
        if(self.rolledDiceCount ==2 )
        {
            [self calculatePossibleMoves];
            block();
        }
    };
    
    
    [dice0 rollDiceWithCompletion:completion];
    
    Dice *dice1 = [self.dices objectAtIndex:1];
    [dice1 rollDiceWithCompletion:completion];
    
}

-(void)calculatePossibleMoves
{
    // reset flag
    self.rolledDouble = NO;
    
    Dice *dice0 = [self.dices objectAtIndex:0];
    Dice *dice1 = [self.dices objectAtIndex:1];
    
    if(dice0.value == dice1.value)
        self.rolledDouble =  YES;
    
    NSLog(@"Rolled Double %d",self.rolledDouble);
    
    // create a new possiblity pool
    self.possibleMoves = [NSMutableArray new];
    
    // if not rolled double
    if(!self.rolledDouble)
    {
        
        self.maxMove = dice0.value + dice1.value;
        self.possibleMoves = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:dice0.value],
                              [NSNumber numberWithInt:dice1.value],
                              [NSNumber numberWithInt:self.maxMove],nil];
    }
    else
    {
        self.maxMove = dice0.value * 4;
        self.possibleMoves = [NSMutableArray arrayWithObjects:  [NSNumber numberWithInt:dice0.value],
                              [NSNumber numberWithInt:dice0.value*2],
                              [NSNumber numberWithInt:dice0.value*3],
                              [NSNumber numberWithInt:self.maxMove],nil];
    }

}

-(void)rollDice:(PlayerType)type
{
    [[self diceForType:type] rollDiceWithCompletion:nil];
}

-(Dice *)diceForType:(PlayerType)type
{
    int index = type;
    Dice *dice = [self.dices objectAtIndex:index];
    return dice;
}

-(BOOL)consume:(Move *)move
{
    
    NSLog(@"Consume %d from %d",move.value,self.maxMove);
    
    self.maxMove = self.maxMove - move.value; // if user consumes all move rights
    
    if(self.maxMove == 0)
        return YES;
    
    
    if(!self.rolledDouble)
    {
        self.possibleMoves = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:self.maxMove],nil];
    }
    else
    {
        int oneDiceValue = [self diceForType:kBlackPLayer].value;
        int loop = self.maxMove / oneDiceValue;
        
        self.possibleMoves = [NSMutableArray new];
        
        for (int i = 1; i <= loop; i++) {
            [self.possibleMoves addObject:[NSNumber numberWithInt:oneDiceValue*i]];
        }
    }
    
    return NO;
}

-(NSArray *)valuesOfDices
{
    return self.possibleMoves;
}

-(BOOL)movesFinished
{
    return (self.maxMove == 0);
}

@end

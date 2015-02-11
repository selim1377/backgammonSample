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

@property (assign, nonatomic,readwrite) int maxMove;
@property (assign, nonatomic) int rolledDiceCount;
@property (assign, nonatomic,readwrite) BOOL rolledDouble;
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
                              [NSNumber numberWithInt:dice1.value],nil];
    }
    else
    {
        self.maxMove = dice0.value * 4;
        self.possibleMoves = [NSMutableArray arrayWithObjects:  [NSNumber numberWithInt:dice0.value],nil];
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
    
    [self createPossibleMoves];
    
    return NO;
}
-(void)createPossibleMoves
{
    if(!self.rolledDouble)
    {
        self.possibleMoves = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:self.maxMove],nil];
    }
    else
    {
        int oneDiceValue = [self diceForType:kBlackPLayer].value;
        
        // this block supports multiple moves at a time
        /*int loop = self.maxMove / oneDiceValue;
         
         self.possibleMoves = [NSMutableArray new];
         
         for (int i = 1; i <= loop; i++) {
         [self.possibleMoves addObject:[NSNumber numberWithInt:oneDiceValue*i]];
         }*/
        
        self.possibleMoves = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:oneDiceValue],nil];
    }
}

-(NSArray *)valuesOfDices
{
    return self.possibleMoves;
}

-(BOOL)movesFinished
{
    return (self.maxMove == 0);
}

-(void)restoreWithDictionary:(NSMutableDictionary *)dictionary
{
    [super restoreWithDictionary:dictionary];
    
    [[self.dices objectAtIndex:0] restoreWithDictionary:[dictionary objectForKey:@"dice0"]];
    [[self.dices objectAtIndex:1] restoreWithDictionary:[dictionary objectForKey:@"dice1"]];
    
    self.possibleMoves = [dictionary objectForKey:@"possibleMoves"];
    self.maxMove       = [[dictionary objectForKey:@"maxMove"] intValue];
    self.rolledDouble  = [[dictionary objectForKey:@"rolledDouble"] boolValue];
}

-(NSMutableDictionary *)saveDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:[[self.dices objectAtIndex:0] saveDictionary] forKey:@"dice0"];
    [dictionary setObject:[[self.dices objectAtIndex:1] saveDictionary] forKey:@"dice1"];
    [dictionary setObject:self.possibleMoves forKey:@"possibleMoves"];
    [dictionary setObject:[NSNumber numberWithInt:self.maxMove] forKey:@"maxMove"];
    [dictionary setObject:[NSNumber numberWithBool:self.rolledDouble] forKey:@"rolledDouble"];
    
    return dictionary;
}

@end

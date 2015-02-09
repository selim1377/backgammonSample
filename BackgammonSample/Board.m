//
//  Board.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "Board.h"

@interface Board ()

@property (nonatomic, strong,readwrite) NSMutableArray *lines;
@property (nonatomic, strong,readwrite) NSMutableArray *chips;

-(void)positionChips:(int)chipCount forLine:(int)lineIndex withPlayerType:(PlayerType)playerType;
-(Line *)lineForIndex:(int)lineIndex;

@end

@implementation Board
@synthesize lines;

-(instancetype)init
{
    if ([super init]) {
        
        [self createLines];
        [self createChips];
    }
    
    return self;
}

-(void)createLines
{
    self.lines = [NSMutableArray new];
    
    // board lines starts 1 to 24
    for (int i = 1; i<=24; i++) {
        
        Line *line = [[Line alloc] initWithIndex:i];
        [self.lines addObject:line];
    }
    
    // add broken line for black player
    Line *line = [[Line alloc] initWithIndex:1000];
    [self.lines addObject:line];
    
    
    // add broken line for white player
    line = [[Line alloc] initWithIndex:1001];
    [self.lines addObject:line];
}

-(void)createChips
{
    self.chips = [NSMutableArray new];
    
    for (int i=0; i<15; i++) {
        Chip *chip = [[Chip alloc] initWithPlayerType:kBlackPLayer];
        [self.chips addObject:chip];
    }
    
    for (int i=0; i<15; i++) {
        Chip *chip = [[Chip alloc] initWithPlayerType:kWhitePlayer];
        [self.chips addObject:chip];
    }
    
}

-(void)positionChipsForGameStart
{
    // create and position for black player first
    [self positionChips:5 forLine:6 withPlayerType:kBlackPLayer];
    [self positionChips:3 forLine:8 withPlayerType:kBlackPLayer];
    [self positionChips:5 forLine:13 withPlayerType:kBlackPLayer];
    [self positionChips:2 forLine:24 withPlayerType:kBlackPLayer];
    
    
    
    // create and position for white player
    [self positionChips:5 forLine:19 withPlayerType:kWhitePlayer];
    [self positionChips:3 forLine:17 withPlayerType:kWhitePlayer];
    [self positionChips:5 forLine:12 withPlayerType:kWhitePlayer];
    [self positionChips:2 forLine:1 withPlayerType:kWhitePlayer];
    
}

-(void)positionChips:(int)chipCount forLine:(int)lineIndex withPlayerType:(PlayerType)playerType
{
    Line *line = [self lineForIndex:lineIndex];
    for (int i =0; i<chipCount; i++) {
        
        Chip *chip = [self popChipForPlayerType:playerType];
        [line push:chip];
    }
}

-(Chip *)popChipForPlayerType:(PlayerType)playerType
{
    int removalIndex = 0;
    Chip *targetChip = nil;
    for (Chip *chip in self.chips) {
        
        if (chip.owner == playerType) {
            
            targetChip = chip;
            
        }
        if(!targetChip)
            removalIndex ++;
        else
            break;
    }
    
    [self.chips removeObjectAtIndex:removalIndex];
    return targetChip;
}

-(Line *)lineForIndex:(int)lineIndex
{
    Line *line = nil;
    
    for (Line *l in self.lines) {
        
        if(l.index == lineIndex)
            line = l;
    }
    
    return line;
}

-(Line *)brokenLineForPlayer:(PlayerType)type
{
    int index = (type == kBlackPLayer) ? 1000 : 1001;
    return [self lineForIndex:index];
}

-(void)updateMove:(Move *)move
{
    Line *source = [self lineForIndex:move.from];
    Line *target = [self lineForIndex:move.to];
    
    if (move.willBreak)
    {
        Chip *brokenChip = [target pop];
        Line *brokenLine = [self brokenLineForPlayer: brokenChip.owner];
        [brokenLine push:brokenChip];
    }

    
    Chip *chip = [source pop];
    [target push:chip];
    
    
}


@end

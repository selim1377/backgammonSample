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
    Line *line = [[Line alloc] initWithIndex:BROKEN_LINE_INDEX_BLACK];
    [self.lines addObject:line];
    
    
    // add broken line for white player
    line = [[Line alloc] initWithIndex:BROKEN_LINE_INDEX_WHITE];
    [self.lines addObject:line];
    
    
    // add collect line for black player
    line = [[Line alloc] initWithIndex:COLLECT_LINE_INDEX_BLACK];
    [self.lines addObject:line];
    
    
    // add broken line for white player
    line = [[Line alloc] initWithIndex:COLLECT_LINE_INDEX_WHITE];
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
    int index = (type == kBlackPLayer) ? BROKEN_LINE_INDEX_BLACK : BROKEN_LINE_INDEX_WHITE;
    return [self lineForIndex:index];
}

-(NSMutableArray *)linesForPlayer:(PlayerType)playerType
{
    NSMutableArray *linesOfPlayer = [NSMutableArray new];
    for (int i=1; i<=24; i++) {
        Line *line = [self lineForIndex:i];
        
        if (line.owner == playerType) {
            
            [linesOfPlayer addObject:[NSNumber numberWithInt:i]];
        }
    }    
    return linesOfPlayer;
}

-(NSInteger)numberOfBrokenChipsForPlayer:(PlayerType)playerType
{
    Line *broken = [self brokenLineForPlayer:playerType];
    return broken.chips.count;
}

-(NSInteger)pointsOfPlayer:(PlayerType)playerType
{
    NSMutableArray *indices = [self linesForPlayer:playerType];
    NSInteger total = 0;
    
    for (NSNumber *indice in indices) {
        
        int lineIndex = [indice intValue];
        Line *line    = [self lineForIndex:lineIndex];
        int multiplier = (playerType == kBlackPLayer) ? lineIndex : ABS(lineIndex - 25);
        
        total = total + (multiplier * line.chips.count);
    }
    
    return total;
}

-(BOOL)hasPlayerBrokenChips:(PlayerType)playerType
{
    NSInteger chips = [self numberOfBrokenChipsForPlayer:playerType];
    return (chips > 0);
}

-(BOOL)index:(int)lineIndex IsAtHomeForPlayer:(PlayerType)playerType
{
    
    if (playerType == kBlackPLayer) {
        
        if(lineIndex >= 1 && lineIndex <= 6)
            return YES;
    }
    
    if (playerType == kWhitePlayer) {
        
        if(lineIndex >= 19 && lineIndex <= 24)
            return YES;
    }
    
    return NO;
}

-(void)updateMove:(Move *)move
{
    Line *source = [self lineForIndex:move.from];
    Line *target = [self lineForIndex:move.to];
    
    if (move.willBreak)
    {
        Chip *brokenChip = [target pop];
        Line *brokenLine = [self brokenLineForPlayer: brokenChip.owner];
        brokenChip.isBroken  = YES;
        [brokenLine push:brokenChip];
    }

    
    Chip *chip = [source pop];
    [target push:chip];
    
    
}

-(void)restoreWithDictionary:(NSMutableDictionary *)dictionary
{
    [super restoreWithDictionary:dictionary];
    
    NSMutableArray *positions = [dictionary objectForKey:@"positions"];
    for (NSMutableDictionary *position in positions) {
        
        int lineIndex       = [[position objectForKey:@"line"] intValue];
        NSInteger chipCount = [[position objectForKey:@"chip"] integerValue];
        PlayerType type     = [[position objectForKey:@"type"] intValue];
        
        [self positionChips:(int)chipCount forLine:lineIndex withPlayerType:type];
        
    }
}

-(NSDictionary *)saveDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableArray *positions = [NSMutableArray new];
    for (Line *line in self.lines) {
        
        int lineIndex = line.index;
        NSInteger chipCount = line.chips.count;
        if (chipCount > 0) {
            PlayerType type = [line lastChip].owner;
            NSMutableDictionary *position = [NSMutableDictionary dictionary];
            [position setObject:[NSNumber numberWithInt:lineIndex]      forKey:@"line"];
            [position setObject:[NSNumber numberWithInteger:chipCount]  forKey:@"chip"];
            [position setObject:[NSNumber numberWithInt:type]           forKey:@"type"];
            
            [positions addObject:position];
        }
    }
    
    [dictionary setObject:positions forKey:@"positions"];
    
    return dictionary;
}


@end

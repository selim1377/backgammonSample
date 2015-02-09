//
//  Line.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim ;. All rights reserved.
//

#import "Line.h"

@interface Line ()


@property (assign, nonatomic,readwrite) int index;
@property (assign, nonatomic,readwrite) BOOL isSafe;
@property (assign, nonatomic,readwrite ) PlayerType owner;

@property (nonatomic, strong,readwrite) NSMutableArray *chips;

@end

@implementation Line

-(instancetype)initWithIndex:(int)index
{
    if ([super init]) {
        
        self.index = index;
        self.isSafe = NO;
        self.owner = kPLayerNone;
        
        self.chips = [NSMutableArray new];
    }

    return self;
}

-(void)push:(Chip *)chip
{
    [self.chips addObject:chip];
    
    int stackIndex = (int)self.chips.count;
    [chip setIndex:self.index andStackIndex:stackIndex-1];
    
    self.owner = chip.owner;
    
    if (self.chips.count >= 2)
        self.isSafe = YES;
    
}

-(Chip *)pop
{
    if(self.chips.count == 0)
        return nil;
    
    Chip *chip = [self.chips lastObject];
    [self.chips removeObject:chip];
    
    if (self.chips.count < 2)
        self.isSafe = NO;
    
    if (self.chips.count == 0)
        self.owner = kPLayerNone;
    
    return chip;
}

-(Chip *)lastChip
{
    return [self.chips lastObject];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Line %d chips %ld owner:%d",self.index,self.chips.count,self.owner];
}


@end

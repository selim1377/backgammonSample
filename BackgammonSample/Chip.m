//
//  Chip.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "Chip.h"
#import "Line.h"

@interface Chip ()

@property (assign, nonatomic,readwrite) PlayerType owner;
@property (assign, nonatomic , readwrite) int lineIndex,stackIndex;

@end

@implementation Chip

-(instancetype)initWithPlayerType:(PlayerType)type
{
    if ([super init]) {
        
        self.owner = type;
    }
    
    return self;
}

-(void)setIndex:(int)lineIndex andStackIndex:(int)stackIndex
{
    self.lineIndex = lineIndex;
    self.stackIndex = stackIndex;
    
    Event *event = [[Event alloc] initWithEntity:self withType:EVENT_TYPE_CHIP_MOVE];
    [self notify:event];
    
}


@end

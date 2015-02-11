//
//  Move.m
//  BackgammonSample
//
//  Created by Selim on 07.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "Move.h"

@interface Move ()

@property (assign, nonatomic,readwrite) int from;
@property (assign, nonatomic,readwrite) int to;
@property (assign, nonatomic,readwrite) int value;

@end

@implementation Move

-(instancetype)init
{
    if ([super init]) {
        
        self.from   = 0;
        self.to     = 0;
        self.value  = 0;
        self.willBreak = NO;
        self.canHappen = YES;
    }
    
    return self;
}

+(Move *)createMoveFrom:(int)f to:(int)t  value:(int)value{
    Move *move = [Move new];
    move.from   = f;
    move.to     = t;
    
    move.value = value;
    
    return move;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"From:%d  To:%d value:%d canHappen:%d  willBreak:%d",self.from,self.to,self.value,self.canHappen,self.willBreak];
}

@end

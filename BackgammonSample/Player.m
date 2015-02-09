//
//  Player.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "Player.h"

@interface Player ()

@property (nonatomic, readwrite, strong) NSString *name;
@property (assign, readwrite ,nonatomic) PlayerType playerType;


@end

@implementation Player


-(id)initWithType:(PlayerType)type WithName:(NSString *)playerName
{
    if ([super init]) {
        
        self.playerType = type;
        self.name       = playerName;
    }
    
    return self;
}

-(void)turn
{
    self.turn = YES;
    
    Event *event = [[Event alloc] initWithEntity:[NSNumber numberWithBool:self.turn] withType:EVENT_TYPE_PLAYER_TURN];
    [self notify:event];
}

-(void)loseTurn
{
    self.turn = NO;
    
    Event *event = [[Event alloc] initWithEntity:[NSNumber numberWithBool:self.turn] withType:EVENT_TYPE_PLAYER_TURN];
    [self notify:event];

}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ %ld",self.name , self.playerType];
}

@end

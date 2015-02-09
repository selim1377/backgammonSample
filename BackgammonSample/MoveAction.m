//
//  MoveAction.m
//  BackgammonSample
//
//  Created by Selim on 07.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "MoveAction.h"

@interface MoveAction ()

@property (nonatomic, strong , readwrite) Move *move;

@end

@implementation MoveAction

+(MoveAction *)actionWithMove:(Move *)move
{
    MoveAction *action = [MoveAction new];
    action.move = move;
    return action;
}


@end

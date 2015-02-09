//
//  MoveAction.h
//  BackgammonSample
//
//  Created by Selim on 07.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "Action.h"
#import "Move.h"

@interface MoveAction : Action

@property (nonatomic, strong , readonly) Move *move;

+(MoveAction *)actionWithMove:(Move *)move;
@end

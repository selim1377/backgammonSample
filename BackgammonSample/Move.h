//
//  Move.h
//  BackgammonSample
//
//  Created by Selim on 07.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "BaseModel.h"

@interface Move : BaseModel

@property (assign, nonatomic,readonly) int from;
@property (assign, nonatomic,readonly) int to;
@property (assign, nonatomic,readonly) int value;

@property (assign, nonatomic) BOOL canHappen;
@property (assign, nonatomic) BOOL willBreak;

+(Move *)createMoveFrom:(int)f to:(int)t;

@end

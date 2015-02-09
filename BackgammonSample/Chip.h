//
//  Chip.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "BaseModel.h"

@interface Chip : BaseModel

@property (assign, nonatomic,readonly) PlayerType owner;
@property (assign, nonatomic , readonly) int lineIndex,stackIndex;


-(instancetype)initWithPlayerType:(PlayerType)type;
-(void)setIndex:(int)lineIndex andStackIndex:(int)stackIndex;
@end

//
//  Line.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "BaseModel.h"
#import "Chip.h"

@interface Line : BaseModel

@property (assign, nonatomic,readonly) int  index;
@property (assign, nonatomic,readonly) BOOL isSafe;
@property (assign, nonatomic,readonly ) PlayerType owner;

@property (nonatomic, strong,readonly) NSMutableArray *chips;

-(id)initWithIndex:(int)index;

-(void)push:(Chip *)chip;
-(Chip *)pop;
-(Chip *)lastChip;

@end

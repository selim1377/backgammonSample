//
//  Line.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "BaseModel.h"
#import "Chip.h"

#define BROKEN_LINE_INDEX_BLACK 25
#define BROKEN_LINE_INDEX_WHITE 0

#define COLLECT_LINE_INDEX_BLACK 30
#define COLLECT_LINE_INDEX_WHITE 31

@interface Line : BaseModel

@property (assign, nonatomic,readonly) int  index;
@property (assign, nonatomic,readonly) BOOL isSafe;
@property (assign, nonatomic,readonly ) PlayerType owner;

@property (nonatomic, strong,readonly) NSMutableArray *chips;

-(id)initWithIndex:(int)index;

-(void)push:(Chip *)chip;
-(Chip *)pop;
-(Chip *)lastChip;
-(BOOL)isBrokenLine;

@end

//
//  Board.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "BaseModel.h"
#import "Line.h"
#import "Move.h"

@interface Board : BaseModel

@property (nonatomic, strong,readonly) NSMutableArray *lines;
@property (nonatomic, strong,readonly) NSMutableArray *chips;

-(void)createLines;
-(void)positionChipsForGameStart;

-(Line *)lineForIndex:(int)lineIndex;

-(NSMutableArray *)linesForPlayer:(PlayerType)playerType;

-(Line *)brokenLineForPlayer:(PlayerType)type;

-(NSInteger)numberOfBrokenChipsForPlayer:(PlayerType)playerType;

-(NSInteger)pointsOfPlayer:(PlayerType)playerType;

-(BOOL)hasPlayerBrokenChips:(PlayerType)playerType;

-(BOOL)index:(int)lineIndex IsAtHomeForPlayer:(PlayerType)playerType;

-(void)updateMove:(Move *)move;



// line returnin functions
//-(Line *)getLineByIndex;


@end

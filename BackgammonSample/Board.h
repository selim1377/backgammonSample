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
-(Line *)brokenLineForPlayer:(PlayerType)type;
-(void)updateMove:(Move *)move;

// line returnin functions
//-(Line *)getLineByIndex;


@end

//
//  Player.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "BaseModel.h"

@interface Player : BaseModel

@property (nonatomic, readonly, strong) NSString *name;
@property (assign, readonly ,nonatomic) PlayerType playerType;
@property (assign, nonatomic ,getter=hasTurn) BOOL turn;

-(id)initWithType:(PlayerType)type WithName:(NSString *)playerName;
-(void)turn;
-(void)loseTurn;

@end

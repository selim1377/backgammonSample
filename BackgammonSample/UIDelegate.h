//
//  UIDelegate.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIDelegate <NSObject>

-(void)currentPlayerWantsToRollDice;
-(void)currentPLayerWantsToMove:(Move *)move;

@end

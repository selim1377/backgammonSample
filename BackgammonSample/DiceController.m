//
//  DiceController.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "DiceController.h"
#import "DiceView.h"

@interface DiceController  ()

@property (nonatomic, strong) DiceView * blackDiceView, *whiteDiceView;
@property (assign, nonatomic) int rolledDiceCount;

@end


@implementation DiceController

-(void)generateViewsFromView:(UIView *)parentView
{
    self.blackDiceView =  (DiceView*) [parentView subviewWithTag:0];
    self.whiteDiceView =  (DiceView*) [parentView subviewWithTag:1];
}


-(void)createBindings
{
    Dice *dice = [self.gameEngine.dices diceForType:kBlackPLayer];
    [dice addObserver:self.blackDiceView];
    
    dice = [self.gameEngine.dices diceForType:kWhitePlayer];
    [dice addObserver:self.whiteDiceView];
}




@end

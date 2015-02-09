//
//  PlayerController.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "PlayerController.h"
#import "PlayerView.h"





@interface PlayerController ()

@property (nonatomic, strong) PlayerView* blackPlayerView, *whitePlayerView;

@end

@implementation PlayerController
@synthesize blackPlayerView,whitePlayerView;

-(void)generateViewsFromView:(UIView *)parentView
{
    self.blackPlayerView = (PlayerView *) [parentView viewWithTag:20];
    self.whitePlayerView = (PlayerView *) [parentView viewWithTag:21];
    
    self.whitePlayerView.transform  = CGAffineTransformMakeRotation(M_PI);
    
    
    // clear player views
    [self.blackPlayerView hideRollDiceButton];
    [self.whitePlayerView hideRollDiceButton];
    
    // Roll dice actions
    [[self.blackPlayerView rollDiceButton] addTarget:self
                                              action:@selector(onRollDice:)
                                    forControlEvents:UIControlEventTouchUpInside];
    
    [[self.whitePlayerView rollDiceButton] addTarget:self
                                              action:@selector(onRollDice:)
                                    forControlEvents:UIControlEventTouchUpInside];
    [self showPlayerLabels];
}

-(void)createBindings
{
    Player *player = [self.gameEngine.players objectAtIndex:kBlackPLayer];
    [player addObserver:self.blackPlayerView];
    
    player = [self.gameEngine.players objectAtIndex:kWhitePlayer];
    [player addObserver:self.whitePlayerView];
}

-(void)showPlayerLabels
{
    // update views with players
    [self.blackPlayerView showPlayerInfo:[self.gameEngine playerForType:kBlackPLayer].name];
    [self.whitePlayerView showPlayerInfo:[self.gameEngine playerForType:kWhitePlayer].name];
}

-(PlayerView *)viewForPlayer:(Player *)player
{
    if (player.playerType == kBlackPLayer) {
        return self.blackPlayerView;
    }
    else if (player.playerType == kWhitePlayer)
    {
        return self.whitePlayerView;
    }
    
    return nil;
}

#pragma mark button actions
-(void)onRollDice:(id)sender
{
    // inform game controller to update game engine
    if (self.uidelegate)
        [self.uidelegate currentPlayerWantsToRollDice];

    
    // hide roll dice button to confuse
    UIButton *rollDiceButton = sender;
    rollDiceButton.hidden = YES;
}

@end

//
//  GameController.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameEngine.h"
#import "Actions.h"
#import "PlayerController.h"
#import "BoardController.h"
#import "DiceController.h"

#import "UIView+Animation.h"

@interface GameController : UIViewController< GameEngineDelegate,PreGameEngineDelegate,UIDelegate>


// Controllers
@property (nonatomic, strong) PlayerController  *playerController;
@property (nonatomic, strong) DiceController    *diceController;
@property (nonatomic, strong) BoardController   *boardController;


// Game engine instance
@property (nonatomic, strong) GameEngine *gameEngine;


// IBActions from UI
- (IBAction)onNewGame:(id)sender;


//IBOutlets from UI
@property (weak, nonatomic) IBOutlet UIView *startGameView;
@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (weak, nonatomic) IBOutlet UIView *dicesView;

@end

//
//  GameController.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "GameController.h"

@interface GameController ()

@end

@implementation GameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self gameSetup];
}

#pragma mark initial setup

-(void)gameSetup
{
    [self setupGameEngine];
    [self setupControllers];
}

-(void)setupGameEngine
{
    self.gameEngine = [GameEngine new];
    self.gameEngine.gameDelegate = self;
    self.gameEngine.preGameDelegate = self;
    
    [self.gameEngine setup];
}


-(void)setupControllers
{
    self.playerController = [[PlayerController alloc] initWithGameEngine:self.gameEngine];
    self.boardController  = [[BoardController alloc] initWithGameEngine:self.gameEngine];
    self.diceController   = [[DiceController alloc] initWithGameEngine:self.gameEngine];
    
    // assign ui delegate to the controllers
    self.playerController.uidelegate = self;
    self.boardController.uidelegate = self;
    self.diceController.uidelegate = self;
    
    
    // assign views to the sub controllers
    [self.playerController generateViewsFromView:self.view];
    [self.diceController generateViewsFromView:self.dicesView];
    [self.boardController generateViewsFromView:self.boardView];
    
    
    [self.playerController createBindings];
    [self.diceController createBindings];
    [self.boardController createBindings];
}

#pragma mark pre game engine delegate
-(void)initializePregame
{
    
}
-(void)preGameTurn:(Player *)player
{
    
}

-(void)preGameDiceRoll:(Dice *)dice determine:(BOOL)shouldDetermine
{
    
}


#pragma mark game engine delegate
-(void)initializeGame
{
    NSLog(@"initializeGame");
    // game starts now
    
    // redraw chips on board
    //[self.boardController positionChipViewsForGame:[self.gameEngine getBoard]];

}

-(void)gameTurn:(Player *)player
{
    
}

-(void)dicesRolled:(Dices *)dices
{
    
}


-(void)playerBreak:(Move *)move
{
    MoveAction *action = [MoveAction actionWithMove:move];
    [action setCompletion:^(Action *a) {
        
        NSLog(@"Break completed");
    }];
    [self.boardController showBreakAnimation:action];
}

#pragma mark ui delegates
-(void)currentPlayerWantsToRollDice
{
    // game engine rolls dice
    [self.gameEngine rollDice];    
}

-(void)currentPLayerWantsToMove:(Move *)move
{
    [self.gameEngine playerShouldMove:move];
}


#pragma mark uiviewcontroller methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark IBActions
- (IBAction)onNewGame:(id)sender
{
    // remove new game screen
    [self.startGameView disappear];
    
    //start game from scratch
    [self.gameEngine startPreGame];   
}
@end

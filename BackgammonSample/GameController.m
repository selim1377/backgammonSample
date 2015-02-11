//
//  GameController.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "GameController.h"
#import "LocalData.h"
#import "Notifications.h"
#import "GameState.h"


@interface GameController ()


@end

@implementation GameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //register to notifications, in order to save and restore data
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onSaveNotification:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onRestoreNotification:)
                                                 name:NOTIFICATION_APP_RESTORE
                                               object:nil];
    
    

    [self gameSetup];
    
    [self performSelector:@selector(checkSavedData)
               withObject:nil
               afterDelay:1.0];
    
}

-(void)checkSavedData
{
    // check previous state of the game is saved.
    BOOL gameSaved = [LocalData shouldLoadGame];
    if (gameSaved) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_APP_RESTORE
                                                            object:nil];
    }
    
    //[LocalData clear];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_APP_RESTORE
                                                  object:nil];
    
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
}

-(void)gameTurn:(Player *)player
{
    
}

-(void)dicesRolled:(Dices *)dices
{
    
}


-(void)playerCannotMove:(Player *)player
{
    // show an alert
    /*[[[UIAlertView alloc] initWithTitle:@"Warning"
                               message:[NSString stringWithFormat:@"%@ has no moves",player.name]
                              delegate:self
                     cancelButtonTitle:nil
                     otherButtonTitles:@"OK", nil] show];;*/


    NSLog(@"%@ has no move",player.name);
}

-(void)playerMoved:(Move *)move
{
    
}

#pragma mark ui delegates
-(void)currentPlayerWantsToRollDice
{
    // game engine rolls dice
    [self.gameEngine rollDice];    
}

#pragma mark uialertview delegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
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

#pragma mark save state methods
-(void)onSaveNotification:(NSNotification *)notification
{
    // save the game only in actual game
    if (self.gameEngine.gameState > GAMESTATE_PREGAME) {
        
        [LocalData save];
        
        // save current turn and current game state
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:[self.gameEngine saveDictionary] forKey:@"game"];
        
        [prefs synchronize];
        
        
    }
    else
    {
        [LocalData clear];
    }
}

-(void)onRestoreNotification:(NSNotification *)notification
{
    
    // remove new game screen
    [self.startGameView disappear];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [self.gameEngine restoreWithDictionary:[prefs objectForKey:@"game"]];
}

@end

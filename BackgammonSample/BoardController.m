//
//  BoardController.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "BoardController.h"
#import "Chip.h"

@interface BoardController ()

@property (nonatomic, strong) UIView *boardSideLeft;
@property (nonatomic, strong) UIView *boardSideRight;
@property (nonatomic, strong) UIView *boardView;

@property (assign, nonatomic) int lastSelectedLine;

-(void)positionChips:(int)chipCount forLine:(int)lineIndex withPlayerType:(PlayerType)playerType;


@end

@implementation BoardController

#pragma mark creating methods

-(void)generateViewsFromView:(UIView *)parentView
{
    self.boardView = parentView;
    
    self.boardSideLeft  = [parentView subviewWithTag:1];
    self.boardSideRight = [parentView subviewWithTag:2];
    
    // assign tap events to lineviews
    for (int i=1; i<=24; i++) {
        
        LineView *lineView =[self lineWithIndex:i];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(onLineTap:)];
        [lineView addGestureRecognizer:tap];
    }
    
    // transform lines below to adjust frames easier
     for (int i=1; i<=12; i++) {
         LineView *lineView =[self lineWithIndex:i];
         lineView.transform  = CGAffineTransformMakeRotation(M_PI);
     }
    
    // create chips at startup
    [self createChips];
    
}

-(void)createBindings
{
    for (int i=0; i<15; i++)
    {
        ChipView *chipView = [ChipView createPlayerType:kBlackPLayer];
        chipView.delegate = self;
        chipView.center = CGPointMake(self.boardView.center.x, 0);
        Chip *chip = [self.gameEngine.board.chips objectAtIndex:i];
        [chip addObserver:chipView];
        [self.boardView addSubview:chipView];
    }
    
    for (int i=15; i<30; i++)
    {
        ChipView *chipView = [ChipView createPlayerType:kWhitePlayer];
        chipView.delegate = self;
        chipView.center = CGPointMake(self.boardView.center.x, 0);
        Chip *chip = [self.gameEngine.board.chips objectAtIndex:i];
        [chip addObserver:chipView];
        [self.boardView addSubview:chipView];
    }
}

-(void)createChips
{
    
}

-(CGRect)availableRectForLine:(int)lineIndex andStackIndex:(int)stackIndex
{
    
    NSLog(@"Line index %d stack Index %d",lineIndex,stackIndex);
    
    LineView *lineView = [self lineWithIndex:lineIndex];
    CGRect frame = [lineView availableFrameForChipIndex:stackIndex];
    CGRect targetFrameInSuperview = [lineView convertRect:frame toView:self.boardView];
    return targetFrameInSuperview;
}

-(void)positionChipViewsForGame:(Board *)board
{
    for (Line *line in board.lines) {
        [self positionChips:(int)line.chips.count forLine:line.index withPlayerType:line.owner];        
    }
    
}

-(void)positionChips:(int)chipCount forLine:(int)lineIndex withPlayerType:(PlayerType)playerType
{
    for (int i=0; i<chipCount; i++) {
        
        ChipView *chip = [ChipView createPlayerType:playerType];
        LineView *lineView =[self lineWithIndex:lineIndex];
        
        [lineView push:chip];
        
    }
}

#pragma mark action and animation methods

-(LineView *)lineWithIndex:(int)index
{
    
    
    UIView *subjectParent = nil;
    
    if((index >= 1 && index <= 6) || (index >= 19 && index <= 24)) // these indexes belongs to left board
        subjectParent = self.boardSideLeft;
    if((index >= 7 && index <= 12) || (index >= 13 && index <= 18)) // these indexes belongs to right board
        subjectParent = self.boardSideRight;
    
    if(subjectParent)
    {
        LineView *lineView = (LineView *) [subjectParent subviewWithTag:index];
        return lineView;
    }
    else if(index == 1000 || index == 1001)
    {
        LineView *lineView = (LineView *) [self.boardView subviewWithTag:index];
        return lineView;
    }
    
    return nil;
}

-(LineView *)brokenLineViewForPlayer:(PlayerType)type
{
    int tag = (type == kBlackPLayer) ? 1000 : 1001;
    UIView *board = self.boardSideLeft.superview;
    LineView *brokenLine = (LineView *) [board subviewWithTag:tag];
    return brokenLine;
}

-(void)resetLines
{
    for (int i=0; i<=24; i++)
    {
        LineView *line = [self lineWithIndex:i];
        [line reset];
    }
    
    self.lastSelectedLine = 0;     // reset the selection history
}


-(void)onLineTap:(UITapGestureRecognizer *)tap
{
    LineView *lineView = (LineView *) tap.view;
    int lineIndex = [lineView index];
    
    
    if(lineView.highlighted)
    {
        if(lineIndex != self.lastSelectedLine)
        {
           [self moveChipFromIndex:self.lastSelectedLine toIndex:lineIndex];
        }
        [self resetLines];
        return;
    }
    
    // get all available moves
    NSMutableArray *availableMoves = [self.gameEngine movesForLine:lineIndex];
    
    NSLog(@"available Moves %@",availableMoves);
    
    if(availableMoves)
    {
        // Reset the appearance of lines
        [self resetLines];
        
        for (Move *move in availableMoves) {
            
            LineView *targetView = [self lineWithIndex:move.to];
            LineView *sourceView = [self lineWithIndex:move.from];
            
            [sourceView highlight:YES];
            [targetView highlight:move.canHappen];
        }
        
        self.lastSelectedLine = lineIndex;
    }

}

-(void)moveChipFromIndex:(int)from toIndex:(int)to
{
    NSMutableArray *availableMoves = [self.gameEngine movesForLine:from];
    
    Move *activeMove = nil;
    
    if(availableMoves)
    {
        for (Move *move in availableMoves) {
            
            if(move.from == from &&  move.to == to)
            {
                if(move.canHappen)
                {
                    activeMove = move;
                    [self.uidelegate  currentPLayerWantsToMove:move];
                }
                
                                                                                // transfer users move action to game controller
            }                                                                   // so we change the game engine
        }
    }
    
}

-(void)showMoveAnimation:(MoveAction *)action
{
    LineView *targetView = [self lineWithIndex:action.move.to];
    LineView *sourceView = [self lineWithIndex:action.move.from];
    
    [self moveChipFromLine:sourceView toLineView:targetView withMoveAction:action];

}

-(void)showBreakAnimation:(MoveAction *)action
{
    LineView *sourceView = [self lineWithIndex:action.move.to];
    PlayerType brokenPlayerType = [sourceView pop].playerType;
    
    LineView *targetView = [self brokenLineViewForPlayer:brokenPlayerType];

    [self moveChipFromLine:sourceView toLineView:targetView withMoveAction:action];
}

-(void)moveChipFromLine:(LineView *)sourceView toLineView:(LineView *)targetView  withMoveAction:(MoveAction *)action
{
    ChipView *chip = [sourceView pop];
    
    // get the whole board
    UIView *parentView = self.boardSideLeft.superview;
    
    CGRect fr = [sourceView convertRect:chip.frame toView:parentView];
    
    chip.frame = fr;
    [parentView addSubview:chip];
    
    CGRect targetFrame = [targetView availableFrameForChipIndex:targetView.chipCount + 1];
    CGRect targetFrameInSuperview = [targetView convertRect:targetFrame toView:parentView];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         chip.frame = targetFrameInSuperview;
                         
                     } completion:^(BOOL finished) {
                         
                         
                         chip.frame = targetFrame;
                         [targetView push:chip];
                         
                         if(action.completion)
                             action.completion(action);
                     }];
}





@end

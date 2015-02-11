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
        [lineView reset];
    }
    
    
    LineView *brokenLine  = [self brokenLineViewForPlayer:kBlackPLayer];
    [brokenLine addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(onLineTap:)]];
    brokenLine.transform  = CGAffineTransformMakeRotation(M_PI);
    
    
    brokenLine = [self brokenLineViewForPlayer:kWhitePlayer];
    [brokenLine addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(onLineTap:)]];
    
    LineView *collectLine = [self collectLineViewForPlayer:kBlackPLayer];
    [collectLine addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(onLineTap:)]];
    collectLine.transform  = CGAffineTransformMakeRotation(M_PI);
    
    
    collectLine = [self collectLineViewForPlayer:kWhitePlayer];
    [collectLine addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(onLineTap:)]];
    
    
    // transform lines below to adjust frames easier
     for (int i=1; i<=12; i++) {
         LineView *lineView =[self lineWithIndex:i];
         lineView.transform  = CGAffineTransformMakeRotation(M_PI);
     }
    
    
}

-(void)createBindings
{
    for (int i=0; i<30; i++)
    {
        PlayerType type = (i<15) ? kBlackPLayer : kWhitePlayer;
        
        ChipView *chipView = [ChipView createPlayerType:type];
        chipView.delegate = self;
        chipView.center = CGPointMake(self.boardView.center.x, -1000
                                      );
        //chipView.hidden = YES;
        
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
    
    LineView *lineView = [self lineWithIndex:lineIndex];
    CGRect frame = [lineView availableFrameForChipIndex:stackIndex];
    CGRect targetFrameInSuperview = [lineView convertRect:frame toView:self.boardView];
    return targetFrameInSuperview;  
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
    else if(index == BROKEN_LINE_INDEX_WHITE || index == BROKEN_LINE_INDEX_BLACK)
    {
        LineView *lineView = (LineView *) [self.boardView subviewWithTag:index];
        return lineView;
    }
    else if(index == COLLECT_LINE_INDEX_WHITE || index == COLLECT_LINE_INDEX_BLACK)
    {
        LineView *lineView = (LineView *) [self.boardView subviewWithTag:index];
        return lineView;
    }
    
    return nil;
}

-(LineView *)brokenLineViewForPlayer:(PlayerType)type
{
    int tag = (type == kBlackPLayer) ? BROKEN_LINE_INDEX_BLACK  : BROKEN_LINE_INDEX_WHITE;
    UIView *board = self.boardSideLeft.superview;
    LineView *brokenLine = (LineView *) [board subviewWithTag:tag];
    return brokenLine;
}

-(LineView *)collectLineViewForPlayer:(PlayerType)type
{
    int tag = (type == kBlackPLayer) ? COLLECT_LINE_INDEX_BLACK  : COLLECT_LINE_INDEX_WHITE;
    LineView *collectLine = (LineView *) [self.boardView subviewWithTag:tag];
    return collectLine;
}

-(void)resetLines
{
    for (int i=0; i<=25; i++)
    {
        LineView *line = [self lineWithIndex:i];
        [line reset];
    }
    
    LineView *line = [self lineWithIndex:COLLECT_LINE_INDEX_BLACK];
    [line reset];
    line = [self lineWithIndex:COLLECT_LINE_INDEX_WHITE];
    [line reset];
    
    self.lastSelectedLine = 0;     // reset the selection history
}


-(void)onLineTap:(UITapGestureRecognizer *)tap
{
    LineView *lineView = (LineView *) tap.view;
    int lineIndex = [lineView index];
    
    NSLog(@"tap %d",lineIndex);
    
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
    [self.gameEngine moveChipFromIndex:from toIndex:to];
}

@end

//
//  DiceView.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "DiceView.h"

@interface DiceView ()

@property (assign, nonatomic) int frameCount;
@property (assign, nonatomic) int currentFrameIndex;
@property (assign, nonatomic) int actualValue;

@end

@implementation DiceView
@synthesize completion;


-(void)presentDiceValue:(int)value
{
    UILabel *label = (UILabel*) [self subviewWithTag:1];
    if (label)
        label.text = [NSString stringWithFormat:@"%d",value];
}

-(void)animateWithValue:(int)value 
{
    self.frameCount = (int) (arc4random() % 10 + 5);
    self.currentFrameIndex = 0;
    self.actualValue = value;
    
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 0.1
                                                  target: self
                                                selector:@selector(onTick:)
                                                userInfo: nil repeats:YES];
    [t timeInterval];
}

-(void)onTick:(NSTimer *)timer
{
    
    if (self.currentFrameIndex >= self.frameCount) // if dice stop to roll, stop the timer and set the result to the dice
    {
        
        [timer invalidate];
        timer = nil;
        
        [self presentDiceValue:self.actualValue];
        
        // event completion fires
        if(self.completion)
        self.completion();
        
        return;
    }

    // dice is rollin, show random numbers on dice
    
    int randomValue = (int) (arc4random() % 6 + 1);
    [self presentDiceValue:randomValue];
    
    
    // increment rolled dice count
    self.currentFrameIndex++;
}

-(void)onNotify:(Event *)event
{
    [super onNotify:event];
    
    if (event.eventType == EVENT_TYPE_DICE_ROLL) {
        
        int value = [event.entity intValue];
        [self animateWithValue:value];
    }
    
    if (event.eventType == EVENT_TYPE_DICE_RESTORE) {
        
        int value = [event.entity intValue];
        [self presentDiceValue:value];
    }
    
}

@end

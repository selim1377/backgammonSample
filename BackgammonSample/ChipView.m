//
//  ChipView.m
//  BackgammonSample
//
//  Created by Selim on 05.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "ChipView.h"
#import "Chip.h"

@interface ChipView ()

@property (assign, nonatomic , readwrite) PlayerType playerType;

@end

@implementation ChipView

+(instancetype)createPlayerType:(PlayerType)type
{
    ChipView *view = (ChipView *) [[[NSBundle mainBundle] loadNibNamed:@"ChipView" owner:self options:nil] objectAtIndex:0];
    view.playerType = type;
    view.userInteractionEnabled = NO;
    view.tag = (type == kBlackPLayer) ? 50 : 51;
    
    view.colorView.backgroundColor = view.playerType == kBlackPLayer ? [UIColor blackColor] : [UIColor whiteColor];
    
    return view;
}

-(void)onNotify:(Event *)event
{
    Chip *chip = event.entity;
    
    CGRect fr = [self.delegate availableRectForLine:chip.lineIndex andStackIndex:chip.stackIndex];

    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         self.frame = fr;
                         
                     } completion:^(BOOL finished) {
                         
                         if(event.completion)
                             event.completion();
                         
                     }];
    
}


@end

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

-(instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.colorView = [[UIView alloc] initWithFrame:CGRectInset(self.frame, 2, 2)];
        self.colorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.colorView];
        
        NSDictionary *viewsDictionary = @{@"subView":self.colorView};
        
        NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[subView]-2-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:viewsDictionary];
        
        NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2-[subView]-2-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:viewsDictionary];
        
        [self addConstraints:constraint_POS_V];
        [self addConstraints:constraint_POS_H];
        
        self.backgroundColor = [UIColor clearColor];
    }

    return self;
}


+(instancetype)createPlayerType:(PlayerType)type
{
    ChipView *view = [[ChipView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
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

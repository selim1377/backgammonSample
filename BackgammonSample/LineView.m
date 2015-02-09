//
//  LineView.m
//  BackgammonSample
//
//  Created by Selim on 05.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "LineView.h"

@interface LineView ()


@property (assign, nonatomic,readwrite) BOOL highlighted;

-(CGRect)availableFrameForChipIndex:(int)chipIndex;

@end


@implementation LineView

-(void)push:(ChipView *)chip
{
    CGRect frame = [self availableFrameForChipIndex:self.chipCount];
    chip.frame = frame;
    [self addSubview:chip];
    self.chipCount ++;
}

-(ChipView *)pop
{
    NSArray *subviews = [self subviews];
    if(subviews.count > 0)
    {
        ChipView * chip = [subviews objectAtIndex: --self.chipCount];
        return chip;
    }
    
    return nil;
}

-(CGRect)availableFrameForChipIndex:(int)chipIndex
{
    CGFloat dimension = self.frame.size.height / 5;
    
    CGFloat y = (dimension * chipIndex);
    CGFloat x = (self.frame.size.width - dimension) / 2;
    
    return CGRectMake(x, y, dimension, dimension);
}



-(int)index
{
    int ind = (int) self.tag;
    return ind;
}


-(void)highlight:(BOOL)available
{
    self.backgroundColor =  ( available ?  [UIColor blueColor] : [UIColor redColor] );
    self.highlighted = YES;
}

-(void)reset
{
    self.backgroundColor = [UIColor brownColor];
    self.highlighted = NO;
}

@end

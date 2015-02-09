//
//  LineView.h
//  BackgammonSample
//
//  Created by Selim on 05.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChipView.h"

@interface LineView : UIView

@property (assign, nonatomic,readonly) BOOL highlighted;

@property (assign, nonatomic) int chipCount;

-(void)push:(ChipView *)chip;
-(ChipView *)pop;
-(int)index;
-(CGRect)availableFrameForChipIndex:(int)chipIndex;

-(void)highlight:(BOOL)available;
-(void)reset;

@end

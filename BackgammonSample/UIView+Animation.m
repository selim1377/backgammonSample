//
//  UIView+Animation.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

-(void)disappear
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                        
                         self.hidden = YES;
                         
                     }];
}


@end

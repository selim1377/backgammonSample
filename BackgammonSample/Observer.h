//
//  Observer.h
//  BackgammonSample
//
//  Created by Selim on 09.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import <UIKit/UIKit.h>

@class Observable;
@interface Observer : UIView

@property (assign, nonatomic) Observable *observable;
@property (nonatomic,copy) EventCompletion completion;


-(void)onNotify:(Event *)event;

@end

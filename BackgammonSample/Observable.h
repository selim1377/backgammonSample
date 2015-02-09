//
//  Observable.h
//  BackgammonSample
//
//  Created by Selim on 09.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Observer.h"

@interface Observable : NSObject

-(void)addObserver:(Observer *)observer;
-(void)removeObserver:(Observer *)observer;
-(void)notify:(Event *)event;

@end

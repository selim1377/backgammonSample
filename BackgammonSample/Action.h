//
//  Action.h
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Action;
typedef void (^CompletionBlock)(Action *action);

@interface Action : NSObject

@property (nonatomic,copy) CompletionBlock completion;

- (void)setCompletion:(CompletionBlock)completionBlock;

@end

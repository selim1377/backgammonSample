//
//  Event.h
//  BackgammonSample
//
//  Created by Selim on 09.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventType.h"

typedef void (^EventCompletion)(void);

@interface Event : NSObject

@property (nonatomic,assign,readonly) EventType eventType;
@property (nonatomic, strong,readonly) id entity;
@property (nonatomic,copy) EventCompletion completion;

-(void)setCompletion:(EventCompletion)completionBlock;

-(id)initWithEntity:(id)entity withType:(EventType)eventType;

@end

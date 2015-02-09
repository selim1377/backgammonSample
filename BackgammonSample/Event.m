//
//  Event.m
//  BackgammonSample
//
//  Created by Selim on 09.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "Event.h"

@interface Event ()

@property (nonatomic,assign,readwrite) EventType eventType;
@property (nonatomic, strong,readwrite)  id entity;

@end

@implementation Event

-(id)initWithEntity:(id)entity withType:(EventType)eventType
{
    if ([super init]) {
        
        self.eventType = eventType;
        self.entity    = entity;
    }
    
    return self;
}

@end

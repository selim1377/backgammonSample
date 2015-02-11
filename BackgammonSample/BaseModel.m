//
//  BaseModel.m
//  BackgammonSample
//
//  Created by Selim on 04.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(NSDictionary *)saveDictionary
{
    return [NSDictionary dictionary];
}

-(void)restoreWithDictionary:(NSMutableDictionary *)dictionary
{
    NSLog(@"%@ -> %@",[self class],dictionary);
}

@end

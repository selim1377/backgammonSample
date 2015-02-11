//
//  LocalData.h
//  BackgammonSample
//
//  Created by Selim on 10.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalData : NSObject

+(BOOL)shouldLoadGame;
+(void)save;
+(void)clear;

@end

//
//  LocalData.m
//  BackgammonSample
//
//  Created by Selim on 10.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "LocalData.h"

@implementation LocalData

+(BOOL)shouldLoadGame
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    BOOL shouldLoad = [prefs boolForKey:@"shouldLoad"];
    
    return shouldLoad;
}

+(void)save
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:YES forKey:@"shouldLoad"];
    [prefs synchronize];
}

+(void)clear
{
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
}




@end

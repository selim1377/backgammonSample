//
//  ChipView.h
//  BackgammonSample
//
//  Created by Selim on 05.02.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
#import "Observer.h"

@protocol ChipViewDelegate;
@interface ChipView : Observer

@property (assign, nonatomic , readonly) PlayerType playerType;
@property (strong, nonatomic)  UIView *colorView;
@property (assign, nonatomic) id<ChipViewDelegate> delegate;

+(instancetype)createPlayerType:(PlayerType)type;

@end

@protocol ChipViewDelegate <NSObject>
-(CGRect)availableRectForLine:(int)lineIndex andStackIndex:(int)stackIndex;
@end

//
//  UIView+Subview.m
//  SGK
//
//  Created by Selim on 21.01.15.
//  Copyright (c) 2015 Selim Bakdemir. All rights reserved.
//

#import "UIView+Subview.h"

@implementation UIView (Subview)


-(UIView *)subviewWithTag:(int)tag
{
    UIView *selectedView = nil;
    for (UIView *view in [self subviews]) {
        
        int viewtag = (int)view.tag;
        if(viewtag == tag)
            selectedView = view;
        
    }
    return selectedView;
}


@end

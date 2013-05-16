//
//  DYNPopoverStyle.h
//  DynUI-Example
//
//  Created by Daniel Pourhadi on 5/16/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "DYNStyle.h"
#import <UIKit/UIPopoverBackgroundView.h>
@class DYNViewStyle;
@interface DYNPopoverStyle : UIPopoverBackgroundView

+ (void)setCurrentStyle:(DYNViewStyle*)style;
+ (DYNViewStyle*)currentStyle;


@end

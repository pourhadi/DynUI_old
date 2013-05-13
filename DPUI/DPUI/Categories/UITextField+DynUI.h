//
//  UITextField+DynUI.h
//  DynUI-Example
//
//  Created by Daniel Pourhadi on 5/13/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (DynUI)

+ (BOOL)textRectForBoundsSwizzled;
+ (void)swizzleTextRectForBounds;

@property (nonatomic) CGFloat textInset;

@end

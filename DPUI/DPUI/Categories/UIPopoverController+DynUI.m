//
//  UIPopoverController+DynUI.m
//  DynUI-Example
//
//  Created by Daniel Pourhadi on 5/16/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "UIPopoverController+DynUI.h"
#import "DynUI.h"
#import "DYNDefines.h"
#import <objc/runtime.h>
#import "JRSwizzle.h"
#import "DYNPopoverStyle.h"
@implementation UIPopoverController (DynUI)

- (void)setDyn_style:(NSString *)viewStyle {
    NSString *currentStyle = objc_getAssociatedObject(self, kDPViewStyleKey);
    if (!currentStyle || ![currentStyle isEqualToString:viewStyle]) {
        if (![[self class] dyn_presentPopoverSwizzled]) {
            [[self class] dyn_swizzlePresentPopover];
        }
        objc_setAssociatedObject(self, (kDPViewStyleKey), viewStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (NSString *)dyn_style {
    return objc_getAssociatedObject(self, (kDPViewStyleKey));
}

+ (BOOL)dyn_presentPopoverSwizzled
{
    NSNumber *num = objc_getAssociatedObject(self, kDYNPresentPopoverSwizzledKey);
    return num.boolValue;
}

+ (void)dyn_swizzlePresentPopover
{
    if (![self dyn_presentPopoverSwizzled]) {
        
        [self jr_swizzleMethod:@selector(presentPopoverFromRect:inView:permittedArrowDirections:animated:) withMethod:@selector(dyn_presentPopoverFromRect:inView:permittedArrowDirections:animated:) error:nil];
        [self jr_swizzleMethod:@selector(presentPopoverFromBarButtonItem:permittedArrowDirections:animated:) withMethod:@selector(dyn_presentPopoverFromBarButtonItem:permittedArrowDirections:animated:) error:nil];
    }
}

- (void)dyn_presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    if (self.dyn_style) {
        DYNViewStyle *style = [[DYNManager sharedInstance] styleForName:self.dyn_style];
        [DYNPopoverStyle setCurrentStyle:style];
        self.popoverBackgroundViewClass = [DYNPopoverStyle class];
    }
    
    [self dyn_presentPopoverFromBarButtonItem:item permittedArrowDirections:arrowDirections animated:animated];
}

- (void)dyn_presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    if (self.dyn_style) {
        DYNViewStyle *style = [[DYNManager sharedInstance] styleForName:self.dyn_style];
        [DYNPopoverStyle setCurrentStyle:style];
        self.popoverBackgroundViewClass = [DYNPopoverStyle class];
    }
    [self dyn_presentPopoverFromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];
}
@end

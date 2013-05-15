//
//  UIScrollView+DynUI.m
//  DynUI-Example
//
//  Created by Daniel Pourhadi on 5/15/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "UIScrollView+DynUI.h"
#import <objc/runtime.h>
#import "DYNDefines.h"
#import "DynUI.h"
@implementation UIScrollView (DynUI)

- (UIView*)dyn_containerView
{
    return objc_getAssociatedObject(self, kDYNContainerViewKey);
}

- (void)setDyn_containerView:(UIView *)dyn_containerView
{
    objc_setAssociatedObject(self, kDYNContainerViewKey, dyn_containerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dyn_embedInContainerViewWithStyle:(NSString *)styleName
{
    if (!self.dyn_containerView) {
        self.dyn_containerView = [[UIView alloc] initWithFrame:self.frame];
        self.dyn_containerView.frame = self.frame;
        [self.superview addSubview:self.dyn_containerView];
        self.frame = self.dyn_containerView.bounds;
        [self.dyn_containerView addSubview:self];
    }
    
    self.dyn_containerView.dyn_style = styleName;
}

@end

//
//  UINavigationBar+DynUI.m
//  Echo POS Mobile
//
//  Created by Daniel Pourhadi on 5/29/13.
//  Copyright (c) 2013 Echo Daily. All rights reserved.
//

#import "UINavigationBar+DynUI.h"
#import "DynUI.h"
#import "DYNDefines.h"
#import <objc/runtime.h>
@implementation UINavigationBar (DynUI)

GET_AND_SET_ASSOCIATED_OBJ(dyn_metaClass, nil);
GET_AND_SET_CLASS_OBJ(dyn_navBarClasses, nil);

- (void)setDyn_metaClass:(Class)class
{
	[self set_dyn_metaClass:class];
}

+ (NSMutableDictionary*)dyn_getNavBarClasses
{
	if (![self dyn_navBarClasses]) {
		[self set_dyn_navBarClasses:[NSDictionary dictionary]];
	}
	
	return [NSMutableDictionary dictionaryWithDictionary:[self dyn_navBarClasses]];
}

- (void)dyn_createMetaClass
{
	NSMutableDictionary *metaClasses = [UINavigationBar dyn_getNavBarClasses];
	if ([metaClasses objectForKey:self.dyn_style]) {
		Class newClass = [metaClasses objectForKey:self.dyn_style];
		[self setDyn_metaClass:newClass];
		object_setClass(self, newClass);
		return;
	}
	
	Class newClass = objc_allocateClassPair([self class], self.dyn_style.UTF8String, 0);
	objc_registerClassPair(newClass);
	
	[self setDyn_metaClass:newClass];
	
	[metaClasses setObject:newClass forKey:self.dyn_style];
	
	[UINavigationBar set_dyn_navBarClasses:metaClasses];
	
	object_setClass(self, newClass);
}

- (void)setEffectBackgroundColor:(UIColor*)color
{
    self.barStyle = UIBarStyleBlack;
    __block UIView *effectBg = nil;
    [self performRecursiveActionForSubviews:^(UIView *subview, BOOL *stop) {
       
        if (subview.hidden || subview.tag == 101) {
            effectBg = subview;
            *stop = YES;
        }
        
    }];
    
    if (effectBg) {
        effectBg.tag = 101;
        
        effectBg.hidden = NO;
        effectBg.layer.backgroundColor = color.CGColor;
    }
}

#define BORDER_VIEW_TAG 909
- (void)setBorderColor:(UIColor*)color
{
    UIView *borderView = [self viewWithTag:BORDER_VIEW_TAG];
    if (!borderView) {
        
        __block UIImageView *viewToHide;
        [self performRecursiveActionForSubviews:^(UIView *subview, BOOL *stop) {
            if (subview.frame.size.height == 0.5) {
                viewToHide = (UIImageView*)subview;
                *stop = YES;
            }
        }];
        
        if (viewToHide) {
            viewToHide.alpha = 0.001;
        
            CGRect f = [viewToHide.superview convertRect:viewToHide.frame toView:self];
            borderView = [[UIView alloc] initWithFrame:f];
            [self addSubview:borderView];
            borderView.tag = BORDER_VIEW_TAG;
            borderView.backgroundColor = color;
            borderView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        }
    } else {
        borderView.backgroundColor = color;
    }
}


@end

//
//  UITextField+DynUI.m
//  DynUI-Example
//
//  Created by Daniel Pourhadi on 5/13/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "UITextField+DynUI.h"
#import <objc/runtime.h>
#import "DYNDefines.h"
#import "JRSwizzle.h"
@implementation UITextField (DynUI)

+ (BOOL)textRectForBoundsSwizzled
{
    return [objc_getAssociatedObject(self, kDYNTextRectSwizzledKey) boolValue];
}

+ (void)swizzleTextRectForBounds
{
    NSError *error;
    [[self class] jr_swizzleMethod:@selector(textRectForBounds:) withMethod:@selector(dyn_textRectForBounds:) error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    [[self class] jr_swizzleMethod:@selector(editingRectForBounds:) withMethod:@selector(dyn_editingRectForBounds:) error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    objc_setAssociatedObject(self, kDYNTextRectSwizzledKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)dyn_textRectForBounds:(CGRect)bounds
{
    CGRect rect = [self dyn_textRectForBounds:bounds];
    
    if (self.textInset > 0) {
        rect = CGRectInset(bounds, self.textInset, self.textInset);
    }
    return rect;
}

- (CGRect)dyn_editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [self dyn_editingRectForBounds:bounds];
    
    if (self.textInset > 0) {
        rect = CGRectInset(bounds, self.textInset, self.textInset);
    }
    return rect;
}

- (CGFloat)textInset
{
    NSNumber *val = objc_getAssociatedObject(self, kDYNTextFieldTextInsetKey);
    return val.floatValue;
}

- (void)setTextInset:(CGFloat)textInset
{
    objc_setAssociatedObject(self, kDYNTextFieldTextInsetKey, @(textInset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsDisplay];
    [self setNeedsLayout];
}
@end
//
//  UIView+DPStyle.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "UIView+DPUI.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>
#import "DPUIDefines.h"
#import "DPUI.h"
@implementation UIView (DPUI)

- (void)setDpui_style:(NSString *)viewStyle {
    NSString *currentStyle = objc_getAssociatedObject(self, kDPViewStyleKey);
    if (!currentStyle || ![currentStyle isEqualToString:viewStyle]) {
        [[DPUIManager sharedInstance] registerView:self];
        if (![[self class] dpui_didMoveToSuperviewSwizzled]) {
            [[self class] dpui_swizzleDidMoveToSuperview];
        }
        objc_setAssociatedObject(self, (kDPViewStyleKey), viewStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.dpui_viewStyleApplied = YES;
        [self dpui_refreshStyle];
    }
}

- (NSString *)dpui_style {
    return objc_getAssociatedObject(self, (kDPViewStyleKey));
}

- (void)dpui_frameChanged
{
    CGSize currentSize = self.frame.size;
    CGSize lastSavedSize = self.dpui_styleSizeApplied;
    if (self.dpui_viewStyleApplied && (!CGSizeEqualToSize(currentSize, lastSavedSize))) {
        [self dpui_refreshStyle];
    }
}

- (void)setDpui_viewStyleApplied:(BOOL)viewStyleApplied {
    if (self.dpui_viewStyleApplied != viewStyleApplied) {
        objc_setAssociatedObject(self, kDPViewStyleAppliedKey, @(viewStyleApplied), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (viewStyleApplied) {            
            if (![[self class] dpui_deallocSwizzled]) {
                [[self class] dpui_swizzleDealloc];
            }
        } else {
            [[DPUIManager sharedInstance] unregisterView:self];
        }
    }
}

- (BOOL)dpui_viewStyleApplied {
    return [objc_getAssociatedObject(self, kDPViewStyleAppliedKey) boolValue];
}

- (CGSize)dpui_styleSizeApplied {
    NSValue *size = objc_getAssociatedObject(self, kDPViewStyleSizeAppliedKey);
    return size.CGSizeValue;
}

- (void)setDpui_styleSizeApplied:(CGSize)styleSizeApplied {
    NSValue *size = [NSValue valueWithCGSize:styleSizeApplied];
    objc_setAssociatedObject(self, kDPViewStyleSizeAppliedKey, size, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dpui_refreshStyle
{
    if (self.dpui_style) {
        self.dpui_styleSizeApplied = self.frame.size;
        [DPUIRenderer renderView:self withStyleNamed:self.dpui_style];
    }
}

+ (BOOL)dpui_deallocSwizzled {
    return [objc_getAssociatedObject([self class], kDPUIDeallocSwizzled) boolValue];
}

+ (void)dpui_swizzleDealloc {
    [[self class] jr_swizzleMethod:sel_registerName("dealloc") withMethod:@selector(dpui_dealloc) error:nil];
    objc_setAssociatedObject([self class], kDPUIDeallocSwizzled, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dpui_dealloc {
    [[DPUIManager sharedInstance] unregisterView:self];
    
    [self dpui_dealloc];
}

+ (BOOL)dpui_didMoveToSuperviewSwizzled
{
    return [(NSNumber*)objc_getAssociatedObject(self, kDPUIDidMoveToSuperviewSwizzled) boolValue];
}

+ (void)dpui_swizzleDidMoveToSuperview {
    [self jr_swizzleMethod:@selector(didMoveToSuperview) withMethod:@selector(dpui_didMoveToSuperview) error:nil];
    objc_setAssociatedObject(self, kDPUISetFrameSwizzled, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dpui_didMoveToSuperview
{
    [self dpui_didMoveToSuperview];
    CGSize currentSize = self.frame.size;
    CGSize lastSavedSize = self.dpui_styleSizeApplied;
    
    if (self.dpui_viewStyleApplied && (!CGSizeEqualToSize(currentSize, lastSavedSize))) {
        [self dpui_refreshStyle];
    }
}

#pragma mark - Parameters

- (void)setStyleParameters:(DPUIStyleParameters *)styleParameters
{
    objc_setAssociatedObject(self, kDPUIStyleParameterKey, styleParameters, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DPUIStyleParameters*)styleParameters
{
    DPUIStyleParameters *parameters = objc_getAssociatedObject(self, kDPUIStyleParameterKey);
    if (!parameters) {
        parameters = [[DPUIStyleParameters alloc] init];
        self.styleParameters = parameters;
    }
    return parameters;
}


- (void)setValue:(id)value forStyleParameter:(NSString*)parameterName
{
    [self.styleParameters setValue:value forStyleParameter:parameterName];
}
@end

//
//  UIView+DPStyle.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "UIView+DynUI.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>
#import "DYNDefines.h"
#import "DynUI.h"
#import "DYNPassThroughView.h"
@implementation UIView (DynUI)

- (void)setDyn_style:(NSString *)viewStyle {
    NSString *currentStyle = objc_getAssociatedObject(self, kDPViewStyleKey);
    if (!currentStyle || ![currentStyle isEqualToString:viewStyle]) {
        [[DYNManager sharedInstance] registerView:self];
        if (![[self class] dyn_didMoveToSuperviewSwizzled]) {
            [[self class] dyn_swizzleDidMoveToSuperview];
        }
        
        objc_setAssociatedObject(self, (kDPViewStyleKey), viewStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.dyn_viewStyleApplied = YES;
        [self dyn_refreshStyle];
    }
}

- (NSString *)dyn_style {
    return objc_getAssociatedObject(self, (kDPViewStyleKey));
}

- (void)dyn_frameChanged {
    CGSize currentSize = self.frame.size;
    CGSize lastSavedSize = self.dyn_styleSizeApplied;
    if (self.dyn_viewStyleApplied && (!CGSizeEqualToSize(currentSize, lastSavedSize))) {
        [self dyn_refreshStyle];
    }
}

- (void)setDyn_viewStyleApplied:(BOOL)viewStyleApplied {
    if (self.dyn_viewStyleApplied != viewStyleApplied) {
        objc_setAssociatedObject(self, kDPViewStyleAppliedKey, @(viewStyleApplied), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (!viewStyleApplied) {
            [[DYNManager sharedInstance] unregisterView:self];
        }
    }
}

- (BOOL)dyn_viewStyleApplied {
    return [objc_getAssociatedObject(self, kDPViewStyleAppliedKey) boolValue];
}

- (CGSize)dyn_styleSizeApplied {
    NSValue *size = objc_getAssociatedObject(self, kDPViewStyleSizeAppliedKey);
	if (!size) {
		size = [NSValue valueWithCGSize:CGSizeZero];
	}
    return size.CGSizeValue;
}

- (void)setDyn_styleSizeApplied:(CGSize)styleSizeApplied {
    NSValue *size = [NSValue valueWithCGSize:styleSizeApplied];
    objc_setAssociatedObject(self, kDPViewStyleSizeAppliedKey, size, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dyn_refreshStyle {
    if (self.dyn_style) {
        self.dyn_styleSizeApplied = self.frame.size;
        [DYNRenderer renderView:self withStyleNamed:self.dyn_style];
    }
}

+ (BOOL)dyn_didMoveToSuperviewSwizzled {
    return [(NSNumber *)objc_getAssociatedObject(self, kDYNDidMoveToSuperviewSwizzled) boolValue];
}

+ (void)dyn_swizzleDidMoveToSuperview {
    [self jr_swizzleMethod:@selector(didMoveToSuperview) withMethod:@selector(dyn_didMoveToSuperview) error:nil];
    objc_setAssociatedObject(self, kDYNDidMoveToSuperviewSwizzled, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dyn_didMoveToSuperview {
    [self dyn_didMoveToSuperview];
    CGSize currentSize = self.frame.size;
    CGSize lastSavedSize = self.dyn_styleSizeApplied;
    
    if (self.dyn_viewStyleApplied && (!CGSizeEqualToSize(currentSize, lastSavedSize))) {
        [self dyn_refreshStyle];
    }
}

+ (void)swizzleDidAddSubview
{
    [self jr_swizzleMethod:@selector(didAddSubview:) withMethod:@selector(dyn_didAddSubview:) error:nil];
    NSNumber *swizzled = [self swizzledDidAddSubview];
    BOOL new = !swizzled.boolValue;
    [self set_swizzledDidAddSubview:@(new)];
}

- (void)dyn_didAddSubview:(UIView*)subview
{
    [self dyn_didAddSubview:subview];
    
    if (self.dyn_viewStyleApplied && self.dyn_overlayView && [self.dyn_overlayView isDescendantOfView:self]) {
        [self bringSubviewToFront:self.dyn_overlayView];
    }
}

GET_AND_SET_CLASS_OBJ(swizzledDidAddSubview, @(NO));

- (void)setDyn_backgroundView:(UIView *)dyn_backgroundView
{
    [self set_dyn_backgroundView:dyn_backgroundView];
}

- (void)setDyn_overlayView:(DYNPassThroughView *)dyn_overlayView
{
    [self addSubview:dyn_overlayView];
    
    if (self.constraints) {
        NSDictionary *vars = NSDictionaryOfVariableBindings(dyn_overlayView);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[dyn_overlayView]-0-|" options:0 metrics:nil views:vars];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[dyn_overlayView]-0-|" options:0 metrics:nil views:vars]];
        [self addConstraints:constraints];
    } else {
        dyn_overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    if (dyn_overlayView) {
        if (![[self class] swizzledDidAddSubview]) {
            [[self class] swizzleDidAddSubview];
        }
    }
    [self set_dyn_overlayView:dyn_overlayView];
}

GET_AND_SET_ASSOCIATED_OBJ(dyn_backgroundView, nil);
GET_AND_SET_ASSOCIATED_OBJ(dyn_overlayView, nil);

#pragma mark - Parameters

- (void)setStyleParameters:(DYNStyleParameters *)styleParameters {
    objc_setAssociatedObject(self, kDYNStyleParameterKey, styleParameters, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DYNStyleParameters *)styleParameters {
    DYNStyleParameters *parameters = objc_getAssociatedObject(self, kDYNStyleParameterKey);
    if (!parameters) {
        parameters = [[DYNStyleParameters alloc] init];
        self.styleParameters = parameters;
    }
    return parameters;
}

- (void)setValuesForStyleParameters:(NSDictionary*)valuesForParams
{
	[valuesForParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		
		[self.styleParameters setValue:obj forStyleParameter:key];
		
	}];
	
	[self dyn_refreshStyle];
}

- (void)setValue:(id)value forStyleParameter:(NSString *)parameterName {
    [self.styleParameters setValue:value forStyleParameter:parameterName];
	[self dyn_refreshStyle];
}

@end

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
        if (viewStyleApplied) {
            if (![[self class] dyn_deallocSwizzled]) {
                [[self class] dyn_swizzleDealloc];
            }
        } else {
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

+ (BOOL)dyn_deallocSwizzled {
    return [objc_getAssociatedObject([self class], kDYNDeallocSwizzled) boolValue];
}

+ (void)dyn_swizzleDealloc {
    [[self class] jr_swizzleMethod:sel_registerName("dealloc") withMethod:@selector(dyn_dealloc) error:nil];
    objc_setAssociatedObject([self class], kDYNDeallocSwizzled, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dyn_dealloc {
    [[DYNManager sharedInstance] unregisterView:self];
    
    [self dyn_dealloc];
}

+ (BOOL)dyn_didMoveToSuperviewSwizzled {
    return [(NSNumber *)objc_getAssociatedObject(self, kDYNDidMoveToSuperviewSwizzled) boolValue];
}

+ (void)dyn_swizzleDidMoveToSuperview {
    [self jr_swizzleMethod:@selector(didMoveToSuperview) withMethod:@selector(dyn_didMoveToSuperview) error:nil];
    objc_setAssociatedObject(self, kDYNSetFrameSwizzled, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dyn_didMoveToSuperview {
    [self dyn_didMoveToSuperview];
    CGSize currentSize = self.frame.size;
    CGSize lastSavedSize = self.dyn_styleSizeApplied;
    
    if (self.dyn_viewStyleApplied && (!CGSizeEqualToSize(currentSize, lastSavedSize))) {
        [self dyn_refreshStyle];
    }
}

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

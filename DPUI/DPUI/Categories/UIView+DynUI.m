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
			//	[[self class] dyn_swizzleDidMoveToSuperview];
        }
        
		if (![[UIView dyn_deallocSwizzled] boolValue]) {
			[UIView dyn_swizzleDealloc];
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
	
	if (self.layer.mask) {
		if (self.dyn_fadedEdgeInsets) {
			self.dyn_fadedEdgeInsets = self.dyn_fadedEdgeInsets;
		}
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

+ (void)dyn_swizzleDidMoveToSuperview {
	NSLog(@"swizzle did move to superview");
    [self jr_swizzleMethod:@selector(didMoveToSuperview) withMethod:@selector(dyn_didMoveToSuperview) error:nil];
	[self set_dyn_didMoveToSuperviewSwizzled:@(YES)];
}

- (void)dyn_didMoveToSuperview {
	NSLog(@"did move to superview");
    [self dyn_didMoveToSuperview];
    CGSize currentSize = self.frame.size;
    CGSize lastSavedSize = self.dyn_styleSizeApplied;
    
    if (self.dyn_viewStyleApplied && (!CGSizeEqualToSize(currentSize, lastSavedSize))) {
        [self dyn_refreshStyle];
    }
}

+ (void)swizzleDidAddSubview {
	NSLog(@"swizzle did add subview");
    [self jr_swizzleMethod:@selector(didAddSubview:) withMethod:@selector(dyn_didAddSubview:) error:nil];
    NSNumber *swizzled = [self swizzledDidAddSubview];
    BOOL new = !swizzled.boolValue;
    [self set_swizzledDidAddSubview:@(new)];
}

- (void)dyn_didAddSubview:(UIView *)subview {
	[self dyn_didAddSubview:subview];
    
    if (self.dyn_viewStyleApplied && self.dyn_overlayView && [self.dyn_overlayView isDescendantOfView:self]) {
        [self bringSubviewToFront:self.dyn_overlayView];
    }
}

GET_AND_SET_CLASS_OBJ(swizzledDidAddSubview, @(NO));

+ (void)dyn_swizzleDealloc
{
	[UIView jr_swizzleMethod:NSSelectorFromString(@"dealloc") withMethod:@selector(dyn_dealloc) error:nil];
    NSNumber *swizzled = [UIView dyn_deallocSwizzled];
    BOOL new = !swizzled.boolValue;
    [UIView set_dyn_deallocSwizzled:@(new)];
}

- (void)dyn_dealloc
{
	if ([self dyn_overlayView]) {
		[[self dyn_overlayView] removeFromSuperview];
		[self set_dyn_overlayView:nil];
	}
	
	if ([self dyn_backgroundView]) {
		[[self dyn_backgroundView] removeFromSuperview];
		[self set_dyn_backgroundView:nil];
	}
	[[DYNManager sharedInstance] unregisterView:self];
	
	[self dyn_dealloc];
}

- (void)setDyn_backgroundView:(UIView *)dyn_backgroundView {
    [self set_dyn_backgroundView:dyn_backgroundView];
}

- (void)setDyn_overlayView:(DYNPassThroughView *)dyn_overlayView {
	[self set_dyn_overlayView:dyn_overlayView];
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
        if (![UIView swizzledDidAddSubview]) {
            [UIView swizzleDidAddSubview];
        }
    }
}

- (void)setDyn_fadedEdgeInsets:(NSValue*)dyn_fadedEdgeInsets
{
	[self set_dyn_fadedEdgeInsets:dyn_fadedEdgeInsets];
	
	
	id clear = (id)[UIColor clearColor].CGColor;
	id black = (id)[UIColor blackColor].CGColor;
	
	UIEdgeInsets insets = dyn_fadedEdgeInsets.UIEdgeInsetsValue;
	
	CGFloat topStart = 0;
	CGFloat topEnd = insets.top / self.layer.bounds.size.height;
	CGFloat bottomStart = (self.layer.bounds.size.height - insets.bottom) / self.layer.bounds.size.height;
	CGFloat bottomEnd = 1;
	
	CAGradientLayer *topBottomInsets = [CAGradientLayer layer];
	NSArray *locations = @[@(topStart),
						@(topEnd),
						@(bottomStart),
						@(bottomEnd)];
	topBottomInsets.frame = self.bounds;
	topBottomInsets.locations = locations;
	topBottomInsets.colors = @[(topEnd > 0 ? clear : black),
							black,
							black,
							(bottomStart > 0 ? clear : black)];
	
	CGFloat leftStart = 0;
	CGFloat leftEnd = insets.left / self.layer.bounds.size.width;
	CGFloat rightStart = (self.layer.bounds.size.width - insets.right) / self.layer.bounds.size.width;
	CGFloat rightEnd = 1;
	
	CAGradientLayer *leftRightInsets = [CAGradientLayer layer];
	locations = @[@(leftStart),
			   @(leftEnd),
			   @(rightStart),
			   @(rightEnd)];
	leftRightInsets.frame = self.bounds;
	leftRightInsets.startPoint = CGPointMake(0, 0.5);
	leftRightInsets.endPoint = CGPointMake(1, 0.5);
	leftRightInsets.locations = locations;
	leftRightInsets.colors = @[(leftEnd > 0 ? clear : black),
							black,
							black,
							(rightStart > 0 ? clear : black)];
	
	CGRect topBottomFrame;
	topBottomFrame.origin.x = insets.left;
	topBottomFrame.origin.y = 0;
	topBottomFrame.size.width = self.bounds.size.width - (insets.left + insets.right);
	topBottomFrame.size.height = self.bounds.size.height;
	topBottomInsets.frame = topBottomFrame;
	
	CGRect leftRightFrame;
	leftRightFrame.origin.x = 0;
	leftRightFrame.origin.y = insets.top;
	leftRightFrame.size.width = self.bounds.size.width;
	leftRightFrame.size.height = self.bounds.size.height - (insets.top + insets.bottom);
	leftRightInsets.frame = leftRightFrame;
	
	UIImage *topBottomImage = [UIImage imageWithSize:topBottomFrame.size drawnWithBlock:^(CGContextRef context, CGRect rect) {
		
			[topBottomInsets renderInContext:context];
		
	}];
	
	UIImage *leftRightImage = [UIImage imageWithSize:leftRightFrame.size drawnWithBlock:^(CGContextRef context, CGRect rect) {
		
			[leftRightInsets renderInContext:context];
		
	}];
	
	
	UIImage *maskImage = [UIImage imageWithSize:self.bounds.size drawnWithBlock:^(CGContextRef context, CGRect rect) {

		CGSize size = rect.size;
		
		if (insets.top > 0 || insets.bottom > 0)
			[topBottomImage drawInRect:CGRectMake((size.width-topBottomFrame.size.width)/2, (size.height-topBottomFrame.size.height)/2, topBottomFrame.size.width, topBottomFrame.size.height)];
		
		if (insets.left > 0 || insets.right > 0)
			[leftRightImage drawInRect:CGRectMake((size.width-leftRightFrame.size.width)/2, (size.height-leftRightFrame.size.height)/2, leftRightFrame.size.width, leftRightFrame.size.height)];
		
	}];
	
	CALayer *mask = [CALayer layer];
	mask.frame = self.bounds;
	mask.contents = (id)maskImage.CGImage;
	
	self.layer.mask = mask;
}

GET_AND_SET_ASSOCIATED_OBJ(dyn_fadedEdgeInsets, nil);
GET_AND_SET_ASSOCIATED_OBJ(dyn_backgroundView, nil);
GET_AND_SET_ASSOCIATED_OBJ(dyn_overlayView, nil);
GET_AND_SET_CLASS_OBJ(dyn_deallocSwizzled, @(NO));
GET_AND_SET_CLASS_OBJ(dyn_didMoveToSuperviewSwizzled, @(NO));
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

- (void)setValuesForStyleParameters:(NSDictionary *)valuesForParams {
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

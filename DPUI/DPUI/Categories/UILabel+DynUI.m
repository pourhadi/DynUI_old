//
//  UILabel+DYN.m
//  TheQ
//
//  Created by Dan Pourhadi on 5/5/13.
//
//

#import "UILabel+DynUI.h"
#import <objc/runtime.h>
#import "DYNDefines.h"
#import "DynUI.h"
#import "JRSwizzle.h"

static const void *const kSCROLL_DURATION_KEY = "scrollDuration";
static const void *const kSCROLL_PAUSE_DURATION_KEY = "scrollPauseDuration";
static const void *const kSCROLL_TEXT_SEPARATOR_WIDTH_KEY = "scrollTextSeparatorWidth";
static const void *const kDYNLabelAutoScrollKey = "_DYNLabelAutoScrollKey";
static const void *const kDYNDrawTextInRectSwizzledKey = "_DYNDrawTextInRectKey";
static const void *const kDYNSetTextSwizzledKey = "_DYNSetTextSwizzledKey";

@implementation UILabel (DynUI)

- (void)applyLabelAttributesToLabel:(UILabel *)label {
    label.backgroundColor = self.backgroundColor;
    label.text = self.text;
    label.font = self.font;
    label.textColor = self.textColor;
    label.shadowColor = self.shadowColor;
    label.shadowOffset = self.shadowOffset;
    label.textAlignment = self.textAlignment;
    label.opaque = self.opaque;
}

- (void)setDyn_textStyle:(NSString *)style {
    DYNTextStyle *textStyle = [[DYNManager sharedInstance] textStyleForName:style];
    [textStyle applyToLabel:self];
    
    [[DYNManager sharedInstance] registerView:self];
	
	if (self.dyn_autoScroll) {
		[textStyle applyToLabel:[self firstLabel]];
		[textStyle applyToLabel:[self secondLabel]];
	}
}

- (NSString *)dyn_textStyle {
    return objc_getAssociatedObject(self, kDPTextStyleKey);
}

- (void)dyn_refreshStyle {
    if (self.dyn_textStyle) {
        [self setDyn_textStyle:self.dyn_textStyle];
    }
    
    if (self.dyn_style) {
        self.dyn_styleSizeApplied = self.frame.size;
        [DYNRenderer renderView:self withStyleNamed:self.dyn_style];
		
    }
}

- (void)setDyn_autoScroll:(BOOL)dyn_autoScroll {
    objc_setAssociatedObject(self, kDYNLabelAutoScrollKey, @(dyn_autoScroll), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (dyn_autoScroll) {
        if (![[[self class] swizzledDrawTextInRect] boolValue]) {
            [[self class] dyn_swizzleDrawTextInRect];
        }
        if (![[self class] dyn_swizzledSetText]) {
            [[self class] dyn_swizzleSetText];
        }

        self.adjustsFontSizeToFitWidth = NO;
        self.adjustsLetterSpacingToFitWidth = NO;
        
        if (![self scrollerView]) {
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
            scrollView.backgroundColor = [UIColor clearColor];
            [self addSubview:scrollView];
            [self set_scrollerView:scrollView];
        }
        
        if (![self firstLabel]) {
            UILabel *firstLabel = [[UILabel alloc] initWithFrame:self.bounds];
            [self applyLabelAttributesToLabel:firstLabel];
            [[self scrollerView] addSubview:firstLabel];
            [self set_firstLabel:firstLabel];
        }
        
        if (![self secondLabel]) {
            UILabel *secondLabel = [[UILabel alloc] initWithFrame:self.bounds];
            [self applyLabelAttributesToLabel:secondLabel];
            [self set_secondLabel:secondLabel];
        }
        [self checkTextSize];
    } else {
        if ([[self class] swizzledDrawTextInRect]) {
            [[self class] dyn_swizzleDrawTextInRect];
        }
        if ([[self class] dyn_swizzledSetText]) {
            [[self class] dyn_swizzleSetText];
        }
    }
}

- (BOOL)dyn_autoScroll {
    return [objc_getAssociatedObject(self, kDYNLabelAutoScrollKey) boolValue];
}

#pragma mark - swizzling

+ (BOOL)dyn_swizzledSetText {
    return [objc_getAssociatedObject(self, kDYNSetTextSwizzledKey) boolValue];
}

+ (void)dyn_swizzleSetText {
    [[self class] jr_swizzleMethod:@selector(setText:) withMethod:@selector(dyn_setText:) error:nil];
    objc_setAssociatedObject(self, kDYNSetTextSwizzledKey, @(![self dyn_swizzledSetText]), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)dyn_swizzleDrawTextInRect {
    [self jr_swizzleMethod:@selector(drawTextInRect:) withMethod:@selector(dyn_drawTextInRect:) error:nil];
    [self set_swizzledDrawTextInRect:@(![[self swizzledDrawTextInRect] boolValue])];
}

+ (NSNumber *)swizzledDrawTextInRect {
    return objc_getAssociatedObject(self, "swizzledDrawTextInRect");
}

+ (void)set_swizzledDrawTextInRect:(NSNumber *)swizzled {
    objc_setAssociatedObject(self, "swizzledDrawTextInRect", swizzled, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dyn_drawTextInRect:(CGRect)rect {
    if (self.dyn_autoScroll) { // && [[self isScrolling] boolValue] && ![[self isPaused] boolValue]) {
    } else {
        [self dyn_drawTextInRect:rect];
    }
}

- (void)dyn_setText:(NSString *)text {
    if (self.dyn_autoScroll && ![text isEqualToString:self.text]) {
        [self dyn_setText:text];
        [self resetScrolling];
        [self checkTextSize];
    } else if (!self.dyn_autoScroll) {
		[self dyn_setText:text];
	}
}

#pragma mark - scrolling

- (void)resetScrolling {
    [self set_isScrolling:@(NO)];
    [[[self scrollerView] layer] removeAllAnimations];
    [self set_scrollAnimation:nil];
    
    UILabel *firstLabel = [self firstLabel];
    UILabel *secondLabel = [self secondLabel];
    [self applyLabelAttributesToLabel:firstLabel];
    [self applyLabelAttributesToLabel:secondLabel];
    
    [[self scrollerView] setContentOffset:CGPointZero];
}

- (void)checkTextSize {
    CGSize size = [self.text sizeWithFont:self.font];
    [self set_totalTextLength:@(size.width)];
    if (size.width >= self.frame.size.width) {
        CGFloat totalDistance = size.width;
        
        UIScrollView *scrollView = [self scrollerView];
        if (!scrollView.window) {
            scrollView.frame = self.bounds;
            [self addSubview:scrollView];
        }
        scrollView.contentSize = CGSizeMake((totalDistance * 2) + [[self scrollTextSeparatorWidth] floatValue], self.frame.size.height);
        
        UILabel *firstLabel = [self firstLabel];
        UILabel *secondLabel = [self secondLabel];
        [self applyLabelAttributesToLabel:firstLabel];
        [self applyLabelAttributesToLabel:secondLabel];
        
        CGRect frame = self.bounds;
        frame.size.width = totalDistance;
        firstLabel.frame = frame;
        
        if (!firstLabel.window) {
            [scrollView addSubview:firstLabel];
        }
        
        frame = self.bounds;
        frame.origin.x = totalDistance + [[self scrollTextSeparatorWidth] floatValue];
        frame.size.width = totalDistance;
        secondLabel.frame = frame;
        
        if (!secondLabel.window) {
            [scrollView addSubview:secondLabel];
        }
        
        [scrollView setContentOffset:CGPointZero];
        
        [self startScrolling];
    } else {
        [self set_isScrolling:@(NO)];
        
        if ([[self scrollerView] window]) {
            [[self scrollerView] removeFromSuperview];
        }
        [self setNeedsDisplay];
    }
}

- (void)startScrolling {
    if (![self scrollAnimation]) {
        [self set_isScrolling:@(YES)];
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"bounds.origin.x"];
        anim.fromValue = @(0);
        UILabel *secondLabel = [self secondLabel];
        anim.toValue = @(secondLabel.frame.origin.x);
        anim.delegate = self;
        anim.duration = [[self scrollDuration] doubleValue];
        [[[self scrollerView] layer] addAnimation:anim forKey:@"animation"];
        [self set_scrollAnimation:anim];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self startPause];
}

- (void)startPause {
    [self resetScrolling];
    
    [NSTimer scheduledTimerWithTimeInterval:[[self scrollPauseDuration] floatValue] target:self selector:@selector(pauseEnd) userInfo:nil repeats:NO];
}

- (void)pauseEnd {
    [self startScrolling];
}

- (void)setDyn_scrollDuration:(NSTimeInterval)dyn_scrollDuration {
    [self set_scrollDuration:@(dyn_scrollDuration)];
}

- (NSTimeInterval)dyn_scrollDuration {
    return [[self scrollDuration] doubleValue];
}

- (void)setDyn_scrollPauseDuration:(NSTimeInterval)dyn_scrollPauseDuration {
    [self set_scrollPauseDuration:@(dyn_scrollPauseDuration)];
}

- (NSTimeInterval)dyn_scrollPauseDuration {
    return [[self scrollPauseDuration] doubleValue];
}

- (void)setDyn_scrollTextSeparatorWidth:(CGFloat)dyn_scrollTextSeparatorWidth {
    [self set_scrollTextSeparatorWidth:@(dyn_scrollTextSeparatorWidth)];
}

- (CGFloat)dyn_scrollTextSeparatorWidth {
    return [[self scrollTextSeparatorWidth] floatValue];
}

GET_AND_SET_ASSOCIATED_OBJ(scrollAnimation, nil);
GET_AND_SET_ASSOCIATED_OBJ(scrollerView, nil);
GET_AND_SET_ASSOCIATED_OBJ(startTime, @(0));
GET_AND_SET_ASSOCIATED_OBJ(firstLabel, nil);
GET_AND_SET_ASSOCIATED_OBJ(secondLabel, nil);
#pragma mark - Rect management

GET_AND_SET_ASSOCIATED_OBJ(secondRect, [NSValue valueWithCGRect:CGRectZero])
GET_AND_SET_ASSOCIATED_OBJ(totalTextLength, @(0));
GET_AND_SET_ASSOCIATED_OBJ(animationStep, @(1.0));
GET_AND_SET_ASSOCIATED_OBJ(scrollTimer, nil)
GET_AND_SET_ASSOCIATED_OBJ(currentBounds, [NSValue valueWithCGRect:CGRectZero])

#pragma mark - scroll settings
GET_AND_SET_ASSOCIATED_OBJ(isPaused, @(NO));
GET_AND_SET_ASSOCIATED_OBJ(isScrolling, @(NO))
GET_AND_SET_ASSOCIATED_OBJ(scrollDuration, @(5))
GET_AND_SET_ASSOCIATED_OBJ(scrollPauseDuration, @(5))
GET_AND_SET_ASSOCIATED_OBJ(scrollTextSeparatorWidth, @(30))

@end

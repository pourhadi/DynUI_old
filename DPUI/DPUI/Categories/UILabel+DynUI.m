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

GET_AND_SET_ASSOCIATED_OBJ(textColorVariableName_val, nil);
- (void)setDyn_textColorVariableName:(NSString *)dyn_textColorVariableName
{
    [self set_textColorVariableName_val:dyn_textColorVariableName];
    if (dyn_textColorVariableName && dyn_textColorVariableName.length > 0) {
        self.textColor = [UIColor colorForVariable:dyn_textColorVariableName];
        [self dyn_setAutoUpdateBlock:^(UILabel* weakObj) {
            weakObj.textColor = [UIColor colorForVariable:weakObj.dyn_textColorVariableName];
        }];
    } else {
        [self dyn_removeAutoUpdateBlock];
    }
}

- (NSString*)dyn_textColorVariableName
{
    return [self textColorVariableName_val];
}

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

GET_AND_SET_ASSOCIATED_OBJ(dynScrollLabel, nil);
GET_AND_SET_ASSOCIATED_OBJ(scrollAnimator, nil);
GET_AND_SET_ASSOCIATED_OBJ(scrollAttachment, nil);
GET_AND_SET_BOOL(dynAutoScrollEnabled);
GET_AND_SET_ASSOCIATED_OBJ(labelButton, Nil);
GET_AND_SET_ASSOCIATED_OBJ(actualLabelButton, nil);
GET_AND_SET_BOOL(dyn_interactiveScrollingDisabled_val);

GET_AND_SET_CLASS_BOOL(labelDeallocSwizzled);

+ (void)swizzleLabelDealloc
{
    [self jr_swizzleMethod:NSSelectorFromString(@"dealloc") withMethod:@selector(dyn_label_dealloc) error:nil];
    [self set_labelDeallocSwizzled:![self labelDeallocSwizzled]];
}

- (void)dyn_label_dealloc
{
    if ([self dyn_autoScroll]) {
        if ([self scrollAnimator]) {
            [[self scrollAnimator] removeAllBehaviors];
            [self set_scrollAnimator:nil];
        }
        
        if ([self dynScrollLabel]) {
            [[self dynScrollLabel] removeFromSuperview];
            [self set_dynScrollLabel:nil];
        }
        
        if ([self labelButton]) {
            // [[self labelButton] removeFromSuperview];
            [self removeGestureRecognizer:[self labelButton]];
            [self set_labelButton:nil];
            self.userInteractionEnabled = NO;
            [self removeAllKVO];
        }
        
        if ([self actualLabelButton]) {
            [[self actualLabelButton] removeFromSuperview];
            [self set_actualLabelButton:nil];
        }
        [self dyn_removeAutoUpdateBlock];
        
        
    }
    
    [self dyn_label_dealloc];
}

- (void)setDyn_interactiveScrollingDisabled:(BOOL)dyn_interactiveScrollingDisabled
{
    [self set_dyn_interactiveScrollingDisabled_val:dyn_interactiveScrollingDisabled];
    DYNLabelAnimation *animator = [self scrollAnimator];
    animator.dyn_interactiveScrollingDisabled = dyn_interactiveScrollingDisabled;
    
    self.userInteractionEnabled = !dyn_interactiveScrollingDisabled;
}

- (BOOL)dyn_interactiveScrollingDisabled
{
    return [self dyn_interactiveScrollingDisabled_val];
}

- (void)setDyn_autoScroll:(BOOL)dyn_autoScroll
{
    if ([self dynAutoScrollEnabled] != dyn_autoScroll) {
        if (dyn_autoScroll) {
            if (![[[self class] swizzledDrawTextInRect] boolValue]) {
                [[self class] dyn_swizzleDrawTextInRect];
            }
            if (![[self class] dyn_swizzledSetText]) {
                [[self class] dyn_swizzleSetText];
            }
            
            if (![[self class] dyn_swizzledSetAttributedText]) {
                [[self class] dyn_swizzleSetAttributedText];
            }
            
            if (![[self class] labelDeallocSwizzled]) {
                [[self class] swizzleLabelDealloc];
            }
            
            UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
            __weak __typeof(&*self) weakSelf = self;
                [weakSelf applyLabelAttributesToLabel:label];
            label.textAlignment = self.textAlignment;
            
            [self addSubview:label];
            
            
            label.lineBreakMode = NSLineBreakByClipping;
            
            [self set_dynScrollLabel:label];
            
            DYNLabelAnimation *animator = [[DYNLabelAnimation alloc] initWithLabel:label];
            [self set_scrollAnimator:animator];
            
            if (self.attributedText) {
                label.text = nil;
                label.attributedText = self.attributedText;
            } else {
                label.attributedText = nil;
            label.text = self.text;
            }
            [self readjustScrolling];
            
            self.userInteractionEnabled = ![self dyn_interactiveScrollingDisabled];
            if (self.userInteractionEnabled) {

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = self.bounds;
                button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [button addTarget:[self scrollAnimator] action:@selector(scroll) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [self set_actualLabelButton:button];
            
                /*
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fingerPanned:)];
            [self addGestureRecognizer:pan];
            [self set_labelButton:pan];
                [self observeKeypath:@"state" ofObject:pan];
*/
            }
            
            [self observeKeypath:@"textColor" ofObject:self];
            [self observeKeypath:@"frame" ofObject:self];
            
            self.layer.drawsAsynchronously = YES;
            label.layer.drawsAsynchronously = YES;
            
            [self dyn_setText:@""];
            

//            [self dyn_setAutoUpdateBlock:^(UILabel* weakObj) {
//               
//                [weakObj dispatchAfter:0.2 onQueue:dispatch_get_main_queue() executionBlock:^{
//                   
//                    [(UILabel*)weakObj applyLabelAttributesToLabel:[weakObj dynScrollLabel]];
//                    
//                }];
//                
//            }];
        }else {
            if ([self dynScrollLabel]) {
                [[self dynScrollLabel] removeFromSuperview];
                [self set_dynScrollLabel:nil];
            }
            
            if ([self scrollAnimator]) {

                [[self scrollAnimator] kill];
                [self set_scrollAnimator:nil];
            }
            
            if ([self labelButton]) {
                [self removeGestureRecognizer:[self labelButton]];
                [self set_labelButton:nil];
                self.userInteractionEnabled = NO;
                [self removeAllKVO];
            }
            
            if ([self actualLabelButton]) {
                [[self actualLabelButton] removeFromSuperview];
                [self set_actualLabelButton:nil];
            }
            [self dyn_removeAutoUpdateBlock];
        }
    }
    
    [self set_dynAutoScrollEnabled:dyn_autoScroll];
}

- (void)setDyn_numberOfAutoScrolls:(NSInteger)dyn_numberOfAutoScrolls
{
    if ([self scrollAnimator]) {
        DYNLabelAnimation *animator = [self scrollAnimator];
        animator.dyn_numberOfAutoScrolls = dyn_numberOfAutoScrolls;
    }
}

- (NSInteger)dyn_numberOfAutoScrolls
{
     DYNLabelAnimation *animator = [self scrollAnimator];
    return animator.dyn_numberOfAutoScrolls;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"]) {
        UIPanGestureRecognizer *pan = [self labelButton];
        DYNLabelAnimation *anim = [self scrollAnimator];

        if ((pan.state == UIGestureRecognizerStatePossible)  || (pan.state == UIGestureRecognizerStateEnded) || (pan.state == UIGestureRecognizerStateCancelled) || (pan.state == UIGestureRecognizerStateFailed)) {
            if (anim.manualOverride) {
                anim.manualOverride = NO;
                [anim scroll];
            }
        } else if ((pan.state == UIGestureRecognizerStateChanged) || (pan.state == UIGestureRecognizerStateBegan)) {
            anim.manualOverride = YES;
        }
    } else if ([keyPath isEqualToString:@"textColor"]) {
        [self applyLabelAttributesToLabel:[self dynScrollLabel]];
    } else if ([keyPath isEqualToString:@"frame"]) {
        if ([self dynScrollLabel]) {
            [[self dynScrollLabel] setFrame:self.bounds];
        }
        
        [self readjustScrolling];
    }
}

- (void)fingerPanned:(UIPanGestureRecognizer*)pan
{
    DYNLabelAnimation *anim = [self scrollAnimator];

    [anim offsetByX:[pan translationInView:self].x];
}

- (void)readjustScrolling
{
    DYNLabelAnimation *a = [self scrollAnimator];
    [a textChanged];
}


/*

- (void)setDyn_autoScroll:(BOOL)dyn_autoScroll {
    @autoreleasepool {
        

    objc_setAssociatedObject(self, kDYNLabelAutoScrollKey, @(dyn_autoScroll), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (dyn_autoScroll) {
        if (![[[self class] swizzledDrawTextInRect] boolValue]) {
            [[self class] dyn_swizzleDrawTextInRect];
        }
        if (![[self class] dyn_swizzledSetText]) {
            [[self class] dyn_swizzleSetText];
        }

        self.adjustsFontSizeToFitWidth = NO;
      //  self.adjustsLetterSpacingToFitWidth = NO;
        
        if (![self scrollerView]) {
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
            // [scrollView setAutoresizingToFlexibleWidthAndHeight];
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
        
        if ([self scrollerView]) {
            [[self scrollerView] removeFromSuperview];
        }
    }
    }
}
*/
- (BOOL)dyn_autoScroll {
    return [objc_getAssociatedObject(self, kDYNLabelAutoScrollKey) boolValue];
}

#pragma mark - swizzling

GET_AND_SET_CLASS_BOOL(dyn_swizzledSetAttributedText);

+ (void)dyn_swizzleSetAttributedText
{
    [[self class] jr_swizzleMethod:@selector(setAttributedText:) withMethod:@selector(dyn_setAttributedText:) error:nil];
    [self set_dyn_swizzledSetAttributedText:YES];
}

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
    if (self.dyn_autoScroll && [[self isScrolling] boolValue] && ![[self isPaused] boolValue] && ![self dynAutoScrollEnabled]) {
    } else {
        [self dyn_drawTextInRect:rect];
    }
}

- (void)dyn_setAttributedText:(NSAttributedString*)text
{
    if ([self dynAutoScrollEnabled]) {
        UILabel *label = [self dynScrollLabel];
        label.text = nil;
        label.attributedText = text;
        [self readjustScrolling];
        [self dyn_setAttributedText:nil];
        
    } else {
        if (self.dyn_autoScroll && ![text.string isEqualToString:self.text]) {
            [self dyn_setAttributedText:text];
            [self resetScrolling];
            [self checkTextSize];
        } else if (!self.dyn_autoScroll) {
            [self dyn_setAttributedText:text];
        }
    }
}

- (void)dyn_setText:(NSString *)text {
    
    if ([self dynAutoScrollEnabled]) {
        UILabel *label = [self dynScrollLabel];
        label.attributedText = nil;
        label.text = text;
        [self readjustScrolling];
        [self dyn_setText:@""];

    } else {
    if (self.dyn_autoScroll && ![text isEqualToString:self.text]) {
        [self dyn_setText:text];
        [self resetScrolling];
        [self checkTextSize];
    } else if (!self.dyn_autoScroll) {
		[self dyn_setText:text];
	}
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
    CGRect b = [[self scrollerView] bounds];
    b.origin.x = 0;
    [[self scrollerView] setBounds:b];
}

- (void)checkTextSize {
    @autoreleasepool {
        
        CGSize size;
        
        if (self.attributedText) {
            CGRect r = [self.attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 context:nil];
            size = r.size;
        } else {
            size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
        }
        
    [self set_totalTextLength:@(size.width)];
    if (size.width >= self.frame.size.width) {
        CGFloat totalDistance = size.width;
        
        
        [[self scrollerView] removeFromSuperview];
        [self set_scrollerView:nil];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self set_scrollerView:scrollView];
        
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
        frame.origin.x =0;
        frame.origin.y = 0;
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
        CGRect b = scrollView.bounds;
        b.origin.x = 0;
        scrollView.bounds = b;
            [self startScrolling];

    } else {
        [self set_isScrolling:@(NO)];
        
       // dispatch_async(dispatch_get_main_queue(), ^{
            if ([self scrollerView]) {
                [[self scrollerView] removeFromSuperview];
            }
       // });
       
        [self setNeedsDisplay];
    }
    }
}

- (void)startScrolling {
    if (![self scrollAnimation]) {
      //  dispatch_async(dispatch_get_main_queue(), ^{
            [self set_isScrolling:@(YES)];
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"bounds.origin.x"];
            anim.fromValue = @(0);
            UILabel *secondLabel = [self secondLabel];
            anim.toValue = @(secondLabel.frame.origin.x);
            anim.delegate = self;
            CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
            
            anim.duration = MAX(4,[[self scrollDuration] doubleValue] / (size.width/self.frame.size.width));
        
                [[[self scrollerView] layer] addAnimation:anim forKey:@"animation"];

            [self set_scrollAnimation:anim];
      ///  });
        
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
    DYNLabelAnimation *a = [self scrollAnimator];
    a.pauseDuration = dyn_scrollPauseDuration;
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
GET_AND_SET_ASSOCIATED_OBJ(scrollTextSeparatorWidth, @(45))

@end

typedef enum {
    LabelPositionScrolled,
    LabelPositionOriginal,
} LabelPosition;
@interface DYNLabelAnimation () <UIDynamicAnimatorDelegate>
{
    NSInteger xHits;
    NSInteger scrollCount;
    NSTimer *_pauseTimer;
}
@property (nonatomic, strong) UIAttachmentBehavior *attachment;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic) LabelPosition labelPosition;
@property (nonatomic) BOOL animate;
@end
@implementation DYNLabelAnimation

- (void)dealloc
{
    [self removeAllBehaviors];

    self.label = nil;
    self.attachment = nil;
    [_pauseTimer invalidate];
    _pauseTimer = nil;
}

- (void)kill
{
    [self removeAllBehaviors];

    self.label = nil;
    self.attachment = nil;
    [_pauseTimer invalidate];
    _pauseTimer = nil;
}
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeAllBehaviors];

    
    if (self.animate) {
        if (self.labelPosition == LabelPositionOriginal) {
            if (scrollCount < self.dyn_numberOfAutoScrolls-1 || self.dyn_numberOfAutoScrolls == 0) {
                [self startPause];
                scrollCount += 1;
            }
            
        } else {
            [self startBounceBackTimer];
        }
    }
    

}

- (void)startBounceBackTimer
{
    
    //     [self.dynamicAnimator removeBehavior:self];;
    [_pauseTimer invalidate];
    _pauseTimer = nil;
    _pauseTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(bounceBackTimerFired) userInfo:nil repeats:NO];

}

- (void)bounceBackTimerFired
{
    [_pauseTimer invalidate];
    _pauseTimer = nil;
    [self startAnimationToPosition:(self.labelPosition == LabelPositionScrolled ? LabelPositionOriginal : LabelPositionScrolled)];

}

- (void)startShortPause
{
    [self removeAllBehaviors];

    [_pauseTimer invalidate];
    _pauseTimer = nil;
    _pauseTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(endPause) userInfo:nil repeats:NO];
}

- (void)startPause
{
    [self removeAllBehaviors];

    [_pauseTimer invalidate];
    _pauseTimer = nil;
    _pauseTimer = [NSTimer scheduledTimerWithTimeInterval:self.pauseDuration target:self selector:@selector(endPause) userInfo:nil repeats:NO];
}

- (void)endPause
{
    if (![_pauseTimer isValid]) return;
    [self startAnimationToPosition:(self.labelPosition == LabelPositionScrolled ? LabelPositionOriginal : LabelPositionScrolled)];

}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
}

- (UIView*)referenceView
{
    return self.label.superview;
}
/*
- (void)setDynamicAnimator:(UIDynamicAnimator *)dynamicAnimator
{
    if (dynamicAnimator != _dynamicAnimator) {
        _dynamicAnimator = dynamicAnimator;
        
        if (dynamicAnimator) {
            [self observeKeypath:@"running" ofObject:dynamicAnimator];
        } else {
            [self removeAllKVO];
        }
    }
    
}
*/

- (void)setAttachment:(UIAttachmentBehavior *)attachment
{
    if (attachment != _attachment) {
        if (attachment == nil) {
            if (self.animate) {
                if (self.labelPosition == LabelPositionOriginal) {
                    if (scrollCount < self.dyn_numberOfAutoScrolls-1 || self.dyn_numberOfAutoScrolls == 0) {
                        [self startPause];
                        scrollCount += 1;
                    }
                    
                } else {
                    //  [self startBounceBackTimer];
                }
            }
        }
    }
}
 
/*
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"running"]) {
        if (self.attachment)
            [self.dynamicAnimator removeBehavior:self.attachment];
        
        
    }
}
*/
- (id)initWithLabel:(UILabel*)label
{
    self = [super initWithReferenceView:label.superview];
    if (self) {
        self.pauseDuration = 4;
        self.label = label;
        [self textChanged];
    }
    return self;
}

- (void)textChanged
{
    scrollCount = 0;
    [self removeAllBehaviors];
    if (_pauseTimer) {
        [_pauseTimer invalidate];
    }
    
    [self.label sizeToFit];
    CGRect f = self.label.frame;
    f.origin.x = 0;
    f.origin.y = (self.label.superview.bounds.size.height-self.label.frame.size.height)/2;
    //CGSize size = [self.label.text sizeWithAttributes:@{NSFontAttributeName:self.label.font}];
    CGSize size;
    if (self.label.attributedText) {
        size = self.label.attributedText.size;
    } else {
        size = [self.label.text sizeWithAttributes:@{NSFontAttributeName:self.label.font}];
    }
    
    f.size.width = size.width;
    self.labelPosition = LabelPositionOriginal;
    if (size.width > self.referenceView.bounds.size.width) {
        self.animate = YES;
        
        [self startShortPause];
        //  [self startAnimationToPosition:LabelPositionScrolled];
    } else {
        self.animate = NO;
        if (self.label.textAlignment == NSTextAlignmentCenter) {
            f.origin.x = (self.label.superview.bounds.size.width-self.label.frame.size.width)/2;
        }
    }
    
    self.label.frame = f;

}

- (void)scroll
{
    if (!self.animate) return;
    [self startAnimationToPosition:(self.labelPosition == LabelPositionScrolled ? LabelPositionOriginal : LabelPositionScrolled)];
}



- (void)startAnimationToPosition:(LabelPosition)targetPosition
{
    @autoreleasepool {
        
    
    if (!self.animate) return;
    if (self.manualOverride) return;
    if (!self.animate) return;
    if (!self.label) return;
        [self removeAllBehaviors];

        self.attachment = nil;
    self.labelPosition = targetPosition;
        
        
    __block UIAttachmentBehavior *attach = [[UIAttachmentBehavior alloc] initWithItem:self.label attachedToAnchor:self.label.center];
    attach.damping = 0.7;
    
    
    attach.frequency = 0.5;
    
    if (self.label.frame.size.width >= self.label.superview.bounds.size.width*2) {
        
        attach.frequency = 0.3;
        attach.damping = 0.6;
        
    } else if (self.label.frame.size.width >= self.label.superview.bounds.size.width*2 - (self.label.superview.bounds.size.width/2)) {
        attach.frequency = 0.4;
        //  attach.damping = 0.6;
    }
    
    /*
    if (self.label.frame.size.width >= (self.label.superview.bounds.size.width + (self.label.superview.bounds.size.width/2))) {
        attach.frequency = 0.4;
    } else if (self.label.frame.size.width >= (self.label.superview.bounds.size.width+(self.label.superview.bounds.size.width/3))) {
        attach.frequency = 0.6;
    }*/
    
    CGFloat targetX;
    if (targetPosition == LabelPositionScrolled) {
        targetX = floorf(self.label.superview.bounds.size.width - (self.label.frame.size.width/2));
    } else {
        targetX = floorf(self.label.frame.size.width/2);
    }

    __weak __typeof(&*self) weakSelf = self;
    __block DYNLabelAnimation *blockSelf = self;
    __block UIAttachmentBehavior *blockAttach = attach;
    blockAttach.action = ^{
        //        DLog(@"center: %f" , weakSelf.label.center.x);
        //DLog(@"target: %f", targetX);
        if (weakSelf.labelPosition == targetPosition) {

            if (weakSelf.label.center.x == targetX) {
                if (targetPosition == LabelPositionScrolled) {
                    [weakSelf startBounceBackTimer];
                    attach.action = nil;
                } else {
                    
                    if (blockSelf->xHits == 1) {
                        blockSelf->xHits = 0;
                        if (weakSelf.attachment)
                            [weakSelf.dynamicAnimator removeBehavior:weakSelf.attachment];
                        
                        weakSelf.attachment = nil;
                        attach = nil;
                    } else {
                        blockSelf->xHits += 1;
                    }
                    
                }
                
            }
        }
        
    };

    if (self.label && self.label.frame.size.width > 0 && self.referenceView.frame.size.width > 0)
        [self addBehavior:attach];
        
        self.attachment = attach;
        // [weakSelf performSelector:@selector(animateToAnchorPoint:) withObject:[NSValue valueWithCGPoint:CGPointMake(targetX, self.label.center.y)] afterDelay:0 inModes:@[NSRunLoopCommonModes]];
        attach.anchorPoint = CGPointMake(targetX, self.label.center.y);
    }
}

- (void)animateToAnchorPoint:(NSValue*)point
{
    self.attachment.anchorPoint = point.CGPointValue;
}

- (void)offsetByX:(CGFloat)xOffset
{
//    
//    if (!self.manualOverride) {
//        return;
//    };
    
    if (!self.animate) return;

    if (!self.attachment) {
       UIAttachmentBehavior *attach = [[UIAttachmentBehavior alloc] initWithItem:self.label attachedToAnchor:self.label.center];
        attach.damping = 0.5;
        
        
        attach.frequency = 1;
        
        self.attachment = attach;
        [self addBehavior:self.attachment];
    } else if (self.attachment && !self.attachment.dynamicAnimator) {
        [self addBehavior:self.attachment];
    }
    
    CGFloat originalX = floorf((self.label.frame.size.width/2));
     self.attachment.anchorPoint = CGPointMake(originalX+xOffset, self.label.center.y);
    
    //[self performSelector:@selector(animateToAnchorPoint:) withObject:[NSValue valueWithCGPoint:CGPointMake(originalX+xOffset, self.label.center.y)] afterDelay:0 inModes:@[NSRunLoopCommonModes]];

//    if (!self.manualOverride) {
//        [self restore];
//    }
}

- (void)restore
{
    [self removeAllBehaviors];

    self.attachment = nil;
    [self startAnimationToPosition:LabelPositionOriginal];

}

GET_AND_SET_ASSOCIATED_OBJ(dyn_numberOfAutoScrolls_val, @(0));

- (void)setDyn_numberOfAutoScrolls:(NSInteger)dyn_numberOfAutoScrolls
{
    [self set_dyn_numberOfAutoScrolls_val:@(dyn_numberOfAutoScrolls)];
}

- (NSInteger)dyn_numberOfAutoScrolls
{
    return [[self dyn_numberOfAutoScrolls_val] integerValue];
}

@end


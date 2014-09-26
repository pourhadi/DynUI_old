//
//  UILabel+DynUI.h
//  TheQ
//
//  Created by Dan Pourhadi on 5/5/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UILabel (DynUI)
@property (nonatomic, strong) NSString *dyn_textStyle;

@property (nonatomic, strong) NSString *dyn_textColorVariableName;

- (void)dyn_refreshStyle;

@property (nonatomic) BOOL dyn_autoScroll;
@property (nonatomic) NSInteger dyn_numberOfAutoScrolls;
@property (nonatomic) BOOL dyn_interactiveScrollingDisabled;

@property (nonatomic) NSTimeInterval dyn_scrollDuration;
@property (nonatomic) NSTimeInterval dyn_scrollPauseDuration;
@property (nonatomic) CGFloat dyn_scrollTextSeparatorWidth;

- (void)applyLabelAttributesToLabel:(UILabel *)label;

@end


@interface DYNLabelAnimation : UIDynamicAnimator

@property (nonatomic, weak) UIDynamicAnimator *dynamicAnimator;

@property (nonatomic) BOOL dyn_interactiveScrollingDisabled;

@property (nonatomic) BOOL manualOverride;

- (void)offsetByX:(CGFloat)xOffset;
- (void)restore;

@property (nonatomic) CGFloat pauseDuration;
@property (nonatomic) NSInteger dyn_numberOfAutoScrolls;

- (void)scroll;
- (id)initWithLabel:(UILabel*)label;

- (void)textChanged;

- (void)kill;

@end
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
        if (![[self class] dpui_layoutSubviewsSwizzled]) {
            [[self class] dpui_swizzleLayoutSubviews];
        }
        
        objc_setAssociatedObject(self, (kDPViewStyleKey), viewStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.dpui_viewStyleApplied = YES;
        self.dpui_refreshStyle = YES;
        [self setNeedsLayout];
    }
}

- (NSString *)dpui_style {
    return objc_getAssociatedObject(self, (kDPViewStyleKey));
}

- (void)setDpui_viewStyleApplied:(BOOL)viewStyleApplied {
    if (self.dpui_viewStyleApplied != viewStyleApplied) {
        objc_setAssociatedObject(self, kDPViewStyleAppliedKey, @(viewStyleApplied), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (viewStyleApplied) {
            __weak __typeof(& *self) weakSelf = self;
            [self dpui_addStyleObserverWithBlock:^(DPUIManager *styleManager, UIView *view) {
                weakSelf.dpui_refreshStyle = YES;
                [weakSelf setNeedsLayout];
            }];
            
            if (![[self class] dpui_deallocSwizzled]) {
                [[self class] dpui_swizzleDealloc];
            }
        } else {
            [self dpui_removeStyleObserver];
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

- (BOOL)dpui_refreshStyle {
    return [objc_getAssociatedObject(self, kDPUIRefreshStyleKey) boolValue];
}

- (void)setDpui_refreshStyle:(BOOL)dpuiRefreshStyle {
    objc_setAssociatedObject(self, kDPUIRefreshStyleKey, @(dpuiRefreshStyle), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (BOOL)dpui_layoutSubviewsSwizzled {
    return [objc_getAssociatedObject([self class], kDPUILayoutSubviewsSwizzled) boolValue];
}

+ (BOOL)dpui_deallocSwizzled {
    return [objc_getAssociatedObject([self class], kDPUIDeallocSwizzled) boolValue];
}

+ (void)dpui_swizzleLayoutSubviews {
    [[self class] jr_swizzleMethod:@selector(layoutSubviews) withMethod:@selector(dpui_layoutSubviews) error:nil];
    objc_setAssociatedObject([self class], kDPUILayoutSubviewsSwizzled, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)dpui_swizzleDealloc {
    [[self class] jr_swizzleMethod:sel_registerName("dealloc") withMethod:@selector(dpui_dealloc) error:nil];
    objc_setAssociatedObject([self class], kDPUIDeallocSwizzled, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dpui_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDPUIThemeChangedNotification object:nil];
    [self dpui_dealloc];
}

- (void)dpui_layoutSubviews {
    [self dpui_layoutSubviews];
    CGSize currentSize = self.frame.size;
    CGSize lastSavedSize = self.dpui_styleSizeApplied;
    
    if (self.dpui_viewStyleApplied && (!CGSizeEqualToSize(currentSize, lastSavedSize) || self.dpui_refreshStyle)) {
        self.dpui_refreshStyle = NO;
        self.dpui_styleSizeApplied = currentSize;
        [DPUIRenderer renderView:self withStyleNamed:self.dpui_style];
    }
}

#pragma mark - Appearance changes observing

- (void)dpui_addStyleObserverWithBlock:(DPUIAppearanceBlock)block;
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dp_appearanceChanged:) name:kDPUIThemeChangedNotification object:nil];
    
    if (block) {
        block([DPUIManager sharedInstance], self);
    }
    
    objc_setAssociatedObject(self, @"_appearanceBlock", block, OBJC_ASSOCIATION_ASSIGN);
}

- (void)dpui_removeStyleObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dp_appearanceChanged:(NSNotification *)note {
    DPUIManager *appearanceObject = (DPUIManager *)note.object;
    
    DPUIAppearanceBlock block = objc_getAssociatedObject(self, @"_appearanceBlock");
    
    if (block) {
        block(appearanceObject, self);
    }
    
    [self layoutIfNeeded];
}

@end

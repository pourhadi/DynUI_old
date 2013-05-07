//
//  UIView+DPStyle.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <UIKit/UIKit.h>
@class DPUIManager;
typedef void(^DPUIAppearanceBlock)(DPUIManager*styleManager, UIView *view);

@interface UIView (DPUI)
@property (nonatomic, strong) NSString *dpui_style; // set this property to assign a style
@property (nonatomic) BOOL dpui_refreshStyle;       // set this to YES to refresh the style during the next draw cycle

@property (nonatomic) BOOL dpui_viewStyleApplied;
@property (nonatomic) CGSize dpui_styleSizeApplied;

+ (BOOL)dpui_layoutSubviewsSwizzled;
+ (BOOL)dpui_deallocSwizzled;
+ (void)dpui_swizzleLayoutSubviews;
+ (void)dpui_swizzleDealloc;

- (void)dpui_addStyleObserverWithBlock:(DPUIAppearanceBlock)block;
- (void)dpui_removeStyleObserver;
@end

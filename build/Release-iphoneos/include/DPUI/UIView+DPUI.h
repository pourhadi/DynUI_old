//
//  UIView+DPStyle.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <UIKit/UIKit.h>
@class DPUIManager;
typedef void (^DPUIAppearanceBlock)(DPUIManager *styleManager, UIView *view);

@interface UIView (DPUI)
@property (nonatomic, strong) NSString *dpui_style; // set this property to assign a style
@property (nonatomic) BOOL dpui_refreshStyle;       // set this to YES to refresh the style during the next draw cycle

@property (nonatomic) BOOL dpui_viewStyleApplied;
@property (nonatomic) CGSize dpui_styleSizeApplied;

/*!
@method dpui_addStyleObserverWithBlock:
@abstract Add an observer to the view that will call the passed block each time the loaded styles are changed
@param block The block to perform every time the loaded styles are changed
*/
- (void)dpui_addStyleObserverWithBlock:(DPUIAppearanceBlock)block;

- (void)dpui_removeStyleObserver;

// swizzle methods for the library. do not call
+ (BOOL)dpui_layoutSubviewsSwizzled;
+ (BOOL)dpui_deallocSwizzled;
+ (void)dpui_swizzleLayoutSubviews;
+ (void)dpui_swizzleDealloc;
//////////////


@end

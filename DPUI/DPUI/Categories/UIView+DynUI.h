//
//  UIView+DPStyle.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <UIKit/UIKit.h>
@class DYNManager;
@class DYNStyleParameters;
typedef void (^DYNAppearanceBlock)(DYNManager *styleManager, UIView *view);

@interface UIView (DynUI)
@property (nonatomic, strong) NSString *dyn_style; // set this property to assign a style
- (void)setValuesForStyleParameters:(NSDictionary*)valuesForParams;
- (void)setValue:(id)value forStyleParameter:(NSString *)parameterName;

@property (nonatomic, strong) DYNStyleParameters *styleParameters;

@property (nonatomic) BOOL dyn_viewStyleApplied;
@property (nonatomic) CGSize dyn_styleSizeApplied;

- (void)dyn_refreshStyle;

- (void)dyn_frameChanged;

// swizzle methods for the library. do not call
+ (BOOL)dyn_deallocSwizzled;
+ (void)dyn_swizzleDealloc;
//////////////


@end

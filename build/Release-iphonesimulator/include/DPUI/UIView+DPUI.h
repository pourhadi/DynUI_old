//
//  UIView+DPStyle.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <UIKit/UIKit.h>
@class DPUIManager;
@class DPUIStyleParameters;
typedef void (^DPUIAppearanceBlock)(DPUIManager *styleManager, UIView *view);

@interface UIView (DPUI)
@property (nonatomic, strong) NSString *dpui_style; // set this property to assign a style
- (void)setValuesForStyleParameters:(NSDictionary*)valuesForParams;
- (void)setValue:(id)value forStyleParameter:(NSString *)parameterName;

@property (nonatomic, strong) DPUIStyleParameters *styleParameters;

@property (nonatomic) BOOL dpui_viewStyleApplied;
@property (nonatomic) CGSize dpui_styleSizeApplied;

- (void)dpui_refreshStyle;

- (void)dpui_frameChanged;

// swizzle methods for the library. do not call
+ (BOOL)dpui_deallocSwizzled;
+ (void)dpui_swizzleDealloc;
//////////////


@end

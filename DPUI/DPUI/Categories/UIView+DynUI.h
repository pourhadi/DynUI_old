//
//  UIView+DPStyle.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DYNManager;
@class DYNStyleParameters;
@class DYNPassThroughView;
typedef void (^DYNAppearanceBlock)(DYNManager *styleManager, UIView *view);

NS_INLINE CGRect CGRectCenteredInRect(CGRect rect, CGRect inRect) {
    
    CGRect centeredR;
    centeredR.size.height = rect.size.height;
    centeredR.size.width = rect.size.width;
    centeredR.origin.x = (inRect.size.width - rect.size.width) / 2;
    centeredR.origin.y = (inRect.size.height - rect.size.height) / 2;
    return centeredR;
    
}

@interface UIView (DynUI)
@property (nonatomic, strong) NSString *dyn_style; // set this property to assign a style
- (void)setValuesForStyleParameters:(NSDictionary *)valuesForParams;
- (void)setValue:(id)value forStyleParameter:(NSString *)parameterName;

@property (nonatomic, strong) DYNStyleParameters *styleParameters;

@property (nonatomic) BOOL dyn_viewStyleApplied;
@property (nonatomic) CGSize dyn_styleSizeApplied;

@property (nonatomic, assign) UIView *dyn_backgroundView; // i.e., for UITableView
@property (nonatomic, strong) DYNPassThroughView *dyn_overlayView; // so the stroke and inner borders are above everything else

@property (nonatomic) NSValue *dyn_fadedEdgeInsets;

- (void)dyn_refreshStyle;

- (void)dyn_frameChanged;

- (void)dyn_dealloc;

- (UIImage*)imageFromSnapshot;
- (UIImage*)imageFromSnapshotInRect:(CGRect)rect;

@end

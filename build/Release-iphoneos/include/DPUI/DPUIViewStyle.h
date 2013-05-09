//
//  DPViewStyle.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>
#import "DPUIStyle.h"
@class DPUIShadowStyle;
@class DPUITextStyle;
@class DPUIBackgroundStyle;
@class DPUIColor;
@class DPUIControlStyle;
@interface DPUIViewStyle : DPUIStyle

@property (nonatomic, strong) DPUIBackgroundStyle *background;

@property (nonatomic, strong) NSArray *topInnerBorders; // DPStyleInnerBorder objects
@property (nonatomic, strong) NSArray *bottomInnerBorders; // DPStyleInnerBorder objects

@property (nonatomic, strong) DPUIShadowStyle *shadow;
@property (nonatomic, strong) DPUIShadowStyle *innerShadow; // will be placed underneath inner borders

@property (nonatomic) CGSize cornerRadii;
@property (nonatomic) UIRectCorner roundedCorners;
@property (nonatomic) BOOL maskToCorners; // clip the view's contents to the rounded corners

@property (nonatomic, strong) DPUIColor *strokeColor;
@property (nonatomic) CGFloat strokeWidth;

@property (nonatomic, strong) UIColor *canvasBackgroundColor;

// Navigation bar

@property (nonatomic, strong) DPUITextStyle *navBarTitleTextStyle;

// UITableViewCell styles

@property (nonatomic, strong) DPUITextStyle *tableCellTitleTextStyle;
@property (nonatomic, strong) DPUITextStyle *tableCellDetailTextStyle;

// UIBarButtonItem styles
@property (nonatomic, strong) NSString *barButtonItemStyleName;

@property (nonatomic, strong) DPUIControlStyle *controlStyle;

- (void)applyStyleToView:(UIView *)view;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (UIImage *)imageForStyleWithSize:(CGSize)size;
- (UIImage *)imageForStyleWithSize:(CGSize)size withOuterShadow:(BOOL)withOuterShadow;
- (UIImage *)imageForStyleWithSize:(CGSize)size withOuterShadow:(BOOL)withOuterShadow flippedGradient:(BOOL)flippedGradient;
- (UIImage *)imageForStyleWithSize:(CGSize)size path:(UIBezierPath*)path withOuterShadow:(BOOL)withOuterShadow;
- (UIImage *)imageForStyleWithSize:(CGSize)size path:(UIBezierPath*)path withOuterShadow:(BOOL)withOuterShadow flippedGradient:(BOOL)gradient;
@end

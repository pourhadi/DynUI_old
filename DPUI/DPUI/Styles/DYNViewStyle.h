//
//  DPViewStyle.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>
#import "DYNStyle.h"
@class DYNShadowStyle;
@class DYNTextStyle;
@class DYNBackgroundStyle;
@class DYNColor;
@class DYNControlStyle;
@class DYNStyleParameters;

typedef NS_OPTIONS(NSUInteger, CornerRadiusType) {
	CornerRadiusTypeCustom,
	CornerRadiusTypeHalfHeight,
	CornerRadiusTypeHalfWidth,
};

@interface DYNViewStyle : DYNStyle

@property (nonatomic, strong) DYNBackgroundStyle *background;

@property (nonatomic, strong) NSArray *topInnerBorders; // DPStyleInnerBorder objects
@property (nonatomic, strong) NSArray *bottomInnerBorders; // DPStyleInnerBorder objects

@property (nonatomic, strong) NSArray *leftInnerBorders;
@property (nonatomic, strong) NSArray *rightInnerBorders;

@property (nonatomic, strong) DYNShadowStyle *shadow;
@property (nonatomic, strong) DYNShadowStyle *innerShadow; // will be placed underneath inner borders

@property (nonatomic) CornerRadiusType cornerRadiusType;
@property (nonatomic) CGSize cornerRadii;
@property (nonatomic) UIRectCorner roundedCorners;
@property (nonatomic) BOOL maskToCorners; // clip the view's contents to the rounded corners

@property (nonatomic, strong) DYNColor *strokeColor;
@property (nonatomic) CGFloat strokeWidth;

@property (nonatomic, strong) UIColor *canvasBackgroundColor;

@property (nonatomic) BOOL drawAsynchronously;

// Search bar

@property (nonatomic, strong) NSString *searchFieldStyleName;
@property (nonatomic, strong) NSString *searchFieldTextStyleName;

// Navigation bar

@property (nonatomic, strong) DYNTextStyle *navBarTitleTextStyle;

// UITableViewCell styles

@property (nonatomic, strong) DYNTextStyle *tableCellTitleTextStyle;
@property (nonatomic, strong) DYNTextStyle *tableCellDetailTextStyle;

// UIBarButtonItem styles
@property (nonatomic, strong) NSString *barButtonItemStyleName;

// control styles
@property (nonatomic, strong) DYNControlStyle *controlStyle;

// UITextField
@property (nonatomic, strong) DYNTextStyle *textFieldTextStyle;

// UISegmentedControl
@property (nonatomic, strong) DYNControlStyle *segmentedControlStyle;
@property (nonatomic) CGFloat segmentDividerWidth;
@property (nonatomic, strong) DYNColor *segmentDividerColor;

// UITableView - grouped
@property (nonatomic, strong) NSString *groupedTableTopCell;
@property (nonatomic, strong) NSString *groupedTableMiddleCell;
@property (nonatomic, strong) NSString *groupedTableSingleCell;
@property (nonatomic, strong) NSString *groupedTableBottomCell;

- (void)applyStyleToView:(UIView *)view;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (CALayer*)layerMaskForStyleWithSize:(CGSize)size;
- (UIImage *)imageForStyleWithSize:(CGSize)size parameters:(DYNStyleParameters *)parameters;
- (UIImage *)imageForStyleWithSize:(CGSize)size withOuterShadow:(BOOL)withOuterShadow parameters:(DYNStyleParameters *)parameters;
- (UIImage *)imageForStyleWithSize:(CGSize)size withOuterShadow:(BOOL)withOuterShadow flippedGradient:(BOOL)flippedGradient parameters:(DYNStyleParameters *)parameters;
- (UIImage *)imageForStyleWithSize:(CGSize)size path:(UIBezierPath *)path withOuterShadow:(BOOL)withOuterShadow parameters:(DYNStyleParameters *)parameters;
- (UIImage *)imageForStyleWithSize:(CGSize)size path:(UIBezierPath *)path withOuterShadow:(BOOL)withOuterShadow flippedGradient:(BOOL)gradient parameters:(DYNStyleParameters *)parameters;

- (UIBezierPath*)pathForStyleForRect:(CGRect)rect;
- (UIBezierPath*)strokePathForStyleForRect:(CGRect)rect;
- (UIBezierPath*)strokePathForPath:(UIBezierPath*)path;
@end

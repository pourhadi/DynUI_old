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

- (id)initWithDictionary:(NSDictionary *)dictionary;

///---------------------------------------------------------------------------------------
/// @name General Style Properties
///---------------------------------------------------------------------------------------
@property (nonatomic, strong) DYNBackgroundStyle *background;

/** NSArray of DYNInnerBorderStyle objects that specify the borders to draw on the top side of the view. 
 
 Borders are drawn on top of each other corresponding to the order of the objects in the array.*/
@property (nonatomic, strong) NSArray *topInnerBorders;

/** NSArray of DYNInnerBorderStyle objects that specify the borders to draw on the bottom side of the view.
 
 Borders are drawn on top of each other corresponding to the order of the objects in the array.*/
@property (nonatomic, strong) NSArray *bottomInnerBorders;

/** NSArray of DYNInnerBorderStyle objects that specify the borders to draw on the left side of the view.
 
 Borders are drawn on top of each other corresponding to the order of the objects in the array.*/
@property (nonatomic, strong) NSArray *leftInnerBorders;

/** NSArray of DYNInnerBorderStyle objects that specify the borders to draw on the right side of the view.
 
 Borders are drawn on top of each other corresponding to the order of the objects in the array.*/
@property (nonatomic, strong) NSArray *rightInnerBorders;

@property (nonatomic, strong) DYNShadowStyle *shadow;

/** The inner shadow is applied underneath borders and the stroke. */
@property (nonatomic, strong) DYNShadowStyle *innerShadow;

@property (nonatomic) CornerRadiusType cornerRadiusType;
@property (nonatomic) CGSize cornerRadii;
@property (nonatomic) UIRectCorner roundedCorners;

/** If YES, clip the view's contents to the rounded corners. */
@property (nonatomic) BOOL maskToCorners;

@property (nonatomic, strong) DYNColor *strokeColor;
@property (nonatomic) CGFloat strokeWidth;

@property (nonatomic, strong) UIColor *canvasBackgroundColor;

@property (nonatomic) BOOL drawAsynchronously;

///---------------------------------------------------------------------------------------
/// @name UISearchBar Style Properties
///---------------------------------------------------------------------------------------

/** The name of the DYNViewStyle object used to style the UISearchBar's search field when this style is applied to a UISearchBar. */
@property (nonatomic, strong) NSString *searchFieldStyleName;

/** The name of the DYNTextStyle object used to style the UISearchBar's search field text when this style is applied to a UISearchBar. */
@property (nonatomic, strong) NSString *searchFieldTextStyleName;

///---------------------------------------------------------------------------------------
/// @name UINavigationBar Style Properties
///---------------------------------------------------------------------------------------

/** The DYNTextStyle object used to supply the title text attributes of the UINavigationBar when this style is applied to a UINavigationBar. */
@property (nonatomic, strong) DYNTextStyle *navBarTitleTextStyle;

/** The name of the DYNViewStyle object used to style UIBarButtonItems when this style is applied to a UINavigationBar. */
@property (nonatomic, strong) NSString *barButtonItemStyleName;

///---------------------------------------------------------------------------------------
/// @name UITableViewCell Style Properties
///---------------------------------------------------------------------------------------

/** The name of the DYNTextStyle object used to style the UITableViewCell's textLabel text when this style is applied to a UITableViewCell.*/
@property (nonatomic, strong) DYNTextStyle *tableCellTitleTextStyle;

/** The name of the DYNTextStyle object used to style the UITableViewCell's detailTextLabel text when this style is applied to a UITableViewCell.*/
@property (nonatomic, strong) DYNTextStyle *tableCellDetailTextStyle;

///---------------------------------------------------------------------------------------
/// @name UIControl Style Properties
///---------------------------------------------------------------------------------------

/** When this style is applied to UIBarButtonItems or UIButtons, this DYNControlStyle object will be used to style its various UIControlStates. */
@property (nonatomic, strong) DYNControlStyle *controlStyle;

///---------------------------------------------------------------------------------------
/// @name UITextField Style Properties
///---------------------------------------------------------------------------------------

/** When this style is applied to a UITextField, this DYNTextStyle object will be used to style the field's text. */
@property (nonatomic, strong) DYNTextStyle *textFieldTextStyle;

///---------------------------------------------------------------------------------------
/// @name UISegmentControl Style Properties
///---------------------------------------------------------------------------------------
@property (nonatomic, strong) DYNControlStyle *segmentedControlStyle;
@property (nonatomic) CGFloat segmentDividerWidth;
@property (nonatomic, strong) DYNColor *segmentDividerColor;

///---------------------------------------------------------------------------------------
/// @name UITableView Style Properties
///---------------------------------------------------------------------------------------

/** The name of the DYNViewStyle object used to style the top cell of a section when this style is applied to a grouped UITableView. 
 
To use this, the grouped UITableView's delegate must call -dyn_styleGroupedCell:forIndexPath: on the UITableView from within the -tableView:willDisplayCell:forRowAtIndexPath: method. */
@property (nonatomic, strong) NSString *groupedTableTopCell;

/** The name of the DYNViewStyle object used to style the middle cells of sections when this style is applied to a grouped UITableView. 
 
 To use this, the grouped UITableView's delegate must call -dyn_styleGroupedCell:forIndexPath: on the UITableView from within the -tableView:willDisplayCell:forRowAtIndexPath: method. */
@property (nonatomic, strong) NSString *groupedTableMiddleCell;

/** The name of the DYNViewStyle object used to style the bottom cells of sections when this style is applied to a grouped UITableView.
 
 To use this, the grouped UITableView's delegate must call -dyn_styleGroupedCell:forIndexPath: on the UITableView from within the -tableView:willDisplayCell:forRowAtIndexPath: method. */
@property (nonatomic, strong) NSString *groupedTableBottomCell;

/** The name of the DYNViewStyle object used to style the cells of sections that have only a single row when this style is applied to a grouped UITableView.
 
 To use this, the grouped UITableView's delegate must call -dyn_styleGroupedCell:forIndexPath: on the UITableView from within the -tableView:willDisplayCell:forRowAtIndexPath: method. */
@property (nonatomic, strong) NSString *groupedTableSingleCell;


///---------------------------------------------------------------------------------------
/// @name Using DYNViewStyle
///---------------------------------------------------------------------------------------

/** Apply this style to the given view. 
 
 @param view The view to style.
 */
- (void)applyStyleToView:(UIView *)view;

/** Generate an image from this style.
 
 @param size The size of the image to return.
 @param parameters The style parameters to apply when rendering this style. May be nil.
 
 */
- (UIImage *)imageForStyleWithSize:(CGSize)size parameters:(DYNStyleParameters *)parameters;

/** Generate an image from this style.
 
 @param size The size of the image to return.
 @param withOuterShadow Specifies whether to draw the outer shadow. If YES, the size of the returned image will be adjusted to fit the shadow.
 @param parameters The style parameters to apply when rendering this style. May be nil.
 
 */
- (UIImage *)imageForStyleWithSize:(CGSize)size withOuterShadow:(BOOL)withOuterShadow parameters:(DYNStyleParameters *)parameters;

/** Generate an image from this style.
 
 @param size The size of the image to return.
 @param withOuterShadow Specifies whether to draw the outer shadow. If YES, the size of the returned image will be adjusted to fit the shadow.
 @param flippedGradient Specifies whether to reverse the direction of the gradient.
 @param parameters The style parameters to apply when rendering this style. May be nil.
 
 */
- (UIImage *)imageForStyleWithSize:(CGSize)size withOuterShadow:(BOOL)withOuterShadow flippedGradient:(BOOL)flippedGradient parameters:(DYNStyleParameters *)parameters;

/** Generate an image from this style.
 
 @param size The size of the image to return.
 @param path The path in which to draw and render this style's properties.
 @param withOuterShadow Specifies whether to draw the outer shadow. If YES, the size of the returned image will be adjusted to fit the shadow.
 @param parameters The style parameters to apply when rendering this style. May be nil.
 
 */
- (UIImage *)imageForStyleWithSize:(CGSize)size path:(UIBezierPath *)path withOuterShadow:(BOOL)withOuterShadow parameters:(DYNStyleParameters *)parameters;

/** Generate an image from this style.
 
 @param size The size of the image to return.
 @param path The path in which to draw and render this style's properties.
 @param withOuterShadow Specifies whether to draw the outer shadow. If YES, the size of the returned image will be adjusted to fit the shadow.
 @param flippedGradient Specifies whether to reverse the direction of the gradient.
 @param parameters The style parameters to apply when rendering this style. May be nil.
 
 */
- (UIImage *)imageForStyleWithSize:(CGSize)size path:(UIBezierPath *)path withOuterShadow:(BOOL)withOuterShadow flippedGradient:(BOOL)flippedGradient parameters:(DYNStyleParameters *)parameters;

/** Returns a CALayer object derived from this style's path that can be used a layer mask.
 
 @param size The size of the layer to return. 
 
 */
- (CALayer*)layerMaskForStyleWithSize:(CGSize)size;

/** Returns an image with only the stroke, and top, bottom, left, and right borders drawn
 
 @param size The size of the image to return.
 @param parameters The style parameters to apply when rendering this style. May be nil.

 */
- (UIImage*)borderImageForSize:(CGSize)size parameters:(DYNStyleParameters*)parameters;


///---------------------------------------------------------------------------------------
/// @name Deriving paths for the style
///---------------------------------------------------------------------------------------

/** Returns a UIBezierPath for the given rect. 
 
 @param rect The rect used to construct the UIBezierPath.
 */
- (UIBezierPath*)pathForStyleForRect:(CGRect)rect;

/** Returns a UIBezierPath for the given rect, inset by this style's strokeWidth property.
 
 @param rect The rect used to construct the UIBezierPath.
 */
- (UIBezierPath*)strokePathForStyleForRect:(CGRect)rect;

/** Transforms the provided path and returns a path inset by this style's strokeWidth.
 
 @param path The path to transform.
 */
- (UIBezierPath*)strokePathForPath:(UIBezierPath*)path;
@end

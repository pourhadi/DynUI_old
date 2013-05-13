//
//  DPStyleRenderer.h
//  TheQ
//
//  Created by Daniel Pourhadi on 4/29/13.
//
//

#import <Foundation/Foundation.h>
@class DYNViewStyle;
@class DYNStyleParameters;
@interface DYNRenderer : NSObject

+ (void)renderView:(UIView *)view withStyleNamed:(NSString *)styleName;
+ (void)renderNavigationBar:(UINavigationBar *)navigationBar withStyleNamed:(NSString *)styleName;
+ (void)renderTableCell:(UITableViewCell *)tableCell withStyleNamed:(NSString *)styleName;
+ (void)renderButton:(UIButton *)button withStyleNamed:(NSString *)styleName;
+ (void)renderToolbar:(UIToolbar*)toolbar withStyleNamed:(NSString*)styleName;
+ (void)renderSearchBar:(UISearchBar*)searchBar withStyleNamed:(NSString*)styleName;
+ (void)renderSlider:(UISlider*)slider withSliderStyleNamed:(NSString*)name;

+ (UIImage *)backBarButtonImageForStyle:(NSString *)style superStyle:(DYNViewStyle *)superStyle parameters:(DYNStyleParameters *)parameters;
@end
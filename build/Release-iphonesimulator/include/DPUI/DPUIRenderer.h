//
//  DPStyleRenderer.h
//  TheQ
//
//  Created by Daniel Pourhadi on 4/29/13.
//
//

#import <Foundation/Foundation.h>
@class DPUIViewStyle;
@class DPUIStyleParameters;
@interface DPUIRenderer : NSObject

+ (void)renderView:(UIView *)view withStyleNamed:(NSString *)styleName;
+ (void)renderNavigationBar:(UINavigationBar *)navigationBar withStyleNamed:(NSString *)styleName;
+ (void)renderTableCell:(UITableViewCell *)tableCell withStyleNamed:(NSString *)styleName;
+ (void)renderButton:(UIButton *)button withStyleNamed:(NSString *)styleName;
+ (void)renderToolbar:(UIToolbar*)toolbar withStyleNamed:(NSString*)styleName;
+ (UIImage *)backBarButtonImageForStyle:(NSString *)style superStyle:(DPUIViewStyle *)superStyle parameters:(DPUIStyleParameters *)parameters;
@end

//
//  DPStyleRenderer.h
//  TheQ
//
//  Created by Daniel Pourhadi on 4/29/13.
//
//

#import <Foundation/Foundation.h>
@class DPUIViewStyle;
@interface DPUIRenderer : NSObject

+ (void)renderView:(UIView *)view withStyleNamed:(NSString *)styleName;
+ (void)renderNavigationBar:(UINavigationBar *)navigationBar withStyleNamed:(NSString *)styleName;
+ (void)renderTableCell:(UITableViewCell *)tableCell withStyleNamed:(NSString *)styleName;
+ (void)renderButton:(UIButton*)button withStyleNamed:(NSString*)styleName;
+ (UIImage*)backBarButtonImageForStyle:(NSString*)style superStyle:(DPUIViewStyle*)superStyle;
@end

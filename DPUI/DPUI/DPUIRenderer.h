//
//  DPStyleRenderer.h
//  TheQ
//
//  Created by Daniel Pourhadi on 4/29/13.
//
//

#import <Foundation/Foundation.h>

@interface DPUIRenderer : NSObject

+ (void)renderView:(UIView *)view withStyleNamed:(NSString *)styleName;
+ (void)renderNavigationBar:(UINavigationBar *)navigationBar withStyleNamed:(NSString *)styleName;
+ (void)renderTableCell:(UITableViewCell *)tableCell withStyleNamed:(NSString *)styleName;

+ (UIImage*)backBarButtonImageForStyle:(NSString*)style;
@end

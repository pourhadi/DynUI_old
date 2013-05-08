//
//  UIColor+DPStyle.h
//  TheQ
//
//  Created by Dan Pourhadi on 5/2/13.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (DPUI)

+ (UIColor*)colorFromHex:(NSString*)hex;
+ (UIColor*)colorForVariable:(NSString*)variable;
+ (UIColor*)colorFromCIString:(NSString*)string;
+ (CIColor*)uiColorToCIColor:(UIColor*)color;
@end

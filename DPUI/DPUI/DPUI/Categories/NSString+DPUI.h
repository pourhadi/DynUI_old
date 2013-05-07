//
//  NSString+DPUI.h
//  TheQ
//
//  Created by Dan Pourhadi on 5/6/13.
//
//

#import <Foundation/Foundation.h>

@interface NSString (DPUI)
- (void)dpui_drawAtPoint:(CGPoint)point forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode withStyle:(NSString*)dpuiTextStyle;
@end

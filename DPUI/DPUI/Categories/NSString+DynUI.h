//
//  NSString+DynUI.h
//  TheQ
//
//  Created by Dan Pourhadi on 5/6/13.
//
//

#import <UIKit/NSStringDrawing.h>
@interface NSString (DynUI)
- (void)dyn_drawAtPoint:(CGPoint)point forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode withStyle:(NSString *)DYNTextStyle;
- (void)dyn_drawInRect:(CGRect)rect lineBreakMode:(NSLineBreakMode)lineBreakMode withStyle:(NSString*)textStyle;
@end

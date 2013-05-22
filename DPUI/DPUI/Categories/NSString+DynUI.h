//
//  NSString+DynUI.h
//  TheQ
//
//  Created by Dan Pourhadi on 5/6/13.
//
//

#import <UIKit/NSStringDrawing.h>
@class DYNTextStyle;
@interface NSString (DynUI)
- (void)dyn_drawAtPoint:(CGPoint)point forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode withStyleNamed:(NSString *)DYNTextStyle;
- (void)dyn_drawInRect:(CGRect)rect lineBreakMode:(NSLineBreakMode)lineBreakMode withStyleNamed:(NSString *)textStyle;

- (void)dyn_drawInRect:(CGRect)rect lineBreakMode:(NSLineBreakMode)lineBreakMode withStyle:(DYNTextStyle *)style;
@end

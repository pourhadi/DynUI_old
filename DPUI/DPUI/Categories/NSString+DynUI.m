//
//  NSString+DYN.m
//  TheQ
//
//  Created by Dan Pourhadi on 5/6/13.
//
//

#import "NSString+DynUI.h"
#import "DYNDefines.h"
#import "DynUI.h"
@implementation NSString (DynUI)

- (void)dyn_drawAtPoint:(CGPoint)point forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode withStyle:(NSString *)textStyle {
    DYNTextStyle *style = [[DYNManager sharedInstance] textStyleForName:textStyle];
    
    [style.shadowColor.color set];
    CGPoint offsetPoint = point;
    offsetPoint.x = point.x + style.shadowOffset.width;
    offsetPoint.y = point.y + style.shadowOffset.height;
    
    [self drawAtPoint:offsetPoint forWidth:width withFont:style.font lineBreakMode:lineBreakMode];
    
    [style.textColor.color set];
    
    [self drawAtPoint:point forWidth:width withFont:style.font lineBreakMode:lineBreakMode];
}

@end

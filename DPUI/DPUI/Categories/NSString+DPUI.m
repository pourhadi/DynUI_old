//
//  NSString+DPUI.m
//  TheQ
//
//  Created by Dan Pourhadi on 5/6/13.
//
//

#import "NSString+DPUI.h"

@implementation NSString (DPUI)

- (void)dpui_drawAtPoint:(CGPoint)point forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode withStyle:(NSString*)dpuiTextStyle
{
	DPUITextStyle *style = [[DPUIManager sharedInstance] textStyleForName:dpuiTextStyle];
	
	[style.shadowColor.color set];
	CGPoint offsetPoint = point;
	offsetPoint.x = point.x + style.shadowOffset.width;
	offsetPoint.y = point.y + style.shadowOffset.height;
	
	[self drawAtPoint:offsetPoint forWidth:width withFont:style.font lineBreakMode:lineBreakMode];
	
	[style.textColor.color set];
	
	[self drawAtPoint:point forWidth:width withFont:style.font lineBreakMode:lineBreakMode];
	
}

@end

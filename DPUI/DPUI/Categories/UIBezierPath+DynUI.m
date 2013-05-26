//
//  UIBezierPath+DynUI.m
//  DynUI-Example
//
//  Created by Dan Pourhadi on 5/26/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "UIBezierPath+DynUI.h"

@implementation UIBezierPath (DynUI)

- (void)centerInRect:(CGRect)rect
{	
	UIBezierPath *path = self;
	
	CGAffineTransform transform = CGAffineTransformMakeTranslation(-(path.bounds.origin.x)*(1-(1/rect.size.width)), -(path.bounds.origin.y) *(1-(1 / rect.size.height)));
	[path applyTransform:transform];
	
	CGFloat xTrans = rect.origin.x + ((rect.size.width-path.bounds.size.width)/2);
	CGFloat yTrans = rect.origin.y + ((rect.size.height-path.bounds.size.height)/2);
	
	transform = CGAffineTransformMakeTranslation(xTrans, yTrans);
	[path applyTransform:transform];
}


@end

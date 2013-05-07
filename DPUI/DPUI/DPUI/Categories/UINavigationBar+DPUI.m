//
//  UINavigationBar+DPUI.m
//  TheQ
//
//  Created by Dan Pourhadi on 5/3/13.
//
//

#import "UINavigationBar+DPUI.h"
#import "DPUIRenderer.h"
#import "UIView+DPUI.h"
@implementation UINavigationBar (DPUI)


- (void)dpui_layoutSubviews
{
	[self dpui_layoutSubviews];
	CGSize currentSize = self.frame.size;
	CGSize lastSavedSize = self.dpui_styleSizeApplied;
	
	if (self.dpui_viewStyleApplied && (!CGSizeEqualToSize(currentSize, lastSavedSize) || self.dpui_refreshStyle)) {
		self.dpui_styleSizeApplied = currentSize;
		self.dpui_refreshStyle = NO;
		[DPUIRenderer renderNavigationBar:self withStyleNamed:self.dpui_style];
	}
}

@end

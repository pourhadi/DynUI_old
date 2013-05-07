//
//  UITableViewCell+DPUI.m
//  TheQ
//
//  Created by Dan Pourhadi on 5/6/13.
//
//

#import "UITableViewCell+DPUI.h"

@implementation UITableViewCell (DPUI)

- (void)dpui_layoutSubviews
{
	[self dpui_layoutSubviews];
	CGSize currentSize = self.frame.size;
	CGSize lastSavedSize = self.dpui_styleSizeApplied;
	
	if (self.dpui_viewStyleApplied && (!CGSizeEqualToSize(currentSize, lastSavedSize) || self.dpui_refreshStyle)) {
		self.dpui_styleSizeApplied = currentSize;
		self.dpui_refreshStyle = NO;
		[DPUIRenderer renderTableCell:self withStyleNamed:self.dpui_style];
	}
}

@end

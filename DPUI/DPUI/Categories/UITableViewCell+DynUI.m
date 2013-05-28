//
//  UITableViewCell+DynUI.m
//  DynUI-Example
//
//  Created by Dan Pourhadi on 5/25/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "UITableViewCell+DynUI.h"
#import "DYNDefines.h"
#import "DynUI.h"
@implementation UITableViewCell (DynUI)

- (void)setDyn_style:(NSString*)styleName
{
	[super setDyn_style:styleName];
	
	DYNViewStyle *style = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:styleName];

	if (style && style.tableCellTitleTextStyle) {
        [style.tableCellTitleTextStyle applyToLabel:self.textLabel];
    }
    
    if (style && style.tableCellDetailTextStyle) {
        [style.tableCellDetailTextStyle applyToLabel:self.detailTextLabel];
    }
	
	if (self.accessoryType == UITableViewCellAccessoryCheckmark) {
		UIColor *accessoryColor;
		
		if (style.tableCellTitleTextStyle) {
			accessoryColor = style.tableCellTitleTextStyle.textColor.color;
		} else if (style.tableCellDetailTextStyle) {
			accessoryColor = style.tableCellDetailTextStyle.textColor.color;
		}
		
		UIImage *check = [UIImage iconImage:kDYNIconCheckKey forHeight:13 color:accessoryColor];
		UIImageView *checkView = [[UIImageView alloc] initWithImage:check];
		checkView.frame = CGRectMake(0, 0, check.size.width, check.size.height);
		
		self.accessoryView = checkView;
	} else if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
		UIColor *accessoryColor;
		
		if (style.tableCellTitleTextStyle) {
			accessoryColor = style.tableCellTitleTextStyle.textColor.color;
		} else if (style.tableCellDetailTextStyle) {
			accessoryColor = style.tableCellDetailTextStyle.textColor.color;
		}
		
		UIImage *chevron = [UIImage iconImage:kDYNIconArrowright2Key forHeight:13 color:accessoryColor];
		UIImageView *chevronView = [[UIImageView alloc] initWithImage:chevron];
		chevronView.frame = CGRectMake(0, 0, chevron.size.width, chevron.size.height);
		
		self.accessoryView = chevronView;
	}
}

- (void)setDyn_selectedBackgroundView:(UIView *)dyn_selectedBackgroundView
{
	[self set_dyn_selectedBackgroundView:dyn_selectedBackgroundView];
}

GET_AND_SET_ASSOCIATED_OBJ(dyn_selectedBackgroundView, nil);

@end

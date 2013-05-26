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

	if (style.tableCellTitleTextStyle) {
        [style.tableCellTitleTextStyle applyToLabel:self.textLabel];
    }
    
    if (style.tableCellDetailTextStyle) {
        [style.tableCellDetailTextStyle applyToLabel:self.detailTextLabel];
    }
	
	
}

- (void)setDyn_selectedBackgroundView:(UIView *)dyn_selectedBackgroundView
{
	[self set_dyn_selectedBackgroundView:dyn_selectedBackgroundView];
}

GET_AND_SET_ASSOCIATED_OBJ(dyn_selectedBackgroundView, nil);

@end

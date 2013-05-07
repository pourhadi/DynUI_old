//
//  DPStyleRenderer.m
//  TheQ
//
//  Created by Daniel Pourhadi on 4/29/13.
//
//

#import "DPUIRenderer.h"
#import "DPUIViewStyle.h"
#import "DPUIManager.h"
@implementation DPUIRenderer
+ (void)renderView:(UIView*)view withStyleNamed:(NSString*)styleName
{
	DPUIViewStyle *style = (DPUIViewStyle*)[[DPUIManager sharedInstance] styleForName:styleName];
	
	[style applyStyleToView:view];
}

+ (void)renderNavigationBar:(UINavigationBar*)navigationBar withStyleNamed:(NSString*)styleName
{
	DPUIViewStyle *style = (DPUIViewStyle*)[[DPUIManager sharedInstance] styleForName:styleName];

	UIImage *img = [style imageForStyleWithSize:navigationBar.frame.size];
	[navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
	
	if (style.navBarTitleTextStyle)	{
		[navigationBar setTitleTextAttributes:style.navBarTitleTextStyle.titleTextAttributes];
	}
}

+ (void)renderTableCell:(UITableViewCell*)tableCell withStyleNamed:(NSString*)styleName
{
	DPUIViewStyle *style = (DPUIViewStyle*)[[DPUIManager sharedInstance] styleForName:styleName];
	
	UIImage *img = [style imageForStyleWithSize:tableCell.frame.size];
	UIView *backgroundView = [[UIView alloc] initWithFrame:tableCell.bounds];
	backgroundView.layer.contents = (id)img.CGImage;
	tableCell.backgroundView = backgroundView;
	
	if (style.tableCellTitleTextStyle)	{
		[style.tableCellTitleTextStyle applyToLabel:tableCell.textLabel];
	}
	
	if (style.tableCellDetailTextStyle) {
		[style.tableCellDetailTextStyle applyToLabel:tableCell.detailTextLabel];
	}
}

@end

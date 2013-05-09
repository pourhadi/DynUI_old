//
//  DPStyleRenderer.m
//  TheQ
//
//  Created by Daniel Pourhadi on 4/29/13.
//
//

#import "DPUIRenderer.h"
#import "DPUIDefines.h"
#import "DPUI.h"
@implementation DPUIRenderer
+ (void)renderView:(UIView *)view withStyleNamed:(NSString *)styleName {
    DPUIViewStyle *style = (DPUIViewStyle *)[[DPUIManager sharedInstance] styleForName:styleName];
    
    [style applyStyleToView:view];
}

+ (void)renderNavigationBar:(UINavigationBar *)navigationBar withStyleNamed:(NSString *)styleName {
    DPUIViewStyle *style = (DPUIViewStyle *)[[DPUIManager sharedInstance] styleForName:styleName];
    
    UIImage *img = [style imageForStyleWithSize:navigationBar.frame.size];
    [navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    
    if (style.navBarTitleTextStyle) {
        [navigationBar setTitleTextAttributes:style.navBarTitleTextStyle.titleTextAttributes];
    }
	
	if (style.barButtonItemStyleName) {
		
		DPUIViewStyle *buttonStyle = [[DPUIManager sharedInstance] styleForName:style.barButtonItemStyleName];
		UIImage *buttonImg = [buttonStyle imageForStyleWithSize:CGSizeMake(18, 28) withOuterShadow:YES];
		[[UIBarButtonItem appearanceWhenContainedIn:[navigationBar class], nil] setBackgroundImage:buttonImg.dpui_resizableImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
		UIImage *backImg = [DPUIRenderer backBarButtonImageForStyle:style.barButtonItemStyleName];
		[[UIBarButtonItem appearanceWhenContainedIn:[navigationBar class], nil] setBackButtonBackgroundImage:backImg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	}
	
	if (style.barButtonItemTextStyle) {
		NSDictionary *textAttr = [style.barButtonItemTextStyle titleTextAttributes];
		[[UIBarButtonItem appearanceWhenContainedIn:[navigationBar class], nil] setTitleTextAttributes:textAttr forState:UIControlStateNormal];
	}
}

+ (void)renderTableCell:(UITableViewCell *)tableCell withStyleNamed:(NSString *)styleName {
    DPUIViewStyle *style = (DPUIViewStyle *)[[DPUIManager sharedInstance] styleForName:styleName];
    
    UIImage *img = [style imageForStyleWithSize:tableCell.frame.size];
    UIView *backgroundView = [[UIView alloc] initWithFrame:tableCell.bounds];
    backgroundView.layer.contents = (id)img.CGImage;
    tableCell.backgroundView = backgroundView;
    
    if (style.tableCellTitleTextStyle) {
        [style.tableCellTitleTextStyle applyToLabel:tableCell.textLabel];
    }
    
    if (style.tableCellDetailTextStyle) {
        [style.tableCellDetailTextStyle applyToLabel:tableCell.detailTextLabel];
    }
}

+ (UIImage*)backBarButtonImageForStyle:(NSString*)styleName
{
	DPUIViewStyle *style = (DPUIViewStyle *)[[DPUIManager sharedInstance] styleForName:styleName];

	CGFloat width = 10.5 + 13;
	CGFloat height = 28;

	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointMake(width-style.cornerRadii.width, height)];

	[path addArcWithCenter:CGPointMake([path currentPoint].x, [path currentPoint].y-style.cornerRadii.height) radius:style.cornerRadii.width startAngle:M_PI/2 endAngle:0 clockwise:NO];
	[path addLineToPoint:CGPointMake(width, style.cornerRadii.height)];
	[path addArcWithCenter:CGPointMake([path currentPoint].x-style.cornerRadii.width, style.cornerRadii.height) radius:style.cornerRadii.width startAngle:0 endAngle:degreesToRadians(270) clockwise:NO];
	[path addLineToPoint:CGPointMake(11.5, 0)];
	[path addQuadCurveToPoint:CGPointMake(0, 14) controlPoint:CGPointMake((10.5/2)+3, 2)];
	[path addQuadCurveToPoint:CGPointMake(11.5, height) controlPoint:CGPointMake(((10.5/2)+3), height-2)];
	[path closePath];
	
	
	UIImage *img = [style imageForStyleWithSize:CGSizeMake(CGRectGetWidth(path.bounds)+(CGRectGetWidth(path.bounds)*0.25), CGRectGetHeight(path.bounds)) path:path withOuterShadow:YES].dpui_resizableImage;
		
	return img;
}

@end

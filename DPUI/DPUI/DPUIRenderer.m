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
    if ([view isKindOfClass:[UIButton class]]) {
        [self renderButton:(UIButton*)view withStyleNamed:styleName];
        return;
    } else if ([view isKindOfClass:[UINavigationBar class]]) {
        [self renderNavigationBar:(UINavigationBar*)view withStyleNamed:styleName];
        return;
    } else if ([view isKindOfClass:[UITableViewCell class]]) {
        [self renderTableCell:(UITableViewCell*)view withStyleNamed:styleName];
        return;
    }
    
    DPUIViewStyle *style = (DPUIViewStyle *)[[DPUIManager sharedInstance] styleForName:styleName];
    
    [style applyStyleToView:view];
}

+ (void)renderNavigationBar:(UINavigationBar *)navigationBar withStyleNamed:(NSString *)styleName {
    
    DPUIViewStyle *navStyle = (DPUIViewStyle *)[[DPUIManager sharedInstance] styleForName:styleName];
    
    UIImage *img = [navStyle imageForStyleWithSize:navigationBar.frame.size parameters:navigationBar.styleParameters];
    [navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    
    if (navStyle.navBarTitleTextStyle) {
        [navigationBar setTitleTextAttributes:navStyle.navBarTitleTextStyle.titleTextAttributes];
    }
	
	if (navStyle.barButtonItemStyleName) {
		
		DPUIViewStyle *style = [[DPUIManager sharedInstance] styleForName:navStyle.barButtonItemStyleName];
		UIImage *buttonImg = [style imageForStyleWithSize:CGSizeMake(18, 28) withOuterShadow:YES parameters:navigationBar.styleParameters];
		[[UIBarButtonItem appearanceWhenContainedIn:[navigationBar class], nil] setBackgroundImage:buttonImg.dpui_resizableImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
		UIImage *backImg = [DPUIRenderer backBarButtonImageForStyle:navStyle.barButtonItemStyleName superStyle:nil parameters:navigationBar.styleParameters];
		[[UIBarButtonItem appearanceWhenContainedIn:[navigationBar class], nil] setBackButtonBackgroundImage:backImg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	
	
	if (style.controlStyle) {
		NSDictionary *textAttr;
        
        if (style.controlStyle.normalTextStyle) {
            textAttr = [style.controlStyle.normalTextStyle titleTextAttributes];
            [[UIBarButtonItem appearanceWhenContainedIn:[navigationBar class], nil] setTitleTextAttributes:textAttr forState:UIControlStateNormal];
        }
        
        if (style.controlStyle.highlightedTextStyle) {
            textAttr = [style.controlStyle.highlightedTextStyle titleTextAttributes];
            [[UIBarButtonItem appearanceWhenContainedIn:[navigationBar class], nil] setTitleTextAttributes:textAttr forState:UIControlStateHighlighted];
            
        }
        
        if (style.controlStyle.selectedTextStyle) {
            textAttr = [style.controlStyle.selectedTextStyle titleTextAttributes];
            [[UIBarButtonItem appearanceWhenContainedIn:[navigationBar class], nil] setTitleTextAttributes:textAttr forState:UIControlStateSelected];
        }
        
        if (style.controlStyle.disabledTextStyle) {
            textAttr = [style.controlStyle.disabledTextStyle titleTextAttributes];
            [[UIBarButtonItem appearanceWhenContainedIn:[navigationBar class], nil] setTitleTextAttributes:textAttr forState:UIControlStateDisabled];
        }
        
        if (style.controlStyle.highlightedStyleName) {
            UIImage *buttonImg = [self imageForSize:CGSizeMake(18, 28) controlStyleName:style.controlStyle.highlightedStyleName superStyle:style parameters:navigationBar.styleParameters];

            [[UIBarButtonItem appearanceWhenContainedIn:[navigationBar class], nil] setBackgroundImage:buttonImg.dpui_resizableImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
            UIImage *backImg = [DPUIRenderer backBarButtonImageForStyle:style.controlStyle.highlightedStyleName superStyle:style parameters:navigationBar.styleParameters];
            [[UIBarButtonItem appearanceWhenContainedIn:[navigationBar class], nil] setBackButtonBackgroundImage:backImg forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        }
        
        if (style.controlStyle.selectedStyleName) {
            UIImage *buttonImg = [self imageForSize:CGSizeMake(18, 28) controlStyleName:style.controlStyle.selectedStyleName superStyle:style parameters:navigationBar.styleParameters];

            [[UIBarButtonItem appearanceWhenContainedIn:[navigationBar class], nil] setBackgroundImage:buttonImg.dpui_resizableImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
            UIImage *backImg = [DPUIRenderer backBarButtonImageForStyle:style.controlStyle.selectedStyleName superStyle:style parameters:navigationBar.styleParameters];
            [[UIBarButtonItem appearanceWhenContainedIn:[navigationBar class], nil] setBackButtonBackgroundImage:backImg forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        }
        
        if (style.controlStyle.disabledStyleName) {
            UIImage *buttonImg = [self imageForSize:CGSizeMake(18, 28) controlStyleName:style.controlStyle.disabledStyleName superStyle:style parameters:navigationBar.styleParameters];

            [[UIBarButtonItem appearanceWhenContainedIn:[navigationBar class], nil] setBackgroundImage:buttonImg.dpui_resizableImage forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
            UIImage *backImg = [DPUIRenderer backBarButtonImageForStyle:style.controlStyle.disabledStyleName superStyle:style parameters:navigationBar.styleParameters];
            [[UIBarButtonItem appearanceWhenContainedIn:[navigationBar class], nil] setBackButtonBackgroundImage:backImg forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
        }
        
	}
        }
}

+ (void)renderButton:(UIButton*)button withStyleNamed:(NSString*)styleName
{
    DPUIViewStyle *style = (DPUIViewStyle *)[[DPUIManager sharedInstance] styleForName:styleName];
    UIImage *image = [style imageForStyleWithSize:button.frame.size withOuterShadow:YES parameters:button.styleParameters];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    if (style.controlStyle.normalTextStyle) {
        [style.controlStyle.normalTextStyle applyToButton:button forState:UIControlStateNormal];
    }
    if (style.controlStyle.highlightedTextStyle) {
        [style.controlStyle.highlightedTextStyle applyToButton:button forState:UIControlStateHighlighted];
    }
    if (style.controlStyle.selectedTextStyle) {
        [style.controlStyle.selectedTextStyle applyToButton:button forState:UIControlStateSelected];
    }
    if (style.controlStyle.disabledTextStyle) {
        [style.controlStyle.disabledTextStyle applyToButton:button forState:UIControlStateDisabled];
    }
    
    if (style.controlStyle.highlightedStyleName) {
        UIImage *image = [self imageForSize:button.frame.size controlStyleName:style.controlStyle.highlightedStyleName superStyle:style parameters:button.styleParameters];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    if (style.controlStyle.selectedStyleName) {
        UIImage *image = [self imageForSize:button.frame.size controlStyleName:style.controlStyle.selectedStyleName superStyle:style parameters:button.styleParameters];

        [button setBackgroundImage:image forState:UIControlStateSelected];
    }
    if (style.controlStyle.disabledStyleName) {
        UIImage *image = [self imageForSize:button.frame.size controlStyleName:style.controlStyle.disabledStyleName superStyle:style parameters:button.styleParameters];
        [button setBackgroundImage:image forState:UIControlStateDisabled];
    }
    
}

+ (UIImage*)imageForSize:(CGSize)size controlStyleName:(NSString*)controlStyleName superStyle:(DPUIViewStyle*)style parameters:(DPUIStyleParameters*)parameters
{
    DPUIViewStyle *buttonStyle;
    BOOL flipGrad = NO;
    BOOL halfAlpha = NO;
    BOOL makeLighter = NO;
    BOOL makeDarker = NO;
    if ([controlStyleName isEqualToString:kDPUIFlippedGradientKey]) {
        flipGrad = YES;
        buttonStyle = style;
    } else if ([controlStyleName isEqualToString:kDPUIMakeDarkerKey]) {
        flipGrad = NO;
        halfAlpha = NO;
        makeLighter = NO;
        makeDarker = YES;
        buttonStyle = style;

    } else if ([controlStyleName isEqualToString:kDPUIMakeLigherKey]) {
        flipGrad = NO;
        halfAlpha = NO;
        makeLighter = YES;
        makeDarker = NO;
        buttonStyle = style;

    } else {
        
        if ([controlStyleName isEqualToString:kDPUIHalfOpacityKey]) {
            buttonStyle = style;
            halfAlpha = YES;
        } else {
            buttonStyle = (DPUIViewStyle *)[[DPUIManager sharedInstance] styleForName:controlStyleName];
        }
        
    }
    UIImage *image = [buttonStyle imageForStyleWithSize:size withOuterShadow:YES flippedGradient:flipGrad parameters:parameters];
    
    if (halfAlpha) {
        image = [image imageWithOpacity:0.5];
    }
    
    if (makeDarker) {
        image = [image imageOverlayedWithColor:[UIColor blackColor] opacity:0.3];
    }
    
    if (makeLighter) {
        image = [image imageOverlayedWithColor:[UIColor whiteColor] opacity:0.3];
    }
    
    return image;
}

+ (void)renderTableCell:(UITableViewCell *)tableCell withStyleNamed:(NSString *)styleName {
    DPUIViewStyle *style = (DPUIViewStyle *)[[DPUIManager sharedInstance] styleForName:styleName];
    
    UIImage *img = [style imageForStyleWithSize:tableCell.frame.size parameters:tableCell.styleParameters];
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

+ (UIImage*)backBarButtonImageForStyle:(NSString*)styleName superStyle:(DPUIViewStyle*)style parameters:(DPUIStyleParameters*)parameters
{
    
    DPUIViewStyle *buttonStyle;
    BOOL flipGrad = NO;
    BOOL halfAlpha = NO;
    
    if (style) {
        if ([styleName isEqualToString:kDPUIFlippedGradientKey]) {
            flipGrad = YES;
            buttonStyle = style;
        } else {
            
            if ([styleName isEqualToString:kDPUIHalfOpacityKey]) {
                buttonStyle = style;
                halfAlpha = YES;
            } else {
                buttonStyle = (DPUIViewStyle *)[[DPUIManager sharedInstance] styleForName:styleName];
            }
            
        }
    } else {
        buttonStyle = (DPUIViewStyle *)[[DPUIManager sharedInstance] styleForName:styleName];
    }
    
	CGFloat width = 10.5 + 13;
	CGFloat height = 28;
    
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointMake(width-buttonStyle.cornerRadii.width, height)];
    
	[path addArcWithCenter:CGPointMake([path currentPoint].x, [path currentPoint].y-buttonStyle.cornerRadii.height) radius:buttonStyle.cornerRadii.width startAngle:M_PI/2 endAngle:0 clockwise:NO];
	[path addLineToPoint:CGPointMake(width, buttonStyle.cornerRadii.height)];
	[path addArcWithCenter:CGPointMake([path currentPoint].x-buttonStyle.cornerRadii.width, buttonStyle.cornerRadii.height) radius:buttonStyle.cornerRadii.width startAngle:0 endAngle:degreesToRadians(270) clockwise:NO];
	[path addLineToPoint:CGPointMake(11.5, 0)];
	[path addQuadCurveToPoint:CGPointMake(0, 14) controlPoint:CGPointMake((10.5/2)+3, 2)];
	[path addQuadCurveToPoint:CGPointMake(11.5, height) controlPoint:CGPointMake(((10.5/2)+3), height-2)];
	[path closePath];
	
	
	UIImage *img = [buttonStyle imageForStyleWithSize:CGSizeMake(CGRectGetWidth(path.bounds)+(CGRectGetWidth(path.bounds)*0.25), CGRectGetHeight(path.bounds)) path:path withOuterShadow:YES parameters:parameters].dpui_resizableImage;
    
    if (halfAlpha) {
        img = [img imageWithOpacity:0.5];
    }
    
	return img;
}

@end



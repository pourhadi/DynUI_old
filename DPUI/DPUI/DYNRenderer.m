//
//  DPStyleRenderer.m
//  TheQ
//
//  Created by Daniel Pourhadi on 4/29/13.
//
//

#import "DYNRenderer.h"
#import "DYNDefines.h"
#import "DynUI.h"
#import "UITableViewCell+DynUI.h"
#import <objc/runtime.h>

@implementation DYNRenderer

+ (NSOperationQueue *)drawQueue {
    NSOperationQueue *queue = objc_getAssociatedObject(self, kDYNDrawQueueKey);
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
        queue.name = @"DYNRendererQueue";
        objc_setAssociatedObject(self, kDYNDrawQueueKey, queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return queue;
}

+ (void)applyCustomSettingsFromStyle:(DYNViewStyle*)style toView:(UIView*)view
{
	if (style.customSettings) {
		[style.customSettings makeObjectsPerformSelector:@selector(applyToObject:) withObject:view];
	}
}

+ (void)applyTintFromStyle:(DYNViewStyle*)style toView:(UIView*)view
{
	if (style.useCustomTintColor) {
		if ([view respondsToSelector:@selector(setTintColor:)]) {
            [view performSelector:@selector(setTintColor:) withObject:style.tintColor.color];
			
		}
	}
}

+ (void)renderView:(UIView *)view withStyleNamed:(NSString *)styleName {
	DYNViewStyle *style = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:styleName];

	[self applyCustomSettingsFromStyle:style toView:view];
	[self applyTintFromStyle:style toView:view];
	
    if ([view isKindOfClass:[UIButton class]]) {
        [self renderButton:(UIButton *)view withStyleNamed:styleName];
        return;
    } else if ([view isKindOfClass:[UINavigationBar class]]) {
        [self renderNavigationBar:(UINavigationBar *)view withStyleNamed:styleName];
        return;
    } else if ([view isKindOfClass:[UITableViewCell class]]) {
        [self renderTableCell:(UITableViewCell *)view withStyleNamed:styleName];
        return;
	} else if ([view isKindOfClass:[UICollectionViewCell class]]) {
		[self renderCollectionViewCell:(UICollectionViewCell*)view withStyleNamed:styleName];
		return;
    } else if ([view isKindOfClass:[UIToolbar class]]) {
        [self renderToolbar:(UIToolbar *)view withStyleNamed:styleName];
        return;
    } else if ([view isKindOfClass:[UISearchBar class]]) {
        [self renderSearchBar:(UISearchBar *)view withStyleNamed:styleName];
        return;
    } else if ([view isKindOfClass:[UISlider class]]) {
        [self renderSlider:(UISlider *)view withSliderStyleNamed:styleName];
        return;
    } else if ([view isKindOfClass:[UITextField class]]) {
        [self renderTextField:(UITextField *)view withStyleNamed:styleName];
        return;
    } else if ([view isKindOfClass:[UISegmentedControl class]]) {
       [self renderSegmentedControl:(UISegmentedControl*)view withStyleNamed:styleName];
       return;
       }
    else if ([view isKindOfClass:[UITableView class]]) {
        [self renderTableView:(UITableView *)view withStyleNamed:styleName];
        return;
    }
    
    
    [style applyStyleToView:view];
}

+ (void)renderTableView:(UITableView *)tableView withStyleNamed:(NSString *)styleName {
    if (!tableView.dyn_backgroundView) {
        UIView *bgView = [[UIView alloc] initWithFrame:tableView.frame];
        tableView.backgroundView = bgView;
        tableView.dyn_backgroundView = bgView;
    }
    
    tableView.dyn_backgroundView.dyn_style = styleName;
}


+ (void)renderSegmentedControl:(UISegmentedControl*)segmentedControl withStyleNamed:(NSString*)styleName
{
	DYNViewStyle *style = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:styleName];
	
	UIImage *bgImg = [style imageForStyleWithSize:CGSizeMake(20, segmentedControl.frame.size.height) withOuterShadow:NO parameters:segmentedControl.styleParameters];
	[segmentedControl setBackgroundImage:bgImg.dyn_resizableImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	if (style.segmentedControlStyle) {
		if (style.segmentedControlStyle.normalTextStyle) {

			[segmentedControl setTitleTextAttributes:style.segmentedControlStyle.normalTextStyle.titleTextAttributes forState:UIControlStateNormal];
		}
		
		if (style.segmentedControlStyle.selectedTextStyle) {
			[segmentedControl setTitleTextAttributes:style.segmentedControlStyle.selectedTextStyle.titleTextAttributes forState:UIControlStateSelected];
		}
		
		if (style.segmentedControlStyle.selectedStyleName) {			
			UIImage *bgImg = [self selectedSegmentImageForSize:CGSizeMake(20, segmentedControl.frame.size.height) style:style seletedStyle:style.segmentedControlStyle.selectedStyleName roundCorners:YES];
			[segmentedControl setBackgroundImage:bgImg.dyn_resizableImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
			
			UIImage *leftSelectedRightUnselected = [self leftSelectedRightUnselectedImageForSegmentedControl:segmentedControl style:style selectedStyle:style.segmentedControlStyle.selectedStyleName];
			UIImage *leftUnselectedRightSelected = [self rightSelectedLeftUnselectedImageForSegmentedControl:segmentedControl style:style selectedStyle:style.segmentedControlStyle.selectedStyleName];
			UIImage *bothSelected = [self bothSelectedImageForSegmentedControl:segmentedControl style:style selectedStyle:style.segmentedControlStyle.selectedStyleName];
			UIImage *bothUnselected = [self bothUnselectedImageForSegmentedControl:segmentedControl style:style selectedStyle:style.segmentedControlStyle.selectedStyleName];
			
			[segmentedControl setDividerImage:leftSelectedRightUnselected forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
			[segmentedControl setDividerImage:leftUnselectedRightSelected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
			[segmentedControl setDividerImage:bothSelected forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
			[segmentedControl setDividerImage:bothUnselected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
			
			
		}
	}
	
	
	
}
 
#pragma mark - Segment control renderers

+ (UIImage*)leftSelectedRightUnselectedImageForSegmentedControl:(UISegmentedControl*)segmentedControl style:(DYNViewStyle*)style selectedStyle:(NSString*)selectedStyle
{
	CGFloat dividerWidth = style.segmentDividerWidth;
	UIColor *dividerColor = style.segmentDividerColor.color;
	
	UIImage *selectedImage = [self selectedSegmentImageForSize:CGSizeMake(20, segmentedControl.frame.size.height) style:style seletedStyle:selectedStyle roundCorners:NO];
	selectedImage = [selectedImage imageCroppedToRect:CGRectMake((selectedImage.size.width/2)-1, 0, 2, selectedImage.size.height)];

	UIImage *unselectedImage = [self unselectedSegmentImageForSize:CGSizeMake(20, segmentedControl.frame.size.height) style:style roundCorners:NO];
	unselectedImage = [unselectedImage imageCroppedToRect:CGRectMake((unselectedImage.size.width/2)-1, 0, 2, unselectedImage.size.height)];

	UIImage *image = [UIImage imageWithSize:CGSizeMake((selectedImage.size.width)+dividerWidth+(unselectedImage.size.width), segmentedControl.frame.size.height) drawnWithBlock:^(CGContextRef context, CGRect rect) {
		
		[selectedImage drawAtPoint:CGPointMake(0, 0)];
		[dividerColor setFill];
		UIRectFill(CGRectMake(selectedImage.size.width, 0, dividerWidth, rect.size.height));
		[unselectedImage drawAtPoint:CGPointMake((selectedImage.size.width)+dividerWidth, 0)];
		
	}];
	
	return image;
}

+ (UIImage*)rightSelectedLeftUnselectedImageForSegmentedControl:(UISegmentedControl*)segmentedControl style:(DYNViewStyle*)style selectedStyle:(NSString*)selectedStyle
{
	CGFloat dividerWidth = style.segmentDividerWidth;
	UIColor *dividerColor = style.segmentDividerColor.color;
	
	UIImage *selectedImage = [self selectedSegmentImageForSize:CGSizeMake(20, segmentedControl.frame.size.height) style:style seletedStyle:selectedStyle roundCorners:NO];
	selectedImage = [selectedImage imageCroppedToRect:CGRectMake((selectedImage.size.width/2)-1, 0, 2, selectedImage.size.height)];

	UIImage *unselectedImage = [self unselectedSegmentImageForSize:CGSizeMake(20, segmentedControl.frame.size.height) style:style roundCorners:NO];
	unselectedImage = [unselectedImage imageCroppedToRect:CGRectMake((unselectedImage.size.width/2)-1, 0, 2, unselectedImage.size.height)];

	UIImage *image = [UIImage imageWithSize:CGSizeMake((selectedImage.size.width)+dividerWidth+(unselectedImage.size.width), segmentedControl.frame.size.height) drawnWithBlock:^(CGContextRef context, CGRect rect) {
		
		[unselectedImage drawAtPoint:CGPointMake(0, 0)];
		[dividerColor setFill];
		UIRectFill(CGRectMake(unselectedImage.size.width, 0, dividerWidth, rect.size.height));
		[selectedImage drawAtPoint:CGPointMake((unselectedImage.size.width)+dividerWidth, 0)];
		
	}];
	
	return image;
}

+ (UIImage*)bothUnselectedImageForSegmentedControl:(UISegmentedControl*)segmentedControl style:(DYNViewStyle*)style selectedStyle:(NSString*)selectedStyle
{
	CGFloat dividerWidth = style.segmentDividerWidth;
	UIColor *dividerColor = style.segmentDividerColor.color;
	
	UIImage *unselectedImage = [self unselectedSegmentImageForSize:CGSizeMake(20, segmentedControl.frame.size.height) style:style roundCorners:NO];
	unselectedImage = [unselectedImage imageCroppedToRect:CGRectMake((unselectedImage.size.width/2)-1, 0, 2, unselectedImage.size.height)];

	UIImage *image = [UIImage imageWithSize:CGSizeMake((unselectedImage.size.width)+dividerWidth+(unselectedImage.size.width), segmentedControl.frame.size.height) drawnWithBlock:^(CGContextRef context, CGRect rect) {
		
		[unselectedImage drawAtPoint:CGPointMake(0, 0)];
		[dividerColor setFill];
		UIRectFill(CGRectMake((unselectedImage.size.width), 0, dividerWidth, rect.size.height));
		[unselectedImage drawAtPoint:CGPointMake((unselectedImage.size.width)+dividerWidth, 0)];
		
	}];
	
	return image;
}

+ (UIImage*)bothSelectedImageForSegmentedControl:(UISegmentedControl*)segmentedControl style:(DYNViewStyle*)style selectedStyle:(NSString*)selectedStyle
{
	CGFloat dividerWidth = style.segmentDividerWidth;
	UIColor *dividerColor = style.segmentDividerColor.color;
	
	UIImage *selectedImage = [self selectedSegmentImageForSize:CGSizeMake(20, segmentedControl.frame.size.height) style:style seletedStyle:selectedStyle roundCorners:NO];
	
	selectedImage = [selectedImage imageCroppedToRect:CGRectMake((selectedImage.size.width/2)-1, 0, 2, selectedImage.size.height)];
	UIImage *image = [UIImage imageWithSize:CGSizeMake((selectedImage.size.width)+dividerWidth+(selectedImage.size.width), segmentedControl.frame.size.height) drawnWithBlock:^(CGContextRef context, CGRect rect) {
		
		[selectedImage drawAtPoint:CGPointMake(0, 0)];
		[dividerColor setFill];
		UIRectFill(CGRectMake(selectedImage.size.width, 0, dividerWidth, rect.size.height));
		[selectedImage drawAtPoint:CGPointMake((selectedImage.size.width)+dividerWidth, 0)];
		
	}];
	
	return image;
}


+ (UIImage*)unselectedSegmentImageForSize:(CGSize)size style:(DYNViewStyle*)style roundCorners:(BOOL)roundCorners
{
	CGSize originalRadii = style.cornerRadii;
	CornerRadiusType originalType = style.cornerRadiusType;
	
	if (!roundCorners) {
		style.cornerRadii = CGSizeZero;
		style.cornerRadiusType = CornerRadiusTypeCustom;
	}
	
	UIImage *image = [style imageForStyleWithSize:size withOuterShadow:YES flippedGradient:NO parameters:nil];
	if (!roundCorners) {
		style.cornerRadii = originalRadii;
		style.cornerRadiusType = originalType;
	}

	return image;
}

+ (UIImage*)selectedSegmentImageForSize:(CGSize)size style:(DYNViewStyle*)style seletedStyle:(NSString*)selectedStyle roundCorners:(BOOL)roundCorners
{
	BOOL flipGrad = NO;
    BOOL halfAlpha = NO;
    BOOL makeLighter = NO;
    BOOL makeDarker = NO;
	DYNViewStyle *selectedStyleObject = nil;
	
    if ([selectedStyle isEqualToString:kDYNFlippedGradientKey]) {
        flipGrad = YES;
        selectedStyleObject = style;
    } else if ([selectedStyle isEqualToString:kDYNMakeDarkerKey]) {
        flipGrad = NO;
        halfAlpha = NO;
        makeLighter = NO;
        makeDarker = YES;
        selectedStyleObject = style;
    } else if ([selectedStyle isEqualToString:kDYNMakeLigherKey]) {
        flipGrad = NO;
        halfAlpha = NO;
        makeLighter = YES;
        makeDarker = NO;
        selectedStyleObject = style;
    } else {
        if ([selectedStyle isEqualToString:kDYNHalfOpacityKey]) {
            selectedStyleObject = style;
            halfAlpha = YES;
        } else {
            selectedStyleObject = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:selectedStyle];
        }
    }
	
	CGSize originalRadii = selectedStyleObject.cornerRadii;
	CornerRadiusType originalType = selectedStyleObject.cornerRadiusType;
	
	if (!roundCorners) {
		selectedStyleObject.cornerRadii = CGSizeZero;
		selectedStyleObject.cornerRadiusType = CornerRadiusTypeCustom;
	}
	
    UIImage *image = [selectedStyleObject imageForStyleWithSize:size withOuterShadow:YES flippedGradient:flipGrad parameters:nil];
    
	if (!roundCorners) {
		selectedStyleObject.cornerRadii = originalRadii;
		selectedStyleObject.cornerRadiusType = originalType;
	}
	
	
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

 
+ (void)renderSlider:(UISlider *)slider withSliderStyleNamed:(NSString *)name {
    DYNSliderStyle *style = [[DYNManager sharedInstance] sliderStyleForName:name];
    
    UIImage *min = [style minTrackImageForSlider:slider];
    UIImage *max = [style maxTrackImageForSlider:slider];
    UIImage *thumb = [style thumbImageForSlider:slider];
    
    [slider setMinimumTrackImage:min forState:UIControlStateNormal];
    [slider setMaximumTrackImage:max forState:UIControlStateNormal];
    [slider setThumbImage:thumb forState:UIControlStateNormal];
}

+ (void)renderSearchBar:(UISearchBar *)searchBar withStyleNamed:(NSString *)styleName {
    DYNViewStyle *style = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:styleName];
    
    UIImage *bgImage = [style imageForStyleWithSize:searchBar.frame.size withOuterShadow:NO flippedGradient:NO parameters:searchBar.styleParameters];
    
    [searchBar setBackgroundImage:bgImage forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    if (style.shadow) {
        [style.shadow addShadowToView:searchBar];
    }
    
    // text field
    NSString *searchFieldStyleName = style.searchFieldStyleName;
    DYNViewStyle *fieldStyle;
    if (searchFieldStyleName) {
        [searchBar setSearchFieldBackgroundImage:nil forState:UIControlStateNormal];
        [searchBar setNeedsLayout];
        BOOL flipGrad = NO;
        BOOL halfAlpha = NO;
        BOOL makeLighter = NO;
        BOOL makeDarker = NO;
        
        if ([searchFieldStyleName isEqualToString:kDYNFlippedGradientKey]) {
            flipGrad = YES;
            fieldStyle = style;
        } else if ([searchFieldStyleName isEqualToString:kDYNMakeDarkerKey]) {
            flipGrad = NO;
            halfAlpha = NO;
            makeLighter = NO;
            makeDarker = YES;
            fieldStyle = style;
        } else if ([searchFieldStyleName isEqualToString:kDYNMakeLigherKey]) {
            flipGrad = NO;
            halfAlpha = NO;
            makeLighter = YES;
            makeDarker = NO;
            fieldStyle = style;
        } else {
            if ([searchFieldStyleName isEqualToString:kDYNHalfOpacityKey]) {
                fieldStyle = style;
                halfAlpha = YES;
            } else {
                fieldStyle = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:searchFieldStyleName];
            }
        }
        
        UITextField *textField;
        
        CGFloat textFieldHeight = searchBar.frame.size.height - 13;
        for (UIView *sub in searchBar.subviews) {
            if ([sub isKindOfClass:[UITextField class]]) {
                textField = (UITextField *)sub;
            }
        }
        
        if (style.searchFieldTextStyleName) {
            DYNTextStyle *textStyle = [[DYNManager sharedInstance] textStyleForName:style.searchFieldTextStyleName];
            textField.textColor = textStyle.textColor.color;
            textField.textAlignment = textStyle.alignment;
            textField.font = textStyle.font;
        }
        
        //textFieldHeight = MAX(textFieldHeight, 2);
        UIImage *searchFieldImage = [fieldStyle imageForStyleWithSize:CGSizeMake(textFieldHeight, textFieldHeight) withOuterShadow:YES flippedGradient:flipGrad parameters:searchBar.styleParameters];
        if (halfAlpha) {
            searchFieldImage = [searchFieldImage imageWithOpacity:0.5];
        }
        if (makeDarker) {
            searchFieldImage = [searchFieldImage imageOverlayedWithColor:[UIColor blackColor] opacity:0.3];
        }
        if (makeLighter) {
            searchFieldImage = [searchFieldImage imageOverlayedWithColor:[UIColor whiteColor] opacity:0.3];
        }
        [searchBar setSearchFieldBackgroundImage:searchFieldImage.dyn_resizableImage forState:UIControlStateNormal];
    }
}

+ (void)renderTextField:(UITextField *)textField withStyleNamed:(NSString *)styleName {
    DYNViewStyle *style = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:styleName];
    
    UIImage *image = [style imageForStyleWithSize:textField.frame.size withOuterShadow:YES parameters:textField.styleParameters];
    
    
    textField.borderStyle = UITextBorderStyleNone;
    [textField setBackground:image.dyn_resizableImage];
    
    if (style.textFieldTextStyle) {
        [style.textFieldTextStyle applyToTextField:textField];
    }
    
    if (![UITextField textRectForBoundsSwizzled]) {
        [UITextField swizzleTextRectForBounds];
    }
    
    textField.textInset = 10;
}

+ (void)renderToolbar:(UIToolbar *)toolbar withStyleNamed:(NSString *)styleName {
    DYNViewStyle *style = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:styleName];
    
    UIImage *img = [style imageForStyleWithSize:toolbar.frame.size parameters:toolbar.styleParameters];
    
    [toolbar setBackgroundImage:img forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
}

+ (void)renderBarButtonItemsForNavigationBar:(UINavigationBar*)navigationBar withStyleNamed:(NSString*)styleName {
    DYNViewStyle *style = [[DYNManager sharedInstance] styleForName:styleName];
    UIImage *buttonImg = [style imageForStyleWithSize:CGSizeMake(18, 28) withOuterShadow:YES parameters:navigationBar.styleParameters];
    [[UIBarButtonItem appearanceWhenContainedIn:navigationBar.dyn_metaClass, nil] setBackgroundImage:buttonImg.dyn_resizableImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage *backImg = [DYNRenderer backBarButtonImageForStyle:styleName superStyle:nil parameters:navigationBar.styleParameters];
    [[UIBarButtonItem appearanceWhenContainedIn:navigationBar.dyn_metaClass, nil] setBackButtonBackgroundImage:backImg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    if (style.controlStyle) {
        NSDictionary *textAttr;
        
        if (style.controlStyle.normalTextStyle) {
            textAttr = [style.controlStyle.normalTextStyle titleTextAttributes];
            [[UIBarButtonItem appearanceWhenContainedIn:navigationBar.dyn_metaClass, nil] setTitleTextAttributes:textAttr forState:UIControlStateNormal];
        }
        
        if (style.controlStyle.highlightedTextStyle) {
            textAttr = [style.controlStyle.highlightedTextStyle titleTextAttributes];
            [[UIBarButtonItem appearanceWhenContainedIn:navigationBar.dyn_metaClass, nil] setTitleTextAttributes:textAttr forState:UIControlStateHighlighted];
        }
        
        if (style.controlStyle.selectedTextStyle) {
            textAttr = [style.controlStyle.selectedTextStyle titleTextAttributes];
            
            [[UIBarButtonItem appearanceWhenContainedIn:navigationBar.dyn_metaClass, nil] setTitleTextAttributes:textAttr forState:UIControlStateHighlighted];
        }
        
        if (style.controlStyle.disabledTextStyle) {
            textAttr = [style.controlStyle.disabledTextStyle titleTextAttributes];
            [[UIBarButtonItem appearanceWhenContainedIn:navigationBar.dyn_metaClass, nil] setTitleTextAttributes:textAttr forState:UIControlStateDisabled];
        }
        
        if (style.controlStyle.highlightedStyleName) {
            UIImage *buttonImg = [self imageForSize:CGSizeMake(18, 28) controlStyleName:style.controlStyle.highlightedStyleName superStyle:style parameters:navigationBar.styleParameters];
			[[UIBarButtonItem appearanceWhenContainedIn:navigationBar.dyn_metaClass, nil] setBackgroundImage:buttonImg.dyn_resizableImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
            UIImage *backImg = [DYNRenderer backBarButtonImageForStyle:style.controlStyle.highlightedStyleName superStyle:style parameters:navigationBar.styleParameters];
            [[UIBarButtonItem appearanceWhenContainedIn:navigationBar.dyn_metaClass, nil] setBackButtonBackgroundImage:backImg.dyn_resizableImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        }
        
        if (style.controlStyle.selectedStyleName) {
            UIImage *buttonImg = [self imageForSize:CGSizeMake(18, 28) controlStyleName:style.controlStyle.selectedStyleName superStyle:style parameters:navigationBar.styleParameters];
            
            [[UIBarButtonItem appearanceWhenContainedIn:navigationBar.dyn_metaClass, nil] setBackgroundImage:buttonImg.dyn_resizableImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
            UIImage *backImg = [DYNRenderer backBarButtonImageForStyle:style.controlStyle.selectedStyleName superStyle:style parameters:navigationBar.styleParameters];
            [[UIBarButtonItem appearanceWhenContainedIn:navigationBar.dyn_metaClass, nil] setBackButtonBackgroundImage:backImg.dyn_resizableImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        }
        
        if (style.controlStyle.disabledStyleName) {
            UIImage *buttonImg = [self imageForSize:CGSizeMake(18, 28) controlStyleName:style.controlStyle.disabledStyleName superStyle:style parameters:navigationBar.styleParameters];
            
            [[UIBarButtonItem appearanceWhenContainedIn:navigationBar.dyn_metaClass, nil]  setBackgroundImage:buttonImg.dyn_resizableImage forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
            UIImage *backImg = [DYNRenderer backBarButtonImageForStyle:style.controlStyle.disabledStyleName superStyle:style parameters:navigationBar.styleParameters];
            [[UIBarButtonItem appearanceWhenContainedIn:navigationBar.dyn_metaClass, nil] setBackButtonBackgroundImage:backImg.dyn_resizableImage forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
        }
    }

}

+ (void)renderNavigationBar:(UINavigationBar *)navigationBar withStyleNamed:(NSString *)styleName {
    DYNViewStyle *navStyle = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:styleName];
    
    UIImage *img = [navStyle imageForStyleWithSize:navigationBar.frame.size parameters:navigationBar.styleParameters];
    
    if (navStyle.drawBackground) {
        if ([navigationBar respondsToSelector:@selector(setBackgroundImage:forBarPosition:barMetrics:)]) {
            [navigationBar setBackgroundImage:img.dyn_resizableImage forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        } else {
            [navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
        }
    }
    if (navStyle.navBarTitleTextStyle) {
        [navigationBar setTitleTextAttributes:navStyle.navBarTitleTextStyle.titleTextAttributes];
    }
    
    if (navStyle.shadow) {
        CIColor *color = [CIColor colorWithCGColor:navStyle.shadow.color.color.CGColor];
        if (!(CGSizeEqualToSize(navStyle.shadow.offset, CGSizeZero) && navStyle.shadow.radius == 0) && color.alpha != 0 && navStyle.shadow.opacity != 0) {
            UIImage *shadowImage = [navStyle.shadow getImageForWidth:navigationBar.frame.size.width];
            [navigationBar setShadowImage:shadowImage];
        } else {
            [navigationBar setShadowImage:[UIImage blankOnePointImage].dyn_resizableImage];
        }
    }
    
    if (navStyle.barButtonItemStyleName) {
        
		if (!navigationBar.dyn_metaClass) {
			[navigationBar dyn_createMetaClass];
		}
		
        [self renderBarButtonItemsForNavigationBar:navigationBar withStyleNamed:navStyle.barButtonItemStyleName];
    }
	
	NSArray *leftItems = [navigationBar.topItem.leftBarButtonItems copy];
	NSArray *rightItems = [navigationBar.topItem.rightBarButtonItems copy];
	NSString *title = navigationBar.topItem.title;
	
	navigationBar.topItem.leftBarButtonItems = nil;
	navigationBar.topItem.rightBarButtonItems = nil;
	navigationBar.topItem.title = nil;

	navigationBar.topItem.leftBarButtonItems = leftItems;
	navigationBar.topItem.rightBarButtonItems = rightItems;
	navigationBar.topItem.title = title;
	
	
}

+ (void)renderButton:(UIButton *)button withStyleNamed:(NSString *)styleName {
    DYNViewStyle *style = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:styleName];
    
    if (style.drawAsynchronously) {
        __weak __typeof(& *self) weakSelf = self;
        [[self drawQueue] addOperationWithBlock:^{
            UIImage *image = [style imageForStyleWithSize:button.frame.size withOuterShadow:YES parameters:button.styleParameters];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [weakSelf applyImage:image fromStyle:style toButton:button];
            }];
        }];
    } else {
        UIImage *image = [style imageForStyleWithSize:button.frame.size withOuterShadow:YES parameters:button.styleParameters];
        [self applyImage:image fromStyle:style toButton:button];
    }
}

+ (void)applyImage:(UIImage *)image fromStyle:(DYNViewStyle *)style toButton:(UIButton *)button {
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    
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

+ (UIImage *)imageForSize:(CGSize)size controlStyleName:(NSString *)controlStyleName superStyle:(DYNViewStyle *)style parameters:(DYNStyleParameters *)parameters {
    DYNViewStyle *buttonStyle;
    BOOL flipGrad = NO;
    BOOL halfAlpha = NO;
    BOOL makeLighter = NO;
    BOOL makeDarker = NO;
    if ([controlStyleName isEqualToString:kDYNFlippedGradientKey]) {
        flipGrad = YES;
        buttonStyle = style;
    } else if ([controlStyleName isEqualToString:kDYNMakeDarkerKey]) {
        flipGrad = NO;
        halfAlpha = NO;
        makeLighter = NO;
        makeDarker = YES;
        buttonStyle = style;
    } else if ([controlStyleName isEqualToString:kDYNMakeLigherKey]) {
        flipGrad = NO;
        halfAlpha = NO;
        makeLighter = YES;
        makeDarker = NO;
        buttonStyle = style;
    } else {
        if ([controlStyleName isEqualToString:kDYNHalfOpacityKey]) {
            buttonStyle = style;
            halfAlpha = YES;
        } else {
            buttonStyle = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:controlStyleName];
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

+ (void)renderCollectionViewCell:(UICollectionViewCell*)cell withStyleNamed:(NSString*)styleName
{
	DYNViewStyle *style = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:styleName];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    if (style.drawAsynchronously) {
        __weak __typeof(& *self) weakSelf = self;
        [[self drawQueue] addOperationWithBlock:^{
            UIImage *img = [style imageForStyleWithSize:cell.frame.size withOuterShadow:YES parameters:cell.styleParameters];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [weakSelf applyImage:img fromStyle:style toCollectionViewCell:cell];
            }];
        }];
    } else {
        //UIImage *img = [style imageForStyleWithSize:tableCell.frame.size parameters:tableCell.styleParameters];
        UIImage *img = [style imageForStyleWithSize:cell.frame.size withOuterShadow:YES parameters:cell.styleParameters];
        [self applyImage:img fromStyle:style toCollectionViewCell:cell];
    }
	
	if (style.maskToCorners) {
		CALayer *mask = [style layerMaskForStyleWithSize:cell.frame.size withOuterShadow:YES];
		cell.contentView.layer.mask = mask;
	}

}

+ (void)renderTableCell:(UITableViewCell *)tableCell withStyleNamed:(NSString *)styleName {
    DYNViewStyle *style = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:styleName];
    
    tableCell.backgroundColor = [UIColor clearColor];
    tableCell.contentView.backgroundColor = [UIColor clearColor];
    
    if (style.drawAsynchronously) {
        __weak __typeof(& *self) weakSelf = self;
        [[self drawQueue] addOperationWithBlock:^{
            UIImage *img = [style imageForStyleWithSize:tableCell.frame.size withOuterShadow:NO parameters:tableCell.styleParameters];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [weakSelf applyImage:img fromStyle:style toTableCell:tableCell];
            }];
        }];
    } else {
        //UIImage *img = [style imageForStyleWithSize:tableCell.frame.size parameters:tableCell.styleParameters];
        UIImage *img = [style imageForStyleWithSize:tableCell.frame.size withOuterShadow:NO parameters:tableCell.styleParameters];
        [self applyImage:img fromStyle:style toTableCell:tableCell];
    }
	
	if (style.tableCellSelectedStyleName) {
		DYNViewStyle *selectedCellStyle;
		BOOL flipGrad = NO;
		BOOL halfAlpha = NO;
		BOOL makeLighter = NO;
		BOOL makeDarker = NO;
		if ([style.tableCellSelectedStyleName isEqualToString:kDYNFlippedGradientKey]) {
			flipGrad = YES;
			selectedCellStyle = style;
		} else if ([style.tableCellSelectedStyleName isEqualToString:kDYNMakeDarkerKey]) {
			flipGrad = NO;
			halfAlpha = NO;
			makeLighter = NO;
			makeDarker = YES;
			selectedCellStyle = style;
		} else if ([style.tableCellSelectedStyleName isEqualToString:kDYNMakeLigherKey]) {
			flipGrad = NO;
			halfAlpha = NO;
			makeLighter = YES;
			selectedCellStyle = NO;
			selectedCellStyle = style;
		} else {
			if ([style.tableCellSelectedStyleName isEqualToString:kDYNHalfOpacityKey]) {
				selectedCellStyle = style;
				halfAlpha = YES;
			} else {
				selectedCellStyle = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:style.tableCellSelectedStyleName];
			}
		}
		UIImage *image = [selectedCellStyle imageForStyleWithSize:tableCell.frame.size withOuterShadow:YES flippedGradient:flipGrad parameters:tableCell.styleParameters];
		
		if (halfAlpha) {
			image = [image imageWithOpacity:0.5];
		}
		
		if (makeDarker) {
			image = [image imageOverlayedWithColor:[UIColor blackColor] opacity:0.3];
		}
		
		if (makeLighter) {
			image = [image imageOverlayedWithColor:[UIColor whiteColor] opacity:0.3];
		}
		
		if (!tableCell.dyn_selectedBackgroundView) {
			UIView *bgView = [[UIView alloc] initWithFrame:tableCell.bounds];
			tableCell.dyn_selectedBackgroundView = bgView;
		}
		
		tableCell.dyn_selectedBackgroundView.layer.contents = (id)image.CGImage;
		tableCell.selectedBackgroundView = tableCell.dyn_selectedBackgroundView;

	}
	
}

+ (void)applyImage:(UIImage *)image fromStyle:(DYNViewStyle *)style toTableCell:(UITableViewCell *)tableCell {
    if (!tableCell.dyn_backgroundView) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:tableCell.bounds];
        tableCell.backgroundView = backgroundView;
        tableCell.dyn_backgroundView = backgroundView;
    }
    
    tableCell.dyn_backgroundView.layer.contents = (id)image.CGImage;
    
    
    if (style.tableCellTitleTextStyle) {
        [style.tableCellTitleTextStyle applyToLabel:tableCell.textLabel];
    }
    
    if (style.tableCellDetailTextStyle) {
        [style.tableCellDetailTextStyle applyToLabel:tableCell.detailTextLabel];
    }
	
	
}

+ (void)applyImage:(UIImage*)image fromStyle:(DYNViewStyle*)style toCollectionViewCell:(UICollectionViewCell*)cell
{
	if (!cell.dyn_backgroundView) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView = backgroundView;
        cell.dyn_backgroundView = backgroundView;
    }
    
    cell.dyn_backgroundView.layer.contents = (id)image.CGImage;
}

+ (UIImage *)backBarButtonImageForStyle:(NSString *)styleName superStyle:(DYNViewStyle *)style parameters:(DYNStyleParameters *)parameters {
    DYNViewStyle *buttonStyle;
    BOOL flipGrad = NO;
    BOOL halfAlpha = NO;
    BOOL makeDarker = NO;
    BOOL makeLighter = NO;
    NSString *controlStyleName = styleName;
    
    if (style) {
        if ([controlStyleName isEqualToString:kDYNFlippedGradientKey]) {
            flipGrad = YES;
            buttonStyle = style;
        } else if ([controlStyleName isEqualToString:kDYNMakeDarkerKey]) {
            flipGrad = NO;
            halfAlpha = NO;
            makeLighter = NO;
            makeDarker = YES;
            buttonStyle = style;
        } else if ([controlStyleName isEqualToString:kDYNMakeLigherKey]) {
            flipGrad = NO;
            halfAlpha = NO;
            makeLighter = YES;
            makeDarker = NO;
            buttonStyle = style;
        } else {
            if ([controlStyleName isEqualToString:kDYNHalfOpacityKey]) {
                buttonStyle = style;
                halfAlpha = YES;
            } else {
                buttonStyle = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:controlStyleName];
            }
        }
    } else {
        buttonStyle = (DYNViewStyle *)[[DYNManager sharedInstance] styleForName:styleName];
    }
    
    CGFloat width = 10.5 + 13;
    CGFloat height = 28;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width - buttonStyle.cornerRadii.width, height)];
    
    [path addArcWithCenter:CGPointMake([path currentPoint].x, [path currentPoint].y - buttonStyle.cornerRadii.height) radius:buttonStyle.cornerRadii.width startAngle:M_PI / 2 endAngle:0 clockwise:NO];
    [path addLineToPoint:CGPointMake(width, buttonStyle.cornerRadii.height)];
    [path addArcWithCenter:CGPointMake([path currentPoint].x - buttonStyle.cornerRadii.width, buttonStyle.cornerRadii.height) radius:buttonStyle.cornerRadii.width startAngle:0 endAngle:degreesToRadians(270) clockwise:NO];
    [path addLineToPoint:CGPointMake(11.5, 0)];
    [path addQuadCurveToPoint:CGPointMake(0, 14) controlPoint:CGPointMake((10.5 / 2) + 3, 2)];
    [path addQuadCurveToPoint:CGPointMake(11.5, height) controlPoint:CGPointMake(((10.5 / 2) + 3), height - 2)];
    [path closePath];
    
    UIImage *img = [buttonStyle imageForStyleWithSize:CGSizeMake(CGRectGetWidth(path.bounds) + (CGRectGetWidth(path.bounds) * 0.25), CGRectGetHeight(path.bounds)) path:path withOuterShadow:YES flippedGradient:flipGrad parameters:parameters].dyn_resizableImage;

    if (halfAlpha) {
        img = [img imageWithOpacity:0.5];
    }
    if (makeDarker) {
        img = [img imageOverlayedWithColor:[UIColor blackColor] opacity:0.3];
    }
    
    if (makeLighter) {
        img = [img imageOverlayedWithColor:[UIColor whiteColor] opacity:0.3];
    }
    return img;
}

@end

//
//  UIScrollView+DynUI.h
//  DynUI-Example
//
//  Created by Daniel Pourhadi on 5/15/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (DynUI)

@property (nonatomic, strong) UIView *dyn_containerView;

- (void)dyn_embedInContainerViewWithStyle:(NSString*)styleName;

@end

//
//  UINavigationBar+DynUI.h
//  Echo POS Mobile
//
//  Created by Daniel Pourhadi on 5/29/13.
//  Copyright (c) 2013 Echo Daily. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UINavigationBar (DynUI)

/** Applies the style specified by styleName to all the UIBarButtonItems associated with this navigation bar. */
//- (void)applyStyleToBarButtonItems:(NSString*)styleName;

@property (nonatomic, strong) Class dyn_metaClass;
- (void)dyn_createMetaClass;

- (void)setEffectBackgroundColor:(UIColor*)color;
- (void)setBorderColor:(UIColor*)color;
@end

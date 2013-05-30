//
//  UINavigationBar+DynUI.m
//  Echo POS Mobile
//
//  Created by Daniel Pourhadi on 5/29/13.
//  Copyright (c) 2013 Echo Daily. All rights reserved.
//

#import "UINavigationBar+DynUI.h"
#import "DynUI.h"
#import "DYNDefines.h"
#import <objc/runtime.h>
@implementation UINavigationBar (DynUI)

GET_AND_SET_ASSOCIATED_OBJ(dyn_metaClass, nil);
GET_AND_SET_CLASS_OBJ(dyn_navBarClasses, nil);

- (void)setDyn_metaClass:(Class)class
{
	[self set_dyn_metaClass:class];
}

+ (NSMutableDictionary*)dyn_getNavBarClasses
{
	if (![self dyn_navBarClasses]) {
		[self set_dyn_navBarClasses:[NSDictionary dictionary]];
	}
	
	return [[self dyn_navBarClasses] mutableCopy];
}

- (void)dyn_createMetaClass
{
	NSMutableDictionary *metaClasses = [UINavigationBar dyn_getNavBarClasses];
	if ([metaClasses objectForKey:self.dyn_style]) {
		Class newClass = [metaClasses objectForKey:self.dyn_style];
		[self setDyn_metaClass:newClass];
		object_setClass(self, newClass);
		return;
	}
	
	Class newClass = objc_allocateClassPair([self class], self.dyn_style.UTF8String, 0);
	objc_registerClassPair(newClass);
	
	[self setDyn_metaClass:newClass];
	
	[metaClasses setObject:newClass forKey:self.dyn_style];
	
	[UINavigationBar set_dyn_navBarClasses:metaClasses];
	
	object_setClass(self, newClass);
}


/*

- (void)applyStyleToBarButtonItems:(NSString*)styleName
{
	NSLog(@"apply to bar button items");
    [self set_barButtonItemStyleName:styleName];
    
    for (UIBarButtonItem *item in self.topItem.leftBarButtonItems) {
        [DYNRenderer renderBarButtonItem:item forNavigationBar:self withStyleNamed:styleName];
    }
    
    for (UIBarButtonItem *item in self.topItem.rightBarButtonItems) {
        [DYNRenderer renderBarButtonItem:item forNavigationBar:self withStyleNamed:styleName];
    }
    
	[DYNRenderer renderBarButtonItem:self.topItem.backBarButtonItem forNavigationBar:self withStyleNamed:[self barButtonItemStyleName]];

	
    [self addObserversForBarButtonItems];
//	
//	if (![[UINavigationBar pushNavigationItemSwizzled] boolValue]) {
//		
//		[UINavigationBar jr_swizzleMethod:@selector(pushNavigationItem:animated:) withMethod:@selector(dyn_pushNavigationItem:animated:) error:nil];
//		[UINavigationBar set_pushNavigationItemSwizzled:@(YES)];
//		
//	}
}

- (void)dyn_pushNavigationItem:(UINavigationItem*)navItem animated:(BOOL)animated
{
	if ([self barButtonItemStyleName]) {
		for (UIBarButtonItem *item in navItem.leftBarButtonItems) {
			[DYNRenderer renderBarButtonItem:item forNavigationBar:self withStyleNamed:[self barButtonItemStyleName]];
		}
		
		for (UIBarButtonItem *item in navItem.rightBarButtonItems) {
			[DYNRenderer renderBarButtonItem:item forNavigationBar:self withStyleNamed:[self barButtonItemStyleName]];
		}
		
		[DYNRenderer renderBarButtonItem:navItem.backBarButtonItem forNavigationBar:self withStyleNamed:[self barButtonItemStyleName]];
	}
	[self dyn_pushNavigationItem:navItem animated:animated];
}

- (void)addObserversForBarButtonItems
{
    [self removeObserversForBarButtonItems];
    [self addObserver:self forKeyPath:@"items" options:0 context:nil];
    [self addObserver:self forKeyPath:@"topItem.leftBarButtonItems" options:0 context:nil];
    [self addObserver:self forKeyPath:@"topItem.rightBarButtonItems" options:0 context:nil];
    [self set_styleObservationArray:@[@"items",@"topItem.leftBarButtonItems", @"topItem.rightBarButtonItems"]];
}

- (void)removeObserversForBarButtonItems
{
    if ([self styleObservationArray]){
        NSArray *obsArray = [self styleObservationArray];
        for (NSString *keypath in obsArray) {
            [self removeObserver:self forKeyPath:keypath];
        }
    }
    
    [self set_styleObservationArray:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"topItem.leftBarButtonItems"]) {
        
        for (UIBarButtonItem *item in self.topItem.leftBarButtonItems) {
            [DYNRenderer renderBarButtonItem:item forNavigationBar:self withStyleNamed:[self barButtonItemStyleName]];
        }
        
    } else if ([keyPath isEqualToString:@"topItem.rightBarButtonItems"]) {
        
        for (UIBarButtonItem *item in self.topItem.rightBarButtonItems) {
            [DYNRenderer renderBarButtonItem:item forNavigationBar:self withStyleNamed:[self barButtonItemStyleName]];
        }
        
    } else if ([keyPath isEqualToString:@"items"]) {
        
        for (UINavigationItem *navItem in self.items) {
            for (UIBarButtonItem *item in self.topItem.leftBarButtonItems) {
                [DYNRenderer renderBarButtonItem:item forNavigationBar:self withStyleNamed:[self barButtonItemStyleName]];
            }
            
            for (UIBarButtonItem *item in self.topItem.rightBarButtonItems) {
                [DYNRenderer renderBarButtonItem:item forNavigationBar:self withStyleNamed:[self barButtonItemStyleName]];
            }
            
            [DYNRenderer renderBarButtonItem:navItem.backBarButtonItem forNavigationBar:self withStyleNamed:[self barButtonItemStyleName]];
            
        }
    }
}

GET_AND_SET_CLASS_OBJ(pushNavigationItemSwizzled, @(NO));
GET_AND_SET_ASSOCIATED_OBJ(barButtonItemStyleName, nil);
GET_AND_SET_ASSOCIATED_OBJ(styleObservationArray, nil);
*/
@end

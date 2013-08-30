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
	
	return [NSMutableDictionary dictionaryWithDictionary:[self dyn_navBarClasses]];
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

@end

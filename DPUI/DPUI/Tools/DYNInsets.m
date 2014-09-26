//
//  DYNInsets.m
//  DynUI-Example
//
//  Created by Dan Pourhadi on 6/13/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "DYNInsets.h"

@implementation DYNInsets

- (id)init
{
	self = [super init];
	if (self) {
		self.top = @(0);
		self.bottom = @(0);
		self.left = @(0);
		self.right = @(0);
	}
	return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
	self = [self init];
	if (self) {
		
		self.top = [dictionary objectForKey:@"top"];
		self.bottom = [dictionary objectForKey:@"bottom"];
		self.left = [dictionary objectForKey:@"left"];
		self.right = [dictionary objectForKey:@"right"];
		
	}
	return self;
}

- (UIEdgeInsets)edgeInsets
{
	return UIEdgeInsetsMake(self.top.floatValue, self.left.floatValue, self.bottom.floatValue, self.right.floatValue);
}

- (BOOL)anySideGreaterThanZero
{
	if (self.edgeInsets.top > 0 ||
		self.edgeInsets.bottom > 0 ||
		self.edgeInsets.left > 0 ||
		self.edgeInsets.right > 0) {
		return YES;
	}
	return NO;
}

@end

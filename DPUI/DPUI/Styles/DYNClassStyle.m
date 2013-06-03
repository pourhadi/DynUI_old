//
//  DYNClassStyle.m
//  DynUI-Example
//
//  Created by Dan Pourhadi on 6/2/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "DYNClassStyle.h"
#import "DynUI.h"
@implementation DYNClassStyle

- (id)initWithDictionary:(NSDictionary*)dictionary
{
	self = [super init];
	if (self) {
		
		self.autoStyle = [[dictionary objectForKey:@"autoApply"] boolValue];
		
		NSMutableArray *tmp = [NSMutableArray new];
		for (NSDictionary *attr in [dictionary objectForKey:@"attributes"]) {
			[tmp addObject:[[DYNCustomSetting alloc] initWithDictionary:attr]];
		}
		
	}
	return self;
}

@end

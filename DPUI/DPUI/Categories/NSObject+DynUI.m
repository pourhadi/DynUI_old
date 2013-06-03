//
//  NSObject+DynUI.m
//  DynUI-Example
//
//  Created by Dan Pourhadi on 6/2/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "NSObject+DynUI.h"
#import "DYNDefines.h"
@implementation NSObject (DynUI)


- (void)setDyn_classStyle:(NSString *)dyn_classStyle
{
	[self set_dyn_classStyle:dyn_classStyle];
}

GET_AND_SET_ASSOCIATED_OBJ(dyn_classStyle, nil);

@end

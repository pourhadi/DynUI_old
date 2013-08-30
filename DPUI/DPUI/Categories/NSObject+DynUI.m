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


- (void)dyn_setAutoUpdateBlock:(DYNAutoUpdateBlock)block
{
    [[DYNManager sharedInstance] attachAutoUpdateBlockToObject:self block:block];
}

- (void)dyn_removeAutoUpdateBlock
{
    [[DYNManager sharedInstance] removeAutoUpdateBlockFromObject:self];
}

@end

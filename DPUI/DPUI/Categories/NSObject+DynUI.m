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

GET_AND_SET_ASSOCIATED_OBJ(autoUpdateBlock_, nil);
GET_AND_SET_ASSOCIATED_OBJ(autoUpdateBlockHolder_, nil);


- (void)dyn_setAutoUpdateBlock:(DYNAutoUpdateBlockWithObject)block
{
    [self set_autoUpdateBlock_:block];
    [[DYNManager sharedInstance] attachAutoUpdateBlockToObject:self block:block];
}

- (void)dyn_removeAutoUpdateBlock
{
    [self set_autoUpdateBlock_:nil];
    [[DYNManager sharedInstance] removeAutoUpdateBlockFromObject:self];
}

- (DYNAutoUpdateBlockWithObject)dyn_updateBlock
{
    return [self autoUpdateBlock_];
}

- (DYNAutoUpdateBlockWithObject)dyn_tempUpdateBlockHolder
{
    return [self autoUpdateBlockHolder_];
}

- (void)dyn_setTempUpdateBlockHolder:(DYNAutoUpdateBlockWithObject)block
{
    [self set_autoUpdateBlockHolder_:block];
}

- (void)dyn_updateAppearance
{
    if ([self dyn_updateBlock]) {
        [self dyn_updateBlock](self);
        [self set_autoUpdateBlockHolder_:[self dyn_updateBlock]];
        [self set_autoUpdateBlock_:nil];
    }
}

- (void)dyn_resetAutoUpdateBlock
{
    if ([self autoUpdateBlockHolder_]) {
        [self set_autoUpdateBlock_:[self autoUpdateBlockHolder_]];
        [self set_autoUpdateBlockHolder_:nil];
    }
}

@end

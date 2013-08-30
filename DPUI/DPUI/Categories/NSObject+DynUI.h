//
//  NSObject+DynUI.h
//  DynUI-Example
//
//  Created by Dan Pourhadi on 6/2/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DynUI)

- (void)dyn_setAutoUpdateBlock:(DYNAutoUpdateBlock)block;
- (void)dyn_removeAutoUpdateBlock;

@end

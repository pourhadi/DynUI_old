//
//  DYNPassThroughView.m
//  DynUI-Example
//
//  Created by Daniel Pourhadi on 5/21/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "DYNPassThroughView.h"

@implementation DYNPassThroughView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return NO;
}

@end

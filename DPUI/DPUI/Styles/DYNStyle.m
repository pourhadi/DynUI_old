//
//  DPStyle.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DYNStyle.h"
#import "DYNDefines.h"
#import "DynUI.h"
@implementation DYNStyle

- (BOOL)isEqual:(id)object {
    return ([self.name isEqualToString:[object name]]);
}

- (id)copyWithZone:(NSZone *)zone {
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setName:[self.name copy]];
    [theCopy setParameters:[self.parameters copy]];
    
    return theCopy;
}

@end

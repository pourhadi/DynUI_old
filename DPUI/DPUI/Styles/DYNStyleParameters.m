//
//  DYNStyleParameters.m
//  DYN
//
//  Created by Daniel Pourhadi on 5/10/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DYNStyleParameters.h"
#import "DynUI.h"
@implementation DYNStyleParameters

- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    
    return _parameters;
}

- (void)setValue:(id)value forStyleParameter:(NSString *)parameterName {
    [self.parameters setObject:value forKey:parameterName];
}

- (id)valueForStyleParameter:(NSString *)parameterName {
    id value = [self.parameters objectForKey:parameterName];
    
    return value;
}

@end
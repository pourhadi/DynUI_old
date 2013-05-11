//
//  DPUIStyleParameters.h
//  DPUI
//
//  Created by Daniel Pourhadi on 5/10/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DPUIStyleParameters : NSObject

@property (nonatomic, strong) NSMutableDictionary *parameters;

- (id)valueForStyleParameter:(NSString *)parameterName;
- (void)setValue:(id)value forStyleParameter:(NSString *)parameterName;


@end

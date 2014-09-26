//
//  DYNStyleParameters.h
//  DYN
//
//  Created by Daniel Pourhadi on 5/10/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DYNStyleParameters : NSObject <NSCopying>

@property (nonatomic, strong) NSMutableDictionary *parameters;

- (id)valueForStyleParameter:(NSString *)parameterName;
- (void)setValue:(id)value forStyleParameter:(NSString *)parameterName;


@end

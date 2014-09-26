//
//  DYNInsets.h
//  DynUI-Example
//
//  Created by Dan Pourhadi on 6/13/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DYNInsets : NSObject

@property (nonatomic, strong) NSNumber *top;
@property (nonatomic, strong) NSNumber *bottom;
@property (nonatomic, strong) NSNumber *left;
@property (nonatomic, strong) NSNumber *right;

- (id)initWithDictionary:(NSDictionary*)dictionary;

- (UIEdgeInsets)edgeInsets;

- (BOOL)anySideGreaterThanZero;

@end

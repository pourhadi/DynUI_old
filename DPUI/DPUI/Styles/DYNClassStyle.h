//
//  DYNClassStyle.h
//  DynUI-Example
//
//  Created by Dan Pourhadi on 6/2/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "DYNStyle.h"

@interface DYNClassStyle : DYNStyle

@property (nonatomic, strong) NSArray *settings;
@property (nonatomic, strong) NSString *className;
@property (nonatomic) BOOL autoStyle;

- (id)initWithDictionary:(NSDictionary*)dictionary;
@end

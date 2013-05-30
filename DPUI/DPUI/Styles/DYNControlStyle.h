//
//  DYNControlStyle.h
//  DYN
//
//  Created by Daniel Pourhadi on 5/9/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DYNStyle.h"
@class DYNTextStyle;
@interface DYNControlStyle : DYNStyle
@property (nonatomic, strong) DYNTextStyle *normalTextStyle;

@property (nonatomic, strong) NSString *highlightedStyleName;
@property (nonatomic, strong) DYNTextStyle *highlightedTextStyle;

@property (nonatomic, strong) NSString *selectedStyleName;
@property (nonatomic, strong) DYNTextStyle *selectedTextStyle;

@property (nonatomic, strong) NSString *disabledStyleName;
@property (nonatomic, strong) DYNTextStyle *disabledTextStyle;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end

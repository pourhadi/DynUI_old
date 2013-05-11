//
//  DPUIControlStyle.h
//  DPUI
//
//  Created by Daniel Pourhadi on 5/9/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DPUIStyle.h"
@class DPUITextStyle;
@interface DPUIControlStyle : DPUIStyle
@property (nonatomic, strong) DPUITextStyle *normalTextStyle;

@property (nonatomic, strong) NSString *highlightedStyleName;
@property (nonatomic, strong) DPUITextStyle *highlightedTextStyle;

@property (nonatomic, strong) NSString *selectedStyleName;
@property (nonatomic, strong) DPUITextStyle *selectedTextStyle;

@property (nonatomic, strong) NSString *disabledStyleName;
@property (nonatomic, strong) DPUITextStyle *disabledTextStyle;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end

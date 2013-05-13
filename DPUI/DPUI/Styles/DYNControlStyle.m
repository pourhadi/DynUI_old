//
//  DYNControlStyle.m
//  DYN
//
//  Created by Daniel Pourhadi on 5/9/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DYNControlStyle.h"
#import "DYNDefines.h"
#import "DynUI.h"
@implementation DYNControlStyle

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if ([dictionary objectForKey:kDYNNormalTextStyle]) {
            self.normalTextStyle = [[DYNManager sharedInstance] textStyleForName:[dictionary objectForKey:kDYNNormalTextStyle]];
        }
        if ([dictionary objectForKey:kDYNHighlightedTextStyle]) {
            self.highlightedTextStyle = [[DYNManager sharedInstance] textStyleForName:[dictionary objectForKey:kDYNHighlightedTextStyle]];
        }
        if ([dictionary objectForKey:kDYNSelectedTextStyle]) {
            self.selectedTextStyle = [[DYNManager sharedInstance] textStyleForName:[dictionary objectForKey:kDYNSelectedTextStyle]];
        }
        if ([dictionary objectForKey:kDYNDisabledTextStyle]) {
            self.disabledTextStyle = [[DYNManager sharedInstance] textStyleForName:[dictionary objectForKey:kDYNDisabledTextStyle]];
        }
        
        if ([dictionary objectForKey:kDYNHighlightedStyleName]) {
            self.highlightedStyleName = [dictionary objectForKey:kDYNHighlightedStyleName];
        }
        if ([dictionary objectForKey:kDYNSelectedStyleName]) {
            self.selectedStyleName = [dictionary objectForKey:kDYNSelectedStyleName];
        }
        if ([dictionary objectForKey:kDYNDisabledStyleName]) {
            self.disabledStyleName = [dictionary objectForKey:kDYNDisabledStyleName];
        }
    }
    return self;
}

@end

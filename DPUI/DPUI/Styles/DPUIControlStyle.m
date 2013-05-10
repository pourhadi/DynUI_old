//
//  DPUIControlStyle.m
//  DPUI
//
//  Created by Daniel Pourhadi on 5/9/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DPUIControlStyle.h"
#import "DPUIDefines.h"
#import "DPUI.h"
@implementation DPUIControlStyle

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary objectForKey:kDPUINormalTextStyle]) {
            self.normalTextStyle = [[DPUIManager sharedInstance] textStyleForName:[dictionary objectForKey:kDPUINormalTextStyle]];
        }
        if ([dictionary objectForKey:kDPUIHighlightedTextStyle]) {
            self.highlightedTextStyle = [[DPUIManager sharedInstance] textStyleForName:[dictionary objectForKey:kDPUIHighlightedTextStyle]];
        }
        if ([dictionary objectForKey:kDPUISelectedTextStyle]) {
            self.selectedTextStyle = [[DPUIManager sharedInstance] textStyleForName:[dictionary objectForKey:kDPUISelectedTextStyle]];
        }
        if ([dictionary objectForKey:kDPUIDisabledTextStyle]) {
            self.disabledTextStyle = [[DPUIManager sharedInstance] textStyleForName:[dictionary objectForKey:kDPUIDisabledTextStyle]];
        }
        
        if ([dictionary objectForKey:kDPUIHighlightedStyleName]) {
            self.highlightedStyleName = [dictionary objectForKey:kDPUIHighlightedStyleName];
        }
        if ([dictionary objectForKey:kDPUISelectedStyleName]) {
            self.selectedStyleName = [dictionary objectForKey:kDPUISelectedStyleName];
        }
        if ([dictionary objectForKey:kDPUIDisabledStyleName]) {
            self.disabledStyleName = [dictionary objectForKey:kDPUIDisabledStyleName];
        }
        
    }
    return self;
}

@end

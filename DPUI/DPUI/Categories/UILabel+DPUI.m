//
//  UILabel+DPUI.m
//  TheQ
//
//  Created by Dan Pourhadi on 5/5/13.
//
//

#import "UILabel+DPUI.h"
#import <objc/runtime.h>
#import "DPUIDefines.h"
#import "DPUI.h"
@implementation UILabel (DPUI)

- (void)setDpui_textStyle:(NSString *)dpuiTextStyle {
    DPUITextStyle *textStyle = [[DPUIManager sharedInstance] textStyleForName:dpuiTextStyle];
    [textStyle applyToLabel:self];
    
    [[DPUIManager sharedInstance] registerView:self];
}

- (NSString *)dpui_textStyle {
    return objc_getAssociatedObject(self, kDPTextStyleKey);
}

- (void)dpui_refreshStyle {
    if (self.dpui_textStyle) {
        [self setDpui_textStyle:self.dpui_textStyle];
    }
}

@end

//
//  UILabel+DYN.m
//  TheQ
//
//  Created by Dan Pourhadi on 5/5/13.
//
//

#import "UILabel+DynUI.h"
#import <objc/runtime.h>
#import "DYNDefines.h"
#import "DynUI.h"
@implementation UILabel (DynUI)

- (void)setDyn_textStyle:(NSString *)style {
    DYNTextStyle *textStyle = [[DYNManager sharedInstance] textStyleForName:style];
    [textStyle applyToLabel:self];
    
    [[DYNManager sharedInstance] registerView:self];
}

- (NSString *)dyn_textStyle {
    return objc_getAssociatedObject(self, kDPTextStyleKey);
}

- (void)dyn_refreshStyle {
    if (self.dyn_textStyle) {
        [self setDyn_textStyle:self.dyn_textStyle];
    }
}

@end

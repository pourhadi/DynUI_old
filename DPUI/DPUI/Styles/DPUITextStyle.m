//
//  DPUITextStyle.m
//  TheQ
//
//  Created by Dan Pourhadi on 5/4/13.
//
//

#import "DPUITextStyle.h"
#import "DPUIDefines.h"
#import <objc/runtime.h>
#import "DPUI.h"
@implementation DPUITextStyle
- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.name = [dict objectForKey:kDPUIStyleNameKey];
        self.font = [UIFont fontWithName:[dict objectForKey:kDPUIFontNameKey] size:[[dict objectForKey:kDPUIFontSizeKey] floatValue]];
        self.textColor = [[DPUIColor alloc] initWithDictionary:[dict objectForKey:kDPUITextColorKey]];
        self.shadowColor = [[DPUIColor alloc] initWithDictionary:[dict objectForKey:kDPUIShadowColorKey]];
        self.shadowOffset = CGSizeMake([[dict objectForKey:kDPUIShadowXOffsetKey] floatValue], [[dict objectForKey:kDPUIShadowYOffsetKey] floatValue]);
        self.alignment = [[dict objectForKey:kDPUIAlignmentKey] intValue];
    }
    
    return self;
}

- (void)applyToLabel:(UILabel *)label {
    objc_setAssociatedObject(label, kDPTextStyleKey, self.name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = self.textColor.color;
    label.font = self.font;
    label.shadowColor = self.shadowColor.color;
    label.shadowOffset = self.shadowOffset;
    label.textAlignment = self.alignment;
}

- (NSDictionary *)titleTextAttributes {
    return @{ UITextAttributeFont: self.font,
              UITextAttributeTextColor: self.textColor.color,
              UITextAttributeTextShadowColor: self.shadowColor.color,
              UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:self.shadowOffset] };
}

@end

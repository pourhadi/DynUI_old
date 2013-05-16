//
//  DYNTextStyle.m
//  TheQ
//
//  Created by Dan Pourhadi on 5/4/13.
//
//

#import "DYNTextStyle.h"
#import "DYNDefines.h"
#import <objc/runtime.h>
#import "DynUI.h"
@implementation DYNTextStyle
- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.name = [dict objectForKey:kDYNStyleNameKey];
        self.font = [UIFont fontWithName:[dict objectForKey:kDYNFontNameKey] size:[[dict objectForKey:kDYNFontSizeKey] floatValue]];
        self.textColor = [[DYNColor alloc] initWithDictionary:[dict objectForKey:kDYNTextColorKey]];
        self.shadowColor = [[DYNColor alloc] initWithDictionary:[dict objectForKey:kDYNShadowColorKey]];
        self.shadowOffset = CGSizeMake([[dict objectForKey:kDYNShadowXOffsetKey] floatValue], oppositeSign([[dict objectForKey:kDYNShadowYOffsetKey] floatValue]));
        self.alignment = [[dict objectForKey:kDYNAlignmentKey] intValue];
		self.fontSizeString = [dict objectForKey:kDYNFontSizeStringKey];
		self.fontSizeType = [[dict objectForKey:kDYNFontSizeTypeKey] intValue];
    }
	
    return self;
}

- (void)applyToLabel:(UILabel *)label {
    objc_setAssociatedObject(label, kDPTextStyleKey, self.name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = self.textColor.color;
	
	CGFloat fontSize = self.font.pointSize;
	if (self.fontSizeType == DYNFontSizeTypeRelative) {
		if (self.fontSizeString) {
			if ([self.fontSizeString hasSuffix:@"%"]) {
				NSRange range = [self.fontSizeString rangeOfString:@"%"];
				NSString *chopped = [self.fontSizeString substringToIndex:range.location];
				CGFloat percent = [chopped floatValue];
				percent /= 100;
				fontSize = label.frame.size.height * percent;
			}
		}
	}
	
    label.font = [UIFont fontWithName:self.font.fontName size:fontSize];
    label.shadowColor = self.shadowColor.color;
    label.shadowOffset = self.shadowOffset;
    label.textAlignment = self.alignment;
}

- (void)applyToTextField:(UITextField*)textField
{
    CGFloat fontSize = self.font.pointSize;
	if (self.fontSizeType == DYNFontSizeTypeRelative) {
		if (self.fontSizeString) {
			if ([self.fontSizeString hasSuffix:@"%"]) {
				NSRange range = [self.fontSizeString rangeOfString:@"%"];
				NSString *chopped = [self.fontSizeString substringToIndex:range.location];
				CGFloat percent = [chopped floatValue];
				percent /= 100;
				fontSize = textField.frame.size.height * percent;
			}
		}
	}

    textField.font = [UIFont fontWithName:self.font.fontName size:fontSize];
    textField.textColor = self.textColor.color;
    textField.textAlignment = self.alignment;
}

- (NSDictionary *)titleTextAttributes {
    return @{ UITextAttributeFont: self.font,
              UITextAttributeTextColor: self.textColor.color,
              UITextAttributeTextShadowColor: self.shadowColor.color,
              UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:self.shadowOffset] };
}

- (void)applyToButton:(UIButton *)button forState:(UIControlState)controlState {
    [button setTitleColor:self.textColor.color forState:controlState];
	
	CGFloat fontSize = floorf(self.font.pointSize);
	if (self.fontSizeType == DYNFontSizeTypeRelative) {
		if (self.fontSizeString) {
			if ([self.fontSizeString hasSuffix:@"%"]) {
				NSRange range = [self.fontSizeString rangeOfString:@"%"];
				NSString *chopped = [self.fontSizeString substringToIndex:range.location];
				CGFloat percent = [chopped floatValue];
				percent /= 100;
				fontSize = floorf(button.frame.size.height * percent);
			}
		}
	}
	
    button.titleLabel.font = [UIFont fontWithName:self.font.fontName size:fontSize];
    [button setTitleShadowColor:self.shadowColor.color forState:controlState];
    button.titleLabel.shadowOffset = self.shadowOffset;
    button.titleLabel.textAlignment = self.alignment;
}

@end

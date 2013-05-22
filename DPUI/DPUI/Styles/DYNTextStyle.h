//
//  DYNTextStyle.h
//  TheQ
//
//  Created by Dan Pourhadi on 5/4/13.
//
//

#import "DYNStyle.h"
@class DYNColor;

typedef NS_ENUM (NSUInteger, DYNFontSizeType) {
    DYNFontSizeTypeAbsolute,
    DYNFontSizeTypeRelative,
};

@interface DYNTextStyle : DYNStyle <NSCopying>

+ (DYNTextStyle *)textStyleForName:(NSString *)styleName;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) DYNColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic, strong) DYNColor *shadowColor;
@property (nonatomic) NSTextAlignment alignment;
@property (nonatomic, strong) NSString *fontSizeString;
@property (nonatomic) DYNFontSizeType fontSizeType;

- (void)applyToLabel:(UILabel *)label;
- (void)applyToTextField:(UITextField *)textField;
- (NSDictionary *)titleTextAttributes;

- (void)applyToButton:(UIButton *)button forState:(UIControlState)controlState;

@end

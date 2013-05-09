//
//  DPUITextStyle.h
//  TheQ
//
//  Created by Dan Pourhadi on 5/4/13.
//
//

#import "DPUIStyle.h"
@class DPUIColor;
@interface DPUITextStyle : DPUIStyle

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) DPUIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic, strong) DPUIColor *shadowColor;
@property (nonatomic) NSTextAlignment alignment;

- (void)applyToLabel:(UILabel *)label;
- (NSDictionary *)titleTextAttributes;

@end

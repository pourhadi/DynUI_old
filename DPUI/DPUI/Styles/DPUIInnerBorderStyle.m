//
//  DPStyleInnerBorder.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DPUIInnerBorderStyle.h"
#import "DPUIDefines.h"
#import "DPUI.h"
@implementation DPUIInnerBorderStyle
- (id)jsonValue {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@(self.blendMode) forKey:kDPUIBlendModeKey];
    [dict setObject:@(self.height) forKey:kDPUIHeightKey];
    
    return dict;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.blendMode = [[dictionary objectForKey:kDPUIBlendModeKey] intValue];
        self.height = [[dictionary objectForKey:kDPUIHeightKey] floatValue];
        DPUIColor *dpColor = [[DPUIColor alloc] initWithDictionary:[dictionary objectForKey:kDPUIColorKey]];
        self.color = dpColor;
    }
    return self;
}

@end

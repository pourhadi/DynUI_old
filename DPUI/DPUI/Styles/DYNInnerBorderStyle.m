//
//  DPStyleInnerBorder.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DYNInnerBorderStyle.h"
#import "DYNDefines.h"
#import "DynUI.h"
@implementation DYNInnerBorderStyle
- (id)jsonValue {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@(self.blendMode) forKey:kDYNBlendModeKey];
    [dict setObject:@(self.height) forKey:kDYNHeightKey];
    return dict;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.blendMode = [[dictionary objectForKey:kDYNBlendModeKey] intValue];
        self.height = [[dictionary objectForKey:kDYNHeightKey] floatValue];
        DYNColor *dpColor = [[DYNColor alloc] initWithDictionary:[dictionary objectForKey:kDYNColorKey]];
        self.color = dpColor;
    }
    return self;
}

@end

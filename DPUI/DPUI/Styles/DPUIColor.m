//
//  DPUIColor.m
//  TheQ
//
//  Created by Dan Pourhadi on 5/3/13.
//
//

#import "DPUIColor.h"
#import "DPUIDefines.h"
#import "DPUI.h"
@implementation DPUIColor

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.variableName = [dictionary objectForKey:kDPUIColorNameKey];
        if (!self.variableName || self.variableName.length < 1) {
            self.variableName = [dictionary objectForKey:kDPUIColorVarKey];
        }
        
        CIColor *ciColor = [CIColor colorWithString:[dictionary objectForKey:kDPUIColorStringKey]];
        self.color = [UIColor colorWithRed:ciColor.red green:ciColor.green blue:ciColor.blue alpha:ciColor.alpha];
        
        if ([dictionary objectForKey:kDPUIDefinedAtRuntime]) {
            self.definedAtRuntime = [[dictionary objectForKey:kDPUIDefinedAtRuntime] boolValue];
        }
    }
    return self;
}

@end

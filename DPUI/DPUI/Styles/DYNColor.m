//
//  DYNColor.m
//  TheQ
//
//  Created by Dan Pourhadi on 5/3/13.
//
//

#import "DYNColor.h"
#import "DYNDefines.h"
#import "DynUI.h"
@implementation DYNColor

- (id)copyWithZone:(NSZone *)zone {
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setVariableName:[self.variableName copy]];
    [theCopy setColor:[self.color copy]];
    [theCopy setDefinedAtRuntime:self.definedAtRuntime];
    
    return theCopy;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.variableName = [dictionary objectForKey:kDYNColorNameKey];
        if (!self.variableName || self.variableName.length < 1) {
            self.variableName = [dictionary objectForKey:kDYNColorVarKey];
        }
        
        CIColor *ciColor = [CIColor colorWithString:[dictionary objectForKey:kDYNColorStringKey]];
        self.color = [UIColor colorWithRed:ciColor.red green:ciColor.green blue:ciColor.blue alpha:ciColor.alpha];
        
        if ([dictionary objectForKey:kDYNDefinedAtRuntime]) {
            self.definedAtRuntime = [[dictionary objectForKey:kDYNDefinedAtRuntime] boolValue];
        }
    }
    return self;
}

@end

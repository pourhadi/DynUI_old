//
//  DPStyle.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DPUIStyle.h"
#import "DPUIDefines.h"
#import "DPUI.h"
@implementation DPUIStyle

- (BOOL)isEqual:(id)object {
    return ([self.name isEqualToString:[object name]]);
}

@end

//
//  DPStyleBackground.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DPUIBackgroundStyle.h"
#import "UIColor+DPUI.h"
#import "DPUIColor.h"
@implementation DPUIBackgroundStyle

- (id)init
{
    self = [super init];
    if (self) {
        self.startPoint = CGPointMake(0.5, 0);
        self.endPoint = CGPointMake(0.5, 1);
        self.locations = nil;
    }
    return self;
}


- (id)initWithDictionary:(NSDictionary*)dictionary
{
	self = [super init];
	if (self) {
		self.startPoint = CGPointMake(0.5, 0);
        self.endPoint = CGPointMake(0.5, 1);
        self.locations = nil;
		NSArray *colors = [dictionary objectForKey:@"colors"];
		NSMutableArray *tmp = [NSMutableArray new];
		for (NSDictionary *color in colors) {
			DPUIColor *dpColor = [[DPUIColor alloc] initWithDictionary:color];
			[tmp addObject:dpColor.color];
		}
		
		self.colors = tmp;
	}
	return self;
}
@end

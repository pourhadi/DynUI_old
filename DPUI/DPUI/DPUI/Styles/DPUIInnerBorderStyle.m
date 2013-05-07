//
//  DPStyleInnerBorder.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DPUIInnerBorderStyle.h"

@implementation DPUIInnerBorderStyle
- (id)jsonValue
{
	NSMutableDictionary *dict = [NSMutableDictionary new];
	[dict setObject:@(self.blendMode) forKey:@"blendMode"];
	[dict setObject:@(self.height) forKey:@"height"];
	
	return dict;
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
	self = [super init];
	if (self) {
		self.blendMode = [[dictionary objectForKey:@"blendMode"] intValue];
		self.height = [[dictionary objectForKey:@"height"] floatValue];
		DPUIColor *dpColor = [[DPUIColor alloc] initWithDictionary:[dictionary objectForKey:@"color"]];
		self.color = dpColor.color;
	}
	return self;
}
@end

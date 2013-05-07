//
//  DPUIColor.m
//  TheQ
//
//  Created by Dan Pourhadi on 5/3/13.
//
//

#import "DPUIColor.h"
@implementation DPUIColor

- (id)initWithDictionary:(NSDictionary*)dictionary
{
	self = [super init];
	if (self) {
		self.variableName = [dictionary objectForKey:@"colorName"];
		CIColor *ciColor = [CIColor colorWithString:[dictionary objectForKey:@"colorString"]];
		self.color = [UIColor colorWithRed:ciColor.red green:ciColor.green blue:ciColor.blue alpha:ciColor.alpha];
		//	self.color = [UIColor colorWithCIColor:ciColor];
	}
	return self;
}

@end

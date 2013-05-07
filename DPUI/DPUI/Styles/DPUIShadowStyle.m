//
//  DPStyleShadow.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DPUIShadowStyle.h"

@implementation DPUIShadowStyle

- (id)init
{
    self = [super init];
    if (self) {
        self.offset = CGSizeMake(0, 1);
        self.radius = 0;
        self.color = [UIColor blackColor];
        self.opacity = 1;
    }
    return self;
}

- (void)addShadowToView:(UIView*)view
{
	view.layer.shadowColor = self.color.CGColor;
	view.layer.shadowRadius = self.radius;
	view.layer.shadowOpacity = self.opacity;
	view.layer.shadowOffset = self.offset;
	
	UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];
	view.layer.shadowPath = path.CGPath;
}


- (id)initWithDictionary:(NSDictionary*)dictionary
{
	self = [super init];
	if (self) {
		
		CGFloat xOffset = [[dictionary objectForKey:@"xOffset"] floatValue];
		CGFloat yOffset = [[dictionary objectForKey:@"yOffset"] floatValue];
		
		self.offset = CGSizeMake(xOffset, yOffset);
		
		self.radius = [[dictionary objectForKey:@"radius"] floatValue];
		self.opacity = [[dictionary objectForKey:@"opacity"] floatValue];
		CIColor *ciColor = [CIColor colorWithString:[dictionary objectForKey:@"color"]];
		self.color = [UIColor colorWithCIColor:ciColor];
	}
	return self;
}

@end

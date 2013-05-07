//
//  DPUITextStyle.m
//  TheQ
//
//  Created by Dan Pourhadi on 5/4/13.
//
//

#import "DPUITextStyle.h"
#import "UILabel+DPUI.h"
#import "DPUIDefines.h"
@implementation DPUITextStyle
- (id)initWithDictionary:(NSDictionary*)dict
{
	self = [super init];
	if (self) {
		
		self.name = [dict objectForKey:@"styleName"];
		self.font = [UIFont fontWithName:[dict objectForKey:@"fontName"] size:[[dict objectForKey:@"fontSize"] floatValue]];
		self.textColor = [[DPUIColor alloc] initWithDictionary:[dict objectForKey:@"textColor"]];
		self.shadowColor = [[DPUIColor alloc] initWithDictionary:[dict objectForKey:@"shadowColor"]];
		self.shadowOffset = CGSizeMake([[dict objectForKey:@"shadowXOffset"] floatValue], [[dict objectForKey:@"shadowYOffset"] floatValue]);
		self.alignment = [[dict objectForKey:@"alignment"] intValue];
	}
	
	return self;
}

- (void)applyToLabel:(UILabel*)label
{
	objc_setAssociatedObject(label, kDPTextStyleKey, self.name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	label.backgroundColor = [UIColor clearColor];
	label.textColor = self.textColor.color;
	label.font = self.font;
	label.shadowColor = self.shadowColor.color;
	label.shadowOffset = self.shadowOffset;
	label.textAlignment = self.alignment;
}

- (NSDictionary*)titleTextAttributes
{
	return @{UITextAttributeFont:self.font,
		  UITextAttributeTextColor:self.textColor.color,
		  UITextAttributeTextShadowColor:self.shadowColor.color,
		  UITextAttributeTextShadowOffset:[NSValue valueWithCGSize:self.shadowOffset]};
}

@end

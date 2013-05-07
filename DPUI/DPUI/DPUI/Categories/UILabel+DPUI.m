//
//  UILabel+DPUI.m
//  TheQ
//
//  Created by Dan Pourhadi on 5/5/13.
//
//

#import "UILabel+DPUI.h"
#import "DPUIDefines.h"
#import "DPUITextStyle.h"
#import "DPUIManager.h"
@implementation UILabel (DPUI)

- (void)setDpui_textStyle:(NSString *)dpuiTextStyle
{	
	DPUITextStyle *textStyle = [[DPUIManager sharedInstance] textStyleForName:dpuiTextStyle];
	[textStyle applyToLabel:self];
}

- (NSString*)dpui_textStyle
{
	return objc_getAssociatedObject(self, kDPTextStyleKey);
}

@end

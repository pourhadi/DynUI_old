//
//  DYNCustomView.m
//  DynUI-Example
//
//  Created by Dan Pourhadi on 5/24/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "DYNCustomView.h"

@implementation DYNCustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit
{
	self.testButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.testButton.frame = CGRectMake((self.frame.size.width - 100)/2, self.frame.size.height-50, 100, 40);
	self.testButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	[self.testButton setTitle:@"Test Button!" forState:UIControlStateNormal];
	
	[self addSubview:self.testButton];
	
	self.testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
	self.testLabel.text = @"Example of using custom settings!";
	self.testLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
	[self addSubview:self.testLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

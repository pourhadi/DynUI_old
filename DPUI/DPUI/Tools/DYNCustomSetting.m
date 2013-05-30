//
//  DYNCustomSetting.m
//  DynUI-Example
//
//  Created by Dan Pourhadi on 5/24/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "DYNCustomSetting.h"
#import "DYNDefines.h"
#import "DynUI.h"

@interface DYNCustomSetting ()

@property (nonatomic, strong) NSMutableArray *appliedToObjects;

@end

@implementation DYNCustomSetting

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self) {
		self.keyPath = [dictionary objectForKey:kDYNKeyPathKey];
		self.keyPathType = [dictionary objectForKey:kDYNKeyPathTypeKey];
		self.value = [dictionary objectForKey:kDYNValueKey];
	}
	return self;
}

- (void)applyToObject:(id)object
{
	if ([self.keyPathType isEqualToString:kDYNKeyPathTypeView]) {
		
		NSString *newKeyPath = [NSString stringWithFormat:@"%@.dyn_style", self.keyPath];
		[object setValue:self.value forKeyPath:newKeyPath];
		
	} else if ([self.keyPathType isEqualToString:kDYNKeyPathTypeLabel]) {
		
		NSString *newKeyPath = [NSString stringWithFormat:@"%@.dyn_textStyle", self.keyPath];
		[object setValue:self.value forKeyPath:newKeyPath];
		
	} else if ([self.keyPathType isEqualToString:kDYNKeyPathTypeFont]) {
		
		DYNTextStyle *textStyle = [DYNTextStyle textStyleForName:self.value];
		[object setValue:textStyle.font forKeyPath:self.keyPath];
		
	} else if ([self.keyPathType isEqualToString:kDYNKeyPathTypeImage]) {
		
		UIImage *image = [object valueForKeyPath:self.keyPath];
		if (image) {
			
			DYNImageStyle *imageStyle = [[DYNManager sharedInstance] imageStyleForName:self.value];
			UIImage *newImage = [imageStyle applyToImage:image];
			
			[object setValue:newImage forKeyPath:self.keyPath];
			
		} else {
			// TODO: No image, throw error
		}
		
	} else if ([self.keyPathType isEqualToString:kDYNKeyPathTypeColor]) {
		
		UIColor *color = [UIColor colorForVariable:self.value];
		
		[object setValue:color forKeyPath:self.keyPath];
		
	}
	
}

@end

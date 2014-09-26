//
//  DYNIcons.m
//  DynUI-Example
//
//  Created by Dan Pourhadi on 5/25/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "DYNIcons.h"
#import "UIBezierPath+SVG.h"
#import "UIBezierPath+DynUI.h"
@interface DYNIcons ()

@property (nonatomic, strong) NSDictionary *iconDictionary;

@end

@implementation DYNIcons

+ (id)sharedInstance
{
    static dispatch_once_t onceQueue;
    static DYNIcons *dYNIcons = nil;
	
    dispatch_once(&onceQueue, ^{ dYNIcons = [[self alloc] init]; });
    return dYNIcons;
}

+ (NSArray*)availableIconKeys
{
	return [[[[DYNIcons sharedInstance] iconDictionary] allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}


- (NSDictionary*)iconDictionary
{
	if (!_iconDictionary) {
        @autoreleasepool {
            
        
		NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icons" ofType:@"json"] options:0 error:nil];
		if (data) {
			_iconDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
		}
        }
     //   _iconDictionary = [self primitiveIconDictionary];
    }
	
	return _iconDictionary;
}

+ (UIBezierPath*)iconPathForKey:(NSString*)key fitInSize:(CGSize)size
{
    @autoreleasepool {
        
    
	NSString *svgString = [[[DYNIcons sharedInstance] iconDictionary] objectForKey:key];
	UIBezierPath *path = [UIBezierPath bezierPathWithSVGString:svgString];

	if (path.bounds.size.width > path.bounds.size.height) {
		path = [self iconPathForKey:key forWidth:size.width];
		if (path.bounds.size.height > size.height) {
			CGFloat scale = size.height / path.bounds.size.height;
			
			CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
			
			[path applyTransform:transform];
			
			transform = CGAffineTransformMakeTranslation(-(path.bounds.origin.x)*(1-(1/path.bounds.size.width)), -(path.bounds.origin.y) *(1-(1 / path.bounds.size.height)));
			
			[path applyTransform:transform];
		}
		[path centerInRect:CGRectMake(0, 0, size.width, size.height)];
		return path;
	}
	
	path = [self iconPathForKey:key forHeight:size.height];
	if (path.bounds.size.width > size.width) {
		
		CGFloat scale = size.width / path.bounds.size.width;
		
		CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
		
		[path applyTransform:transform];
		
		transform = CGAffineTransformMakeTranslation(-(path.bounds.origin.x)*(1-(1/path.bounds.size.width)), -(path.bounds.origin.y) *(1-(1 / path.bounds.size.height)));
		
		[path applyTransform:transform];
	}
	[path centerInRect:CGRectMake(0, 0, size.width, size.height)];

	return path;
    }
}

+ (UIBezierPath*)iconPathForKey:(NSString*)key forWidth:(CGFloat)width
{
    @autoreleasepool {
        
    
	NSString *svgString = [[[DYNIcons sharedInstance] iconDictionary] objectForKey:key];
	if (svgString) {
		
		UIBezierPath *path = [UIBezierPath bezierPathWithSVGString:svgString];
		CGSize currentSize = path.bounds.size;
		
		CGFloat scale = width / currentSize.width;
		
		CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
		
		[path applyTransform:transform];
		
		transform = CGAffineTransformMakeTranslation(-(path.bounds.origin.x)*(1-(1/path.bounds.size.width)), -(path.bounds.origin.y) *(1-(1 / path.bounds.size.height)));
		
		[path applyTransform:transform];
		
		return path;
	}
	return nil;
    }
}

+ (UIBezierPath*)iconPathForKey:(NSString*)key forHeight:(CGFloat)height
{
    @autoreleasepool {
        
        height = roundf(height);
	NSString *svgString = [[[DYNIcons sharedInstance] iconDictionary] objectForKey:key];
	if (svgString) {
		
		UIBezierPath *path = [UIBezierPath bezierPathWithSVGString:svgString];
		CGSize currentSize = path.bounds.size;
		
		CGFloat scale = height / currentSize.height;
		
		CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
		
		[path applyTransform:transform];
		
		transform = CGAffineTransformMakeTranslation(-(path.bounds.origin.x)*(1-(1/path.bounds.size.width)), -(path.bounds.origin.y) *(1-(1 / path.bounds.size.height)));
		
		[path applyTransform:transform];
		
		return path;
	}
	return nil;
    }
}

@end

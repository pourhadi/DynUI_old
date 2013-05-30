//
//  DYNSliderStyle.m
//  DPUI
//
//  Created by Dan Pourhadi on 5/12/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DYNSliderStyle.h"
#import "DynUI.h"
#import "DYNDefines.h"
@implementation DYNSliderStyle

+ (DYNSliderStyle *)sliderStyleForName:(NSString *)styleName {
    return [[DYNManager sharedInstance] sliderStyleForName:styleName];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = [dictionary objectForKey:kDYNStyleNameKey];
        self.strokeWidth = [[dictionary objectForKey:kDYNStrokeWidth] floatValue];
        self.strokeColor = [[DYNColor alloc] initWithDictionary:[dictionary objectForKey:kDYNStrokeColor]];
        self.outerShadow = [[DYNShadowStyle alloc] initWithDictionary:[dictionary objectForKey:kDYNOuterShadowKey]];
        self.trackHeight = [[dictionary objectForKey:kDYNTrackHeightKey] floatValue];
        self.thumbHeight = [[dictionary objectForKey:kDYNThumbHeightKey] floatValue];
        self.minimumTrackInnerShadow = [[DYNShadowStyle alloc] initWithDictionary:[dictionary objectForKey:kDYNMinimumTrackInnerShadowKey]];
        self.maximumTrackInnerShadow = [[DYNShadowStyle alloc] initWithDictionary:[dictionary objectForKey:kDYNMaximumTrackInnerShadowKey]];
        if ([dictionary objectForKey:kDYNThumbStyleNameKey]) self.thumbStyleName = [dictionary objectForKey:kDYNThumbStyleNameKey];
        NSMutableArray *tmp;
		
        tmp = [NSMutableArray new];
        for (NSDictionary *color in [dictionary objectForKey : kDYNMaxTrackBgColorsKey]) {
            [tmp addObject:[[DYNColor alloc] initWithDictionary:color]];
        }
		
        self.maximumTrackBackground = [[DYNBackgroundStyle alloc] init];
        self.maximumTrackBackground.colors = tmp;
		
        tmp = [NSMutableArray new];
        for (NSDictionary *color in [dictionary objectForKey : kDYNMinTrackBgColorsKey]) {
            [tmp addObject:[[DYNColor alloc] initWithDictionary:color]];
        }
		
        self.minimumTrackBackground = [[DYNBackgroundStyle alloc] init];
        self.minimumTrackBackground.colors = tmp;
    }
	
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.name = @"SliderStyle";
        self.minimumTrackBackground = [[DYNBackgroundStyle alloc] init];
        self.maximumTrackBackground = [[DYNBackgroundStyle alloc] init];
        self.minimumTrackInnerShadow = [[DYNShadowStyle alloc] init];
        self.maximumTrackInnerShadow = [[DYNShadowStyle alloc] init];
        self.outerShadow = [[DYNShadowStyle alloc] init];
        self.trackHeight = 11;
        self.thumbHeight = 1.5;
        self.strokeColor = [[DYNColor alloc] init];
    }
    return self;
}

- (UIImage *)maxTrackImageForSlider:(UISlider *)slider {
    UIImage *image = [UIImage imageWithSize:CGSizeMake(self.trackHeight, self.trackHeight) drawnWithBlock:^(CGContextRef context, CGRect rect) {
		
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
		
        DYNStyleParameters *params;
        if (slider) {
            params = slider.styleParameters;
        }
		
        [self.maximumTrackBackground drawInPath:path withContext:context parameters:params flippedGradient:NO];
        [self.maximumTrackInnerShadow drawAsInnerShadowInPath:path context:context];
        if (self.strokeWidth > 0) {
            CGRect strokeRect = CGRectMake(self.strokeWidth / 2, self.strokeWidth / 2, rect.size.width - (self.strokeWidth), rect.size.height - (self.strokeWidth));
            UIBezierPath *strokePath = [UIBezierPath bezierPathWithOvalInRect:strokeRect];
            [self.strokeColor.color setStroke];
            [strokePath setLineWidth:self.strokeWidth];
            [strokePath stroke];
        }
    }].dyn_resizableImage;
	
    if (self.outerShadow) {
        image = [self.outerShadow applyShadowToImage:image].dyn_resizableImage;
    }
	
    return image;
}

- (UIImage *)minTrackImageForSlider:(UISlider *)slider {
    UIImage *image = [UIImage imageWithSize:CGSizeMake(self.trackHeight, self.trackHeight) drawnWithBlock:^(CGContextRef context, CGRect rect) {
		
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
		
        DYNStyleParameters *params;
        if (slider) {
            params = slider.styleParameters;
        }
		
        [self.minimumTrackBackground drawInPath:path withContext:context parameters:params flippedGradient:NO];
        [self.minimumTrackInnerShadow drawAsInnerShadowInPath:path context:context];
		
        if (self.strokeWidth > 0) {
            CGRect strokeRect = CGRectMake(self.strokeWidth / 2, self.strokeWidth / 2, rect.size.width - (self.strokeWidth), rect.size.height - (self.strokeWidth));
            UIBezierPath *strokePath = [UIBezierPath bezierPathWithOvalInRect:strokeRect];
            [self.strokeColor.color setStroke];
            [strokePath setLineWidth:self.strokeWidth];
            [strokePath stroke];
        }
    }].dyn_resizableImage;
	
    if (self.outerShadow) {
        image = [self.outerShadow applyShadowToImage:image].dyn_resizableImage;
    }
	
    return image;
}

- (UIImage *)thumbImageForSlider:(UISlider *)slider {
    DYNViewStyle *style = [[DYNManager sharedInstance] styleForName:self.thumbStyleName];
	
    CGFloat thumbHeight = floorf(self.trackHeight * self.thumbHeight);
	
    DYNStyleParameters *params;
    if (slider) {
        params = slider.styleParameters;
    }
	
    UIImage *image = [style imageForStyleWithSize:CGSizeMake(thumbHeight, thumbHeight) withOuterShadow:YES parameters:params];
	
    return image;
}

@end

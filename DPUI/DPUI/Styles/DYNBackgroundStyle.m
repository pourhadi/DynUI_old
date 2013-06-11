//
//  DPStyleBackground.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DYNBackgroundStyle.h"
#import "DYNDefines.h"
#import "DynUI.h"
#import "KGNoise.h"

@implementation DYNBackgroundStyle

- (id)init {
    self = [super init];
    if (self) {
        self.gradientAngle = 180;
        self.locations = nil;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
		
		NSDictionary *grad = [dictionary objectForKey:@"gradient"];
		
        self.gradientAngle = [[grad objectForKey:kDYNGradientAngle] floatValue];
        self.locations = nil;
		
		DYNFillType fillType = DYNFillTypeGradient;
		if ([dictionary objectForKey:kDYNFillTypeKey]) {
			fillType = [[dictionary objectForKey:kDYNFillTypeKey] intValue];
		}
		
		if (fillType == DYNFillTypeGradient) {
        NSArray *colors = [grad objectForKey:@"colors"];
        NSMutableArray *tmp = [NSMutableArray new];
        for (NSDictionary *color in colors) {
            DYNColor *dpColor = [[DYNColor alloc] initWithDictionary:color];
            [tmp addObject:dpColor];
			self.colors = tmp;

        }
		
		self.locations = [grad objectForKey:@"locations"];
		} else {
			DYNColor *color = [[DYNColor alloc] initWithDictionary:[dictionary objectForKey:kDYNFillColorKey]];
			self.colors = @[color];
		}
		
		if ([dictionary objectForKey:kDYNNoiseOpacityKey]) {
			self.noiseOpacity = [[dictionary objectForKey:kDYNNoiseOpacityKey] floatValue];
		}
		
		if ([dictionary objectForKey:kDYNNoiseBlendModeKey]) {
			self.noiseBlendMode = [[dictionary objectForKey:kDYNNoiseBlendModeKey] intValue];
		}
        
    }
    return self;
}

- (NSArray *)colorArray {
    return [self valueForKeyPath:@"colors.color"];
}

- (void)drawInFrame:(CGRect)frame clippedToPath:(UIBezierPath *)path parameters:(DYNStyleParameters *)parameters flippedGradient:(BOOL)flippedGradient {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    [path addClip];
    
    if (self.colors.count > 1) {
        DYNGradient *gradient = [[DYNGradient alloc] initWithColors:self.colors locations:self.locations];
        //[gradient drawInPath:path flipped:flippedGradient angle:self.gradientAngle parameters:parameters];
        [gradient drawInFrame:frame clippedToPath:path angle:self.gradientAngle flippedGradient:flippedGradient parameters:parameters];
    } else {
        DYNColor *DYNColor = self.colors[0];
        UIColor *color = DYNColor.color;
        if (DYNColor.definedAtRuntime) {
            UIColor *paramColor = [parameters valueForStyleParameter:DYNColor.variableName];
            if (paramColor) {
                color = paramColor;
            }
        }
        
        [color setFill];
        [path fill];
    }
	
	if (self.noiseOpacity > 0) {
		[KGNoise drawNoiseWithOpacity:self.noiseOpacity andBlendMode:self.noiseBlendMode];
	}
    
    CGContextRestoreGState(context);
}

- (void)drawInPath:(UIBezierPath *)path withContext:(CGContextRef)context parameters:(DYNStyleParameters *)parameters flippedGradient:(BOOL)flippedGradient {
    [self drawInFrame:path.bounds clippedToPath:path parameters:parameters flippedGradient:flippedGradient];
}

@end

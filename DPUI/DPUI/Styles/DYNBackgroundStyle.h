//
//  DPStyleBackground.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>
@class DYNStyleParameters;
@interface DYNBackgroundStyle : NSObject

@property (nonatomic, strong) NSArray *colors; // multiple colors for gradient; single for solid color

// if colors.count > 1, the properties below are used
@property (nonatomic, strong) NSArray *locations;

@property (nonatomic) CGFloat gradientAngle;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (void)drawInPath:(UIBezierPath*)path withContext:(CGContextRef)context parameters:(DYNStyleParameters*)parameters flippedGradient:(BOOL)flippedGradient;
- (void)drawInFrame:(CGRect)frame clippedToPath:(UIBezierPath*)path parameters:(DYNStyleParameters*)parameters flippedGradient:(BOOL)flippedGradient;
@end

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

/** The background colors, represented as DYNColor objects. If there is more than one color in the array, the colors are rednered as a gradient. */
@property (nonatomic, strong) NSArray *colors;

@property (nonatomic, strong) NSArray *locations;

/** The angle of the gradient if colors.count > 1, in degrees. 180 degrees represents a vertical gradient, with a startPoint of [0.5, 0] and an endPoint of [0.5, 1] (in unit coordinates). */
@property (nonatomic) CGFloat gradientAngle;

- (id)initWithDictionary:(NSDictionary *)dictionary;

///---------------------------------------------------------------------------------------
/// @name Drawing Methods
///---------------------------------------------------------------------------------------
- (void)drawInPath:(UIBezierPath *)path withContext:(CGContextRef)context parameters:(DYNStyleParameters *)parameters flippedGradient:(BOOL)flippedGradient;
- (void)drawInFrame:(CGRect)frame clippedToPath:(UIBezierPath *)path parameters:(DYNStyleParameters *)parameters flippedGradient:(BOOL)flippedGradient;
@end

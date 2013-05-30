//
//  DYNGradient.h
//  DynUI-Example
//
//  Created by Daniel Pourhadi on 5/16/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DYNStyleParameters;
@interface DYNGradient : NSObject

- (id)initWithColors:(NSArray *)colors;

- (void)drawInPath:(UIBezierPath *)path angle:(CGFloat)angle parameters:(DYNStyleParameters *)parameters;
- (void)drawInPath:(UIBezierPath *)path flipped:(BOOL)flipped angle:(CGFloat)angle parameters:(DYNStyleParameters *)parameters;
- (void)drawInFrame:(CGRect)frame clippedToPath:(UIBezierPath *)path angle:(CGFloat)angle flippedGradient:(BOOL)flipped parameters:(DYNStyleParameters *)parameters;
@end

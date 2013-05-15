//
//  DPStyleShadow.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>

@interface DYNShadowStyle : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGSize offset;
@property (nonatomic) CGFloat opacity;

- (UIImage*)getImageForWidth:(CGFloat)width;
- (void)addShadowToView:(UIView *)view withPath:(UIBezierPath*)path;
- (void)addShadowToView:(UIView *)view;
- (UIImage*)applyShadowToImage:(UIImage*)image;
- (id)initWithDictionary:(NSDictionary *)dictionary;

- (void)drawAsInnerShadowInPath:(UIBezierPath*)path context:(CGContextRef)context;

- (void)drawAsOuterShadowWithPath:(UIBezierPath*)path context:(CGContextRef)context;

@end

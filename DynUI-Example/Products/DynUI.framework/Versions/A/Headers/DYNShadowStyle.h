//
//  DPStyleShadow.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DYNColor;
@interface DYNShadowStyle : NSObject

@property (nonatomic, strong) DYNColor *color;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGSize offset;
@property (nonatomic) CGFloat opacity;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (UIImage *)getImageForWidth:(CGFloat)width;
- (void)addShadowToView:(UIView *)view withPath:(UIBezierPath *)path;
- (void)addShadowToView:(UIView *)view;
- (UIImage *)applyShadowToImage:(UIImage *)image;

- (void)drawAsInnerShadowInPath:(UIBezierPath *)path context:(CGContextRef)context;

@end

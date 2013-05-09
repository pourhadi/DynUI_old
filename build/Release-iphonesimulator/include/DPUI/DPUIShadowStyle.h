//
//  DPStyleShadow.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>

@interface DPUIShadowStyle : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGSize offset;
@property (nonatomic) CGFloat opacity;

- (void)addShadowToView:(UIView *)view;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

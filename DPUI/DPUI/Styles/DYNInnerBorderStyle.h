//
//  DPStyleInnerBorder.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>
@class DYNColor;
@interface DYNInnerBorderStyle : NSObject

@property (nonatomic, strong) DYNColor *color;
@property (nonatomic) CGBlendMode blendMode;
@property (nonatomic) CGFloat height;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

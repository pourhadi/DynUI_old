//
//  DPStyleInnerBorder.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>
@class DPUIColor;
@interface DPUIInnerBorderStyle : NSObject

@property (nonatomic, strong) DPUIColor *color;
@property (nonatomic) CGBlendMode blendMode;
@property (nonatomic) CGFloat height;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

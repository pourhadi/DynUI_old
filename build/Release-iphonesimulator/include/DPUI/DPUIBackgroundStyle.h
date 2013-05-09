//
//  DPStyleBackground.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>
@interface DPUIBackgroundStyle : NSObject

@property (nonatomic, strong) NSArray *colors; // multiple colors for gradient; single for solid color

// if colors.count > 1, the properties below are used
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

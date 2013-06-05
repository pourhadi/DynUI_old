//
//  DYNColor.h
//  TheQ
//
//  Created by Dan Pourhadi on 5/3/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DYNColor : NSObject <NSCopying>

@property (nonatomic, strong) NSString *variableName;
@property (nonatomic, strong) UIColor *color;

@property (nonatomic) BOOL definedAtRuntime;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

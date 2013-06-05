//
//  DYNCustomSetting.h
//  DynUI-Example
//
//  Created by Dan Pourhadi on 5/24/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
static NSString * const kDYNKeyPathTypeView = @"UIView";
static NSString * const kDYNKeyPathTypeLabel = @"UILabel";
static NSString * const kDYNKeyPathTypeFont = @"UIFont";
static NSString * const kDYNKeyPathTypeColor = @"UIColor";
static NSString * const kDYNKeyPathTypeImage = @"UIImage";

@interface DYNCustomSetting : NSObject

@property (nonatomic, strong) NSString *keyPath;
@property (nonatomic, strong) NSString *keyPathType;
@property (nonatomic, strong) NSString *value;

- (id)initWithDictionary:(NSDictionary*)dictionary;

- (void)applyToObject:(id)object;

@end

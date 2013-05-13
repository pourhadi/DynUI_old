//
//  UILabel+DynUI.h
//  TheQ
//
//  Created by Dan Pourhadi on 5/5/13.
//
//

#import <UIKit/UIKit.h>

@interface UILabel (DynUI)
@property (nonatomic, strong) NSString *dyn_textStyle;

- (void)dyn_refreshStyle;
@end

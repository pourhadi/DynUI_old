//
//  UILabel+DPUI.h
//  TheQ
//
//  Created by Dan Pourhadi on 5/5/13.
//
//

#import <UIKit/UIKit.h>

@interface UILabel (DPUI)
@property (nonatomic, strong) NSString *dpui_textStyle;

- (void)dpui_refreshStyle;
@end

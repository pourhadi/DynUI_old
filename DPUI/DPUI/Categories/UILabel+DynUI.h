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

@property (nonatomic) BOOL dyn_autoScroll;

@property (nonatomic) NSTimeInterval dyn_scrollDuration;
@property (nonatomic) NSTimeInterval dyn_scrollPauseDuration;
@property (nonatomic) CGFloat dyn_scrollTextSeparatorWidth;

- (void)applyLabelAttributesToLabel:(UILabel*)label;

@end

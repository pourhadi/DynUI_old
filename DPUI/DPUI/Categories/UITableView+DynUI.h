//
//  UITableView+DynUI.h
//  DynUI-Example
//
//  Created by Daniel Pourhadi on 5/16/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (DynUI)

- (void)dyn_styleGroupedCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath withStyle:(NSString*)styleName;
- (void)dyn_styleGroupedCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;

@end

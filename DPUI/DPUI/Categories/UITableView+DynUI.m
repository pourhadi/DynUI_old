//
//  UITableView+DynUI.m
//  DynUI-Example
//
//  Created by Daniel Pourhadi on 5/16/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "UITableView+DynUI.h"
#import "DynUI.h"
@implementation UITableView (DynUI)

- (void)dyn_styleGroupedCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath withStyle:(NSString*)styleName
{
    DYNViewStyle *style = [[DYNManager sharedInstance] styleForName:styleName];
    NSInteger rowCount = [self numberOfRowsInSection:indexPath.section];
    NSInteger row = indexPath.row;
    
    if (rowCount == 1) {
        
        if (style.groupedTableSingleCell) {
            cell.dyn_style = style.groupedTableSingleCell;
        }
        
    } else {
        if (row == 0) {
            if (style.groupedTableTopCell) {
                cell.dyn_style = style.groupedTableTopCell;
            }
        } else if (row > 0 && row < rowCount-1) {
            if (style.groupedTableMiddleCell) {
                cell.dyn_style = style.groupedTableMiddleCell;
            }
        } else if (row == rowCount-1) {
            if (style.groupedTableBottomCell) {
                cell.dyn_style = style.groupedTableBottomCell;
            }
        }
    }
    
}

@end

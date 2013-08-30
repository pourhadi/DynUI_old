//
//  DYNBlurredView.h
//  DynUI-Example
//
//  Created by Dan Pourhadi on 6/24/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYNBlurredView : UIView

@property (nonatomic, weak) UIView *sourceView;
@property (nonatomic, weak) UIScrollView *sourceScrollView;

@property (nonatomic) BOOL autoRefresh;

- (void)refreshSnapshotCache;

@end

//
//  DYNBlurredView.m
//  DynUI-Example
//
//  Created by Dan Pourhadi on 6/24/13.
//  Copyright (c) 2013 Dan Pourhadi. All rights reserved.
//

#import "DYNBlurredView.h"
#import "UIImage+ImageEffects.h"
#import "UIView+DynUI.h"

#define kViewSectionHeight UIAppDelegate.window.frame.size.height*2

@interface DYNBlurredView()

@property (nonatomic, strong) UIView *savedSnapshot;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) NSArray *viewSnaps;

@property (nonatomic) CGPoint currentOffset;

@end

@implementation DYNBlurredView

- (void)setSourceView:(UIView *)sourceView
{
    if (sourceView != _sourceView) {
        if (![sourceView isKindOfClass:[UIScrollView class]]) {
            if (_sourceView && [_sourceView isKindOfClass:[UIScrollView class]]) {
                [self removeObserver:self forKeyPath:@"sourceView.contentOffset"];
            }
        }
        _sourceView = sourceView;
                
        [self refreshSnapshotCache];
    }
}

- (void)setSourceScrollView:(UIScrollView *)sourceScrollView
{
    self.sourceView = sourceScrollView;
    self.autoRefresh = YES;

    if (!self.displayLink) {
                        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshImage)];
                    }
        
                    self.displayLink.frameInterval = 3;
                    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}


- (UIScrollView*)sourceScrollView
{
    return (UIScrollView*)self.sourceView;
}

- (void)refreshSnapshotCache
{
    NSMutableArray *tmp = [NSMutableArray new];
    
    int x = self.sourceScrollView.frame.size.height / kViewSectionHeight;
    if (self.sourceScrollView.frame.size.height - (x*kViewSectionHeight) > 0) {
        x += 1;
    }
    
    for (int y = 0; y <= x; y++) {
        
        CGRect snapRect;
        snapRect.origin.y = y * kViewSectionHeight;
        snapRect.origin.x = 0;
        snapRect.size.height = kViewSectionHeight;
        snapRect.size.width = self.sourceScrollView.frame.size.width;
        
        UIView *snap = [self.sourceScrollView resizableSnapshotViewFromRect:snapRect afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        [tmp addObject:snap];
        self.viewSnaps = tmp;
    }
    

    [self refreshImage];
}

//- (void)setAutoRefresh:(BOOL)autoRefresh
//{
//    if (autoRefresh != _autoRefresh) {
//        _autoRefresh = autoRefresh;
//        
//        if (autoRefresh) {
//            if (!self.displayLink) {
//                self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshImage)];
//            }
//            
//            self.displayLink.frameInterval = 2;
//            [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//        } else {
//            if (self.displayLink) {
//                [self.displayLink setPaused:YES];
//                [self.displayLink invalidate];
//                self.displayLink = nil;
//            }
//            
//            [self refreshImage];
//        }
//    }
//}

- (void)refreshImage
{
   // if (!self.sourceView) DLog(@"no source view!");
    
    CGRect convertedRect = [self.superview convertRect:self.frame toView:self.sourceView];
    UIView *snap;
    
    if (convertedRect.origin.y < kViewSectionHeight) {
        snap = self.viewSnaps[0];
        CGRect newFrame = snap.frame;
        newFrame.origin.y = -convertedRect.origin.y;
        snap.frame = newFrame;
    } else {
        int x = convertedRect.origin.y / kViewSectionHeight;
        snap = self.viewSnaps[x];
        
        CGFloat newY = convertedRect.origin.y - (x * kViewSectionHeight);
        CGRect newFrame = snap.frame;
        newFrame.origin.y = -newY;
        snap.frame = newFrame;
    }
    
//    UIImage *image = [self.sourceView imageFromSnapshotInRect:convertedRect];
//    image = [image applyExtraLightEffect];
//    self.layer.contents = (id)image.CGImage;

    
    [self addSubview:snap];
    
    UIImage *image = [UIImage imageWithSize:snap.frame.size drawnWithBlock:^(CGContextRef context, CGRect rect) {

        [snap drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    }];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.layer.contents = (id)image.CGImage;
    

}


@end

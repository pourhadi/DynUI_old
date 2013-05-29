//
//  UINavigationBar+DynUI.m
//  Echo POS Mobile
//
//  Created by Daniel Pourhadi on 5/29/13.
//  Copyright (c) 2013 Echo Daily. All rights reserved.
//

#import "UINavigationBar+DynUI.h"
#import "DynUI.h"
#import "DYNDefines.h"
@implementation UINavigationBar (DynUI)

- (void)applyStyleToBarButtonItems:(NSString*)styleName
{
    [self set_barButtonItemStyleName:styleName];
    
    for (UIBarButtonItem *item in self.topItem.leftBarButtonItems) {
        [DYNRenderer renderBarButtonItem:item forNavigationBar:self withStyleNamed:styleName];
    }
    
    for (UIBarButtonItem *item in self.topItem.rightBarButtonItems) {
        [DYNRenderer renderBarButtonItem:item forNavigationBar:self withStyleNamed:styleName];
    }
    
    [self addObserversForBarButtonItems];
}

- (void)addObserversForBarButtonItems
{    
    [self removeObserversForBarButtonItems];
    [self addObserver:self forKeyPath:@"items" options:0 context:nil];
    [self addObserver:self forKeyPath:@"topItem.leftBarButtonItems" options:0 context:nil];
    [self addObserver:self forKeyPath:@"topItem.rightBarButtonItems" options:0 context:nil];
    [self set_styleObservationArray:@[@"items",@"topItem.leftBarButtonItems", @"topItem.rightBarButtonItems"]];
}

- (void)removeObserversForBarButtonItems
{
    if ([self styleObservationArray]){
        NSArray *obsArray = [self styleObservationArray];
        for (NSString *keypath in obsArray) {
            [self removeObserver:self forKeyPath:keypath];
        }
    }
    
    [self set_styleObservationArray:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"topItem.leftBarButtonItems"]) {
        
        for (UIBarButtonItem *item in self.topItem.leftBarButtonItems) {
            [DYNRenderer renderBarButtonItem:item forNavigationBar:self withStyleNamed:[self barButtonItemStyleName]];
        }
        
    } else if ([keyPath isEqualToString:@"topItem.rightBarButtonItems"]) {
        
        for (UIBarButtonItem *item in self.topItem.rightBarButtonItems) {
            [DYNRenderer renderBarButtonItem:item forNavigationBar:self withStyleNamed:[self barButtonItemStyleName]];
        }
        
    } else if ([keyPath isEqualToString:@"items"]) {
        
        for (UINavigationItem *navItem in self.items) {
            for (UIBarButtonItem *item in self.topItem.leftBarButtonItems) {
                [DYNRenderer renderBarButtonItem:item forNavigationBar:self withStyleNamed:[self barButtonItemStyleName]];
            }
            
            for (UIBarButtonItem *item in self.topItem.rightBarButtonItems) {
                [DYNRenderer renderBarButtonItem:item forNavigationBar:self withStyleNamed:[self barButtonItemStyleName]];
            }
            
            [DYNRenderer renderBarButtonItem:navItem.backBarButtonItem forNavigationBar:self withStyleNamed:[self barButtonItemStyleName]];
            
        }
    }
}


GET_AND_SET_ASSOCIATED_OBJ(barButtonItemStyleName, nil);
GET_AND_SET_ASSOCIATED_OBJ(styleObservationArray, nil);

@end

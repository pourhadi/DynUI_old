//
//  DPStyleManager.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DPUIManager.h"
#import "DPUIDefines.h"
#import "DPUI.h"
@implementation DPUIManager

+ (DPUIManager *)sharedInstance {
    static dispatch_once_t onceQueue;
    static DPUIManager *instance = nil;
    
    dispatch_once(&onceQueue, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (NSMutableArray *)styles {
    if (!_styles) {
        _styles = [NSMutableArray new];
    }
    
    return _styles;
}

- (NSMutableArray *)colorVariables {
    if (!_colorVariables) {
        _colorVariables = [NSMutableArray new];
    }
    return _colorVariables;
}

- (NSMutableArray *)textStyles {
    if (!_textStyles) {
        _textStyles = [NSMutableArray new];
    }
    return _textStyles;
}

- (DPUIViewStyle *)styleForName:(NSString *)name {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name == %@", name];
    NSArray *filtered = [self.styles filteredArrayUsingPredicate:pred];
    if (filtered) {
        if (filtered.count > 0) {
            return filtered[0];
        }
    }
    return nil;
}

- (UIColor *)colorForVariableName:(NSString *)variableName {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"variableName == %@", variableName];
    NSArray *filtered = [self.colorVariables filteredArrayUsingPredicate:pred];
    if (filtered) {
        if (filtered.count > 0) {
            return [filtered[0] color];
        }
    }
    return nil;
}

- (DPUITextStyle *)textStyleForName:(NSString *)name {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name == %@", name];
    NSArray *filtered = [self.textStyles filteredArrayUsingPredicate:pred];
    if (filtered) {
        if (filtered.count > 0) {
            return filtered[0];
        }
    }
    return nil;
}

- (void)registerView:(id)view {
    if (!self.registeredViews) {
        self.registeredViews = [NSArray array];
    }
    
    
    if (![self.registeredViews containsObject:view]) {
        NSMutableArray *mutable = [self.registeredViews mutableCopy];
        [mutable addObject:view];
        [view addObserver:self forKeyPath:@"frame" options:0 context:nil];
        self.registeredViews = mutable;
    }
}

- (void)unregisterView:(id)view {
    if (self.registeredViews) {
        if ([self.registeredViews containsObject:view]) {
            [view removeObserver:self forKeyPath:@"frame"];
            NSMutableArray *mutable = [self.registeredViews mutableCopy];
            [mutable removeObject:view];
            self.registeredViews = mutable;
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object respondsToSelector:@selector(dpui_frameChanged)]) {
        [object dpui_frameChanged];
    }
}

- (NSDictionary *)defaultParameterValues {
    if (!_defaultParameterValues) {
        _defaultParameterValues = [NSDictionary dictionary];
    }
    return _defaultParameterValues;
}

- (id)defaultValueForParameter:(NSString *)parameter {
    if ([self.defaultParameterValues objectForKey:parameter]) {
        return [self.defaultParameterValues objectForKey:parameter];
    }
    
    return nil;
}

- (void)loadStylesFromFile:(NSString *)fileName replaceExisting:(BOOL)replaceExisting liveUpdate:(BOOL)liveUpdate {
    @synchronized(self) {
        NSError *error;
        NSData *data;
        
        if (liveUpdate) {
            data = [NSData dataWithContentsOfFile:fileName];
        } else {
            data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:nil]];
        }
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        if (json) {
            NSArray *colors = [json objectForKey:@"colors"];
            NSMutableArray *colorTmp = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dict in colors) {
                [colorTmp addObject:[[DPUIColor alloc] initWithDictionary:dict]];
            }
            if (replaceExisting) {
                self.colorVariables = colorTmp;
            } else {
                [self.colorVariables addObjectsFromArray:colorTmp];
            }
            
            NSArray *textStyles = [json objectForKey:@"textStyles"];
            NSMutableArray *textStylesTmp = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dict in textStyles) {
                [textStylesTmp addObject:[[DPUITextStyle alloc] initWithDictionary:dict]];
            }
            if (replaceExisting) {
                self.textStyles = textStylesTmp;
            } else {
                [self.textStyles addObjectsFromArray:textStylesTmp];
            }
            NSArray *styles = [json objectForKey:@"styles"];
            NSMutableArray *viewStyleTmp = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *style in styles) {
                DPUIViewStyle *new = [[DPUIViewStyle alloc] initWithDictionary:style];
                [viewStyleTmp addObject:new];
            }
            if (replaceExisting) {
                self.styles = viewStyleTmp;
            } else {
                [self.styles addObjectsFromArray:viewStyleTmp];
            }
        }
        
        [CATransaction flush];
        if (liveUpdate && !self.liveUpdating) {
            _liveUpdating = YES;
            [self watch:fileName withCallback:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadStylesFromFile:fileName replaceExisting:replaceExisting liveUpdate:liveUpdate];
                });
            }];
        } else {
            _liveUpdating = NO;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendUpdateNotification];
    });
}

- (void)watch:(NSString *)path withCallback:(void (^)())callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    int fileDescriptor = open([path UTF8String], O_EVTONLY);
    
    __block dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fileDescriptor,
                                                              DISPATCH_VNODE_DELETE | DISPATCH_VNODE_WRITE | DISPATCH_VNODE_EXTEND,
                                                              queue);
    dispatch_source_set_event_handler(source, ^
                                      {
                                          unsigned long flags = dispatch_source_get_data(source);
                                          if (flags) {
                                              dispatch_source_cancel(source);
                                              callback();
                                              [self watch:path withCallback:callback];
                                          }
                                      });
    dispatch_source_set_cancel_handler(source, ^(void)
                                       {
                                           close(fileDescriptor);
                                       });
    dispatch_resume(source);
}

- (void)sendUpdateNotification {
    //[[NSNotificationCenter defaultCenter] postNotificationName:kDPUIThemeChangedNotification object:nil];
    
    for (id obj in self.registeredViews) {
        [obj dpui_refreshStyle];
    }
}

@end

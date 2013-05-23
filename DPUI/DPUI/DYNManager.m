//
//  DPStyleManager.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DYNManager.h"
#import "DYNDefines.h"
#import "DynUI.h"
#import "SVProgressHUD.h"
#include "TargetConditionals.h"

@implementation DYNManager

+ (DYNManager *)sharedInstance {
    static dispatch_once_t onceQueue;
    static DYNManager *instance = nil;
	
    dispatch_once(&onceQueue, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (CIContext *)sharedCIContext {
    if (!_sharedCIContext) {
        _sharedCIContext = [CIContext contextWithOptions:nil];
    }
    return _sharedCIContext;
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

- (DYNSliderStyle *)sliderStyleForName:(NSString *)name {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name == %@", name];
    NSArray *filtered = [self.sliderStyles filteredArrayUsingPredicate:pred];
    if (filtered) {
        if (filtered.count > 0) {
            return filtered[0];
        }
    }
    return nil;
}

- (DYNViewStyle *)styleForName:(NSString *)name {
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

- (DYNTextStyle *)textStyleForName:(NSString *)name {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name == %@", name];
    NSArray *filtered = [self.textStyles filteredArrayUsingPredicate:pred];
    if (filtered) {
        if (filtered.count > 0) {
            return filtered[0];
        }
    }
    return nil;
}

- (DYNImageStyle *)imageStyleForName:(NSString *)name {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name == %@", name];
    NSArray *filtered = [self.imageStyles filteredArrayUsingPredicate:pred];
    if (filtered) {
        if (filtered.count > 0) {
            return filtered[0];
        }
    }
    return nil;
}

- (void)addSliderStyle:(DYNSliderStyle *)sliderStyle {
    [self.sliderStyles addObject:sliderStyle];
}

- (void)addViewStyle:(DYNViewStyle *)viewStyle {
    [self.styles addObject:viewStyle];
}

- (void)addColorVariable:(DYNColor *)colorVariable {
    [self.colorVariables addObject:colorVariable];
}

- (void)addTextStyle:(DYNTextStyle *)textStyle {
    [self.textStyles addObject:textStyle];
}

- (void)addImageStyle:(DYNImageStyle *)imageStyle {
    [self.imageStyles addObject:imageStyle];
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
    if ([object respondsToSelector:@selector(dyn_frameChanged)]) {
        [object dyn_frameChanged];
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

- (void)loadStylesFromFileAbsolutePath:(NSString*)absolute resourcePath:(NSString*)resourcePath replaceExisting:(BOOL)replaceExisting liveUpdateIfPossible:(BOOL)liveUpdate
{
    @synchronized(self) {
        NSError *error;
        NSData *data;
		
        if (liveUpdate) {
            
#if (TARGET_IPHONE_SIMULATOR)
            
            if (absolute) {
                data = [NSData dataWithContentsOfFile:absolute];
                
                if (liveUpdate && !self.liveUpdating) {
                    _liveUpdating = YES;
                    [self watch:absolute withCallback:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self loadStylesFromFileAbsolutePath:absolute resourcePath:resourcePath replaceExisting:replaceExisting liveUpdateIfPossible:liveUpdate];
                        });
                    }];
                } else {
                    _liveUpdating = NO;
                }
                
                
            } else {
                data = [NSData dataWithContentsOfFile:resourcePath];
            }
#else
        data = [NSData dataWithContentsOfFile:resourcePath];
#endif
    } else {
        data = [NSData dataWithContentsOfFile:resourcePath];
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    if (json) {
        [self processStyleDictionary:json replaceExisting:replaceExisting];
    }
    
    [CATransaction flush];
}

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
            [self processStyleDictionary:json replaceExisting:replaceExisting];
        }
		
        [CATransaction flush];
        if (liveUpdate && !self.liveUpdating) {
            _liveUpdating = YES;
            [self watch:fileName withCallback:^{
                [SVProgressHUD show];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadStylesFromFile:fileName replaceExisting:replaceExisting liveUpdate:liveUpdate];
                });
            }];
        } else {
            _liveUpdating = NO;
        }
    }

}

- (NSArray*)stylesForParentStyle:(NSDictionary*)dictionary
{
    NSMutableArray *tmp = [NSMutableArray new];
    for (NSDictionary *style in dictionary) {
        if ([[style objectForKey:@"isLeaf"] boolValue]) {
            DYNViewStyle *viewStyle = [[DYNViewStyle alloc] initWithDictionary:style];
            [tmp addObject:viewStyle];
        } else {
            
            [tmp addObjectsFromArray:[self stylesForParentStyle:style]];
            
        }
    }
    
    
    return tmp;
}

- (void)processStyleDictionary:(NSDictionary*)json replaceExisting:(BOOL)replaceExisting
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *colors = [json objectForKey:@"colors"];
        NSMutableArray *colorTmp = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dict in colors) {
            [colorTmp addObject:[[DYNColor alloc] initWithDictionary:dict]];
        }
        if (replaceExisting) {
            self.colorVariables = colorTmp;
        } else {
            [self.colorVariables addObjectsFromArray:colorTmp];
        }
        
        NSArray *textStyles = [json objectForKey:@"textStyles"];
        NSMutableArray *textStylesTmp = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dict in textStyles) {
            [textStylesTmp addObject:[[DYNTextStyle alloc] initWithDictionary:dict]];
        }
        if (replaceExisting) {
            self.textStyles = textStylesTmp;
        } else {
            [self.textStyles addObjectsFromArray:textStylesTmp];
        }
        NSArray *styles = [json objectForKey:@"styles"];
        NSMutableArray *viewStyleTmp = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *style in styles) {
            if ([[style objectForKey:@"isLeaf"] boolValue]) {
                DYNViewStyle *viewStyle = [[DYNViewStyle alloc] initWithDictionary:style];
                [viewStyleTmp addObject:viewStyle];
            } else {
                
                [viewStyleTmp addObjectsFromArray:[self stylesForParentStyle:style]];
                
            }
        }
        if (replaceExisting) {
            self.styles = viewStyleTmp;
        } else {
            [self.styles addObjectsFromArray:viewStyleTmp];
        }
        
        NSArray *sliderStyles = [json objectForKey:@"sliderStyles"];
        NSMutableArray *sliderTmp = [NSMutableArray new];
        for (NSDictionary *style in sliderStyles) {
            [sliderTmp addObject:[[DYNSliderStyle alloc] initWithDictionary:style]];
        }
        if (replaceExisting) {
            self.sliderStyles = sliderTmp;
        } else {
            [self.sliderStyles addObjectsFromArray:sliderTmp];
        }
        
        NSArray *imageStyles = [json objectForKey:@"imageStyles"];
        NSMutableArray *imgTemp = [NSMutableArray new];
        for (NSDictionary *style in imageStyles) {
            [imgTemp addObject:[[DYNImageStyle alloc] initWithDictionary:style]];
        }
        
        if (replaceExisting) {
            self.imageStyles = imgTemp;
        } else {
            [self.imageStyles addObjectsFromArray:imgTemp];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendUpdateNotification];
            [SVProgressHUD dismiss];
        });

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
    //[[NSNotificationCenter defaultCenter] postNotificationName:kDYNThemeChangedNotification object:nil];
	
    for (id obj in self.registeredViews) {
        [obj dyn_refreshStyle];
    }
}

@end

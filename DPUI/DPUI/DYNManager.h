//
//  DPStyleManager.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>

@class DYNStyle;
@class DYNTextStyle;
@class DYNViewStyle;
@class DYNSliderStyle;
@class DYNImageStyle;
@interface DYNManager : NSObject

+ (DYNManager *)sharedInstance;

@property (nonatomic, strong) NSMutableArray *styles;
@property (nonatomic, strong) NSMutableArray *sliderStyles;
@property (nonatomic, strong) NSMutableArray *colorVariables;
@property (nonatomic, strong) NSMutableArray *textStyles;
@property (nonatomic, strong) NSMutableArray *imageStyles;

@property (nonatomic, strong) NSDictionary *defaultParameterValues;

- (id)defaultValueForParameter:(NSString *)parameter;

@property (nonatomic, strong) NSArray *registeredViews;

@property (nonatomic, readonly) BOOL liveUpdating;

@property (nonatomic, strong) CIContext *sharedCIContext;

- (DYNSliderStyle*)sliderStyleForName:(NSString*)name;
- (DYNViewStyle *)styleForName:(NSString *)name;
- (UIColor *)colorForVariableName:(NSString *)variableName;
- (DYNTextStyle *)textStyleForName:(NSString *)name;
- (DYNImageStyle*)imageStyleForName:(NSString*)styleName;

- (void)registerView:(id)view;
- (void)unregisterView:(id)view;

- (void)sendUpdateNotification;
/*!
 @method -loadStylesFromFile:replaceExisting:liveUpdate:
 @abstract Loads a .DYN style file
 @param fileName The name, with extension, of the style file. (i.e., "Style.DYN"). When live-updating, this string must be the absolute path to the file (i.e., /Users/dpourhad/Projects/App/Style.DYN)
 @param replaceExisting Replace the existing styles or append to them. Adding duplicate styles results in undefine behavior
 @param liveUpdate When liveUpdate is YES, changes saved to the style file specified in fileName are instantly reflected in the simulator when the app is running (no need to re-compile).
 */
- (void)loadStylesFromFile:(NSString *)fileName replaceExisting:(BOOL)replaceExisting liveUpdate:(BOOL)liveUpdate;
@end

//
//  DPStyleManager.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>

@class DPUIStyle;
@class DPUITextStyle;
@class DPUIViewStyle;
@interface DPUIManager : NSObject

+ (DPUIManager*)sharedInstance;

@property (nonatomic, strong) NSMutableArray *styles;
@property (nonatomic, strong) NSMutableArray *colorVariables;
@property (nonatomic, strong) NSMutableArray *textStyles;

@property (nonatomic, readonly) BOOL liveUpdating; // doesn't work yet

- (DPUIStyle*)styleForName:(NSString*)name;
- (UIColor*)colorForVariableName:(NSString*)variableName;
- (DPUITextStyle*)textStyleForName:(NSString*)name;

- (void)loadStylesFromFile:(NSString*)fileName replaceExisting:(BOOL)replaceExisting liveUpdate:(BOOL)liveUpdate; // live updating doens't work yet!

@end

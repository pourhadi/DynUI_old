#define degreesToRadians(x) (M_PI * (x) / 180.0)

NS_INLINE float oppositeSign(float x) {
    return (x > 0 ? -x : fabs(x));
}



static const void *const kDPViewStyleKey = "_DPViewStyle";
static const void *const kDPTextStyleKey = "_DPTextStyle";
static const void *const kDPViewStyleSizeAppliedKey = "_DPViewStyleSizeApplied";
static const void *const kDPViewStyleAppliedKey = "_DPViewStyleApplied";
static const void *const kDYNRefreshStyleKey = "_DYNRefreshStyleKey";
static const void *const kDYNLayoutSubviewsSwizzled = "_DYNLayoutSubviewsSwizzled";
static const void *const kDYNDeallocSwizzled = "_DYNDeallocSwizzled";
static const void *const kDYNSetFrameSwizzled = "_DYNSetFrameSwizzled";
static const void *const kDYNDidMoveToSuperviewSwizzled = "_DYNDidMoveToSuperview";
static const void *const kDYNStyleParameterKey = "_DYNStyleParameterKey";
static const void *const kDYNDrawQueueKey = "_DYNDrawQueueKey";
static const void *const kDYNTextRectSwizzledKey = @"_DYNTextRectSwizzledKey";
static const void *const kDYNTextFieldTextInsetKey = @"_DYNTextFieldTextInsetKey";
static const void *const kDYNContainerViewKey = @"_DYNContainerViewKey";

static NSString *const kDYNThemeChangedNotification = @"_DYNThemeChangedNotification";


// key strings for DYN files

// DYNBackgroundColor

static NSString *const kDYNGradientAngle = @"gradientAngle";

// DYNColor
static NSString *const kDYNColorKey = @"color";
static NSString *const kDYNColorNameKey = @"colorName";
static NSString *const kDYNColorStringKey = @"colorString";
static NSString *const kDYNColorVarKey = @"colorVar";
static NSString *const kDYNDefinedAtRuntime = @"definedAtRuntime";

// DYNInnerBorderStyle
static NSString *const kDYNBlendModeKey = @"blendMode";
static NSString *const kDYNHeightKey = @"height";

// DYNShadowStyle
static NSString *const kDYNXOffsetKey = @"xOffset";
static NSString *const kDYNYOffsetKey = @"yOffset";
static NSString *const kDYNRadiusKey = @"radius";
static NSString *const kDYNOpacityKey = @"opacity";

// DYNTextStyle
static NSString *const kDYNStyleNameKey = @"styleName";
static NSString *const kDYNFontNameKey = @"fontName";
static NSString *const kDYNFontSizeKey = @"fontSize";
static NSString *const kDYNTextColorKey = @"textColor";
static NSString *const kDYNShadowColorKey = @"shadowColor";
static NSString *const kDYNShadowXOffsetKey = @"shadowXOffset";
static NSString *const kDYNShadowYOffsetKey = @"shadowYOffset";
static NSString *const kDYNAlignmentKey = @"alignment";
static NSString *const kDYNFontSizeTypeKey = @"fontSizeType";
static NSString *const kDYNFontSizeStringKey = @"fontSizeString";

// DYNViewStyle

static NSString *const kDYNNameKey = @"name";
static NSString *const kDYNBackgroundKey = @"background";
static NSString *const kDYNTopInnerBordersKey = @"topInnerBorders";
static NSString *const kDYNBottomInnerBordersKey = @"bottomInnerBorders";
static NSString *const kDYNCornerRadiusKey = @"cornerRadius";
static NSString *const kDYNRoundedCornersKey = @"roundedCorners";
static NSString *const kDYNShadowKey = @"shadow";
static NSString *const kDYNInnerShadowKey = @"innerShadow";
static NSString *const kDYNCanvasBackgroundColorKey = @"canvasBackgroundColor";
static NSString *const kDYNTablCellTitleTextStyleKey = @"tableCellTitleTextStyle";
static NSString *const kDYNTableCellDetailTextStyleKey = @"tableCellDetailTextStyle";
static NSString *const kDYNNavBarTitleTextStyle = @"navBarTitleTextStyle";
static NSString *const kDYNBarButtonItemTextStyle = @"barButtonItemTextStyle";
static NSString *const kDYNBarButtonItemStyleName = @"barButtonItemStyleName";
static NSString *const kDYNStrokeColor = @"strokeColor";
static NSString *const kDYNStrokeWidth = @"strokeWidth";
static NSString *const kDYNControlStyle = @"controlStyle";
static NSString *const kDYNMaskToCornersKey = @"maskToCorners";
static NSString *const kDYNDrawAsynchronouslyKey = @"drawAsynchronously";
static NSString *const kDYNCornerRadiusTypeKey = @"cornerRadiusType";
static NSString *const kDYNSearchFieldStyleNameKey = @"searchFieldStyleName";
static NSString *const kDYNSearchFieldTextStyleNameKey = @"searchFieldTextStyleName";
static NSString *const kDYNTextFieldTextStyleNameKey = @"textFieldTextStyleName";
static NSString *const kDYNSegmentedControlStyleKey = @"segmentedControlStyle";
static NSString *const kDYNSegmentDividerWidthKey = @"segmentDividerWidth";
static NSString *const kDYNSegmentDividerColorKey = @"segmentDividerColor";
static NSString *const kDYNAutomaticallyEmbedScrollViewInContainerViewKey = @"automaticallyEmbedScrollViewInContainerView";

// DYNControlStyle
static NSString *const kDYNNormalTextStyle = @"normalTextStyle";
static NSString *const kDYNHighlightedStyleName = @"highlightedStyleName";
static NSString *const kDYNHighlightedTextStyle = @"highlightedTextStyle";
static NSString *const kDYNSelectedStyleName = @"selectedStyleName";
static NSString *const kDYNSelectedTextStyle = @"selectedTextStyle";
static NSString *const kDYNDisabledStyleName = @"disabledStyleName";
static NSString *const kDYNDisabledTextStyle = @"disabledTextStyle";
static NSString *const kDYNFlippedGradientKey = @"Current - Flipped Gradient";
static NSString *const kDYNHalfOpacityKey = @"Current - 50% Opacity";
static NSString *const kDYNMakeDarkerKey = @"Current - Make Darker";
static NSString *const kDYNMakeLigherKey = @"Current - Make Lighter";

// DYNSliderStyle
static NSString * const kDYNOuterShadowKey = @"outerShadow";
static NSString * const kDYNTrackHeightKey = @"trackHeight";
static NSString * const kDYNThumbHeightKey = @"thumbHeight";
static NSString * const kDYNMinimumTrackInnerShadowKey = @"minimumTrackInnerShadow";
static NSString * const kDYNMaximumTrackInnerShadowKey = @"maximumTrackInnerShadow";
static NSString * const kDYNThumbStyleNameKey = @"thumbStyleName";
static NSString * const kDYNMaxTrackBgColorsKey = @"maxTrackBgColors";
static NSString * const kDYNMinTrackBgColorsKey = @"minTrackBgColors";
#define degreesToRadians(x) (M_PI * (x) / 180.0)

NS_INLINE float oppositeSign(float x) {
	return (x > 0 ? -x : fabs(x));
}

static const void * const kDPViewStyleKey = "_DPViewStyle";
static const void *const kDPTextStyleKey = "_DPTextStyle";
static const void * const kDPViewStyleSizeAppliedKey = "_DPViewStyleSizeApplied";
static const void * const kDPViewStyleAppliedKey = "_DPViewStyleApplied";
static const void * const kDPUIRefreshStyleKey = "_DPUIRefreshStyleKey";
static const void * const kDPUILayoutSubviewsSwizzled = "_DPUILayoutSubviewsSwizzled";
static const void * const kDPUIDeallocSwizzled = "_DPUIDeallocSwizzled";
static const void * const kDPUISetFrameSwizzled = "_DPUISetFrameSwizzled";
static const void * const kDPUIDidMoveToSuperviewSwizzled = "_DPUIDidMoveToSuperview";
static const void * const kDPUIStyleParameterKey = @"_DPUIStyleParameterKey";

static NSString * const kDPUIThemeChangedNotification = @"_DPUIThemeChangedNotification";


// key strings for dpui files


// DPUIColor
static NSString * const kDPUIColorKey = @"color";
static NSString * const kDPUIColorNameKey = @"colorName";
static NSString * const kDPUIColorStringKey = @"colorString";
static NSString * const kDPUIColorVarKey = @"colorVar";
static NSString * const kDPUIDefinedAtRuntime = @"definedAtRuntime";

// DPUIInnerBorderStyle
static NSString * const kDPUIBlendModeKey = @"blendMode";
static NSString * const kDPUIHeightKey = @"height";

// DPUIShadowStyle
static NSString * const kDPUIXOffsetKey = @"xOffset";
static NSString * const kDPUIYOffsetKey = @"yOffset";
static NSString * const kDPUIRadiusKey = @"radius";
static NSString * const	kDPUIOpacityKey = @"opacity";

// DPUITextStyle
static NSString * const kDPUIStyleNameKey = @"styleName";
static NSString * const kDPUIFontNameKey = @"fontName";
static NSString * const kDPUIFontSizeKey = @"fontSize";
static NSString * const kDPUITextColorKey = @"textColor";
static NSString * const kDPUIShadowColorKey = @"shadowColor";
static NSString * const kDPUIShadowXOffsetKey = @"shadowXOffset";
static NSString * const kDPUIShadowYOffsetKey = @"shadowYOffset";
static NSString * const kDPUIAlignmentKey = @"alignment";

// DPUIViewStyle

static NSString * const kDPUINameKey = @"name";
static NSString * const kDPUIBackgroundKey = @"background";
static NSString * const kDPUITopInnerBordersKey = @"topInnerBorders";
static NSString * const kDPUIBottomInnerBordersKey = @"bottomInnerBorders";
static NSString * const kDPUICornerRadiusKey = @"cornerRadius";
static NSString * const kDPUIRoundedCornersKey = @"roundedCorners";
static NSString * const kDPUIShadowKey = @"shadow";
static NSString * const kDPUIInnerShadowKey = @"innerShadow";
static NSString * const kDPUICanvasBackgroundColorKey = @"canvasBackgroundColor";
static NSString * const kDPUITablCellTitleTextStyleKey = @"tableCellTitleTextStyle";
static NSString * const kDPUITableCellDetailTextStyleKey = @"tableCellDetailTextStyle";
static NSString * const kDPUINavBarTitleTextStyle = @"navBarTitleTextStyle";
static NSString * const kDPUIBarButtonItemTextStyle = @"barButtonItemTextStyle";
static NSString * const kDPUIBarButtonItemStyleName = @"barButtonItemStyleName";
static NSString * const kDPUIStrokeColor = @"strokeColor";
static NSString * const kDPUIStrokeWidth = @"strokeWidth";
static NSString * const kDPUIControlStyle = @"controlStyle";
static NSString * const kDPUIMaskToCornersKey = @"maskToCorners";

// DPUIControlStyle
static NSString * const kDPUINormalTextStyle = @"normalTextStyle";
static NSString * const kDPUIHighlightedStyleName = @"highlightedStyleName";
static NSString * const kDPUIHighlightedTextStyle = @"highlightedTextStyle";
static NSString * const kDPUISelectedStyleName = @"selectedStyleName";
static NSString * const kDPUISelectedTextStyle = @"selectedTextStyle";
static NSString * const kDPUIDisabledStyleName = @"disabledStyleName";
static NSString * const kDPUIDisabledTextStyle = @"disabledTextStyle";
static NSString * const kDPUIFlippedGradientKey = @"Current - Flipped Gradient";
static NSString * const kDPUIHalfOpacityKey = @"Current - 50% Opacity";
static NSString * const kDPUIMakeDarkerKey = @"Current - Make Darker";
static NSString * const kDPUIMakeLigherKey = @"Current - Make Lighter";
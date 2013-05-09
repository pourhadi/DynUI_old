#define degreesToRadians(x) (M_PI * (x) / 180.0)

static const void * const kDPViewStyleKey = "_DPViewStyle";
static const void *const kDPTextStyleKey = "_DPTextStyle";
static const void * const kDPViewStyleSizeAppliedKey = "_DPViewStyleSizeApplied";
static const void * const kDPViewStyleAppliedKey = "_DPViewStyleApplied";
static const void * const kDPUIRefreshStyleKey = "_DPUIRefreshStyleKey";
static const void * const kDPUILayoutSubviewsSwizzled = "_DPUILayoutSubviewsSwizzled";
static const void * const kDPUIDeallocSwizzled = "_DPUIDeallocSwizzled";
static NSString * const kDPUIThemeChangedNotification = @"_DPUIThemeChangedNotification";


// key strings for dpui files

// DPUIColor
static NSString * const kDPUIColorKey = @"color";
static NSString * const kDPUIColorNameKey = @"colorName";
static NSString * const kDPUIColorStringKey = @"colorString";

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
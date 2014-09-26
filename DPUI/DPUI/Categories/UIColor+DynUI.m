//
//  UIColor+DPStyle.m
//  TheQ
//
//  Created by Dan Pourhadi on 5/2/13.
//
//

#import "UIColor+DynUI.h"
#import "DYNDefines.h"
#import "DynUI.h"
@implementation UIColor (DynUI)

+(NSString *)hexValuesFromUIColor:(UIColor *)color {
    
    if (!color) {
        return nil;
    }
    
    if (color == [UIColor whiteColor]) {
        // Special case, as white doesn't fall into the RGB color space
        return @"ffffff";
    }
    
    CGFloat red;
    CGFloat blue;
    CGFloat green;
    CGFloat alpha;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    int redDec = (int)(red * 255);
    int greenDec = (int)(green * 255);
    int blueDec = (int)(blue * 255);
    
    NSString *returnString = [NSString stringWithFormat:@"%02x%02x%02x", (unsigned int)redDec, (unsigned int)greenDec, (unsigned int)blueDec];
    
    return returnString;
    
}


+ (UIColor *)colorForVariable:(NSString *)variable {
    return [[DYNManager sharedInstance] colorForVariableName:variable];
}

+ (UIColor *)colorFromHex:(NSString *)hex {
    return [UIColor colorWithHexString:hex];
}

+ (UIColor *)colorFromCIString:(NSString *)string {
    CIColor *ciColor = [CIColor colorWithString:string];
    return [UIColor colorWithCIColor:ciColor];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue  = [self colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red   = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue  = [self colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue  = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red   = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            [NSException raise:@"Invalid color value" format:@"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CIColor *)uiColorToCIColor:(UIColor *)color {
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return [CIColor colorWithRed:red green:green blue:blue];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

- (UIColor*)lighterColor
{
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.3, 1.0)
                               green:MIN(g + 0.3, 1.0)
                                blue:MIN(b + 0.3, 1.0)
                               alpha:a];
    return nil;

}

- (UIColor*)darkerColor
{
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.3, 0)
                               green:MAX(g - 0.3, 0)
                                blue:MAX(b - 0.3, 0)
                               alpha:a];
    return nil;
    
}

- (UIColor*)lightestColor
{
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a]){
        CGFloat max = MAX(b, MAX(r, g));
        CGFloat diff = MAX(max,0.8) - max;
        return [UIColor colorWithRed:MIN(r + diff, 1.0)
                               green:MIN(g + diff, 1.0)
                                blue:MIN(b + diff, 1.0)
                               alpha:a];
    }
    return nil;
    
   
}
- (UIColor*)darkestColor
{
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a]){
        CGFloat min = MIN(b, MIN(r, g));
        CGFloat diff = MIN(min, 0.15);
        return [UIColor colorWithRed:MAX(r - diff, 0)
                               green:MAX(g - diff, 0)
                                blue:MAX(b - diff, 0)
                               alpha:a];
    }
    return nil;
}

@end

#import <Foundation/Foundation.h>

@interface chyyAppConstants : NSObject

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define COLOR_NAV_BAR_BG UIColorFromRGB(0x75A283)
#define COLOR_NAV_BAR_BUTTON [UIColor whiteColor]
#define COLOR_NAV_BAR_TITLE [UIColor whiteColor]
#define COLOR_NAV_BAR_TITLE_SHADOW UIColorFromRGBA(0x5F9C74, 0.9)

#define COLOR_TAB_BAR_BG UIColorFromRGB(0x4C4C4C)
#define COLOR_TAB_BAR_ITEM [UIColor whiteColor]

#define COLOR_TALBE_ODD UIColorFromRGB(0xE9E9DE)
#define COLOR_TALBE_EVEN UIColorFromRGB(0xCECDC1)

@end

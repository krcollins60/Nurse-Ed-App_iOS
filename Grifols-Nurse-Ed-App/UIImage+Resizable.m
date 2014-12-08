
#import "UIImage+Resizable.h"

@implementation UIImage (Resizable)

+ (UIImage*) resizableBackgroundImage {
    if (![GNAppDelegate isIpad]) {
        UIImage* resizableImage = [UIImage imageNamed:@"picker_background_iPhone"];
        return [resizableImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 47, 21, 47)];
    } else {
        UIImage* resizableImage = [UIImage imageNamed:@"picker_background_iPad"];
        return [resizableImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 47, 39, 47)];
    }
}

@end

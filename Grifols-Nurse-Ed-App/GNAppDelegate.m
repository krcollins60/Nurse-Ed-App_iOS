
#import "GNAppDelegate.h"

@implementation GNAppDelegate

+ (BOOL) isIpad
{
    static BOOL isIpad;
    static dispatch_once_t onesToken;
    dispatch_once(&onesToken, ^{
        isIpad = [[UIDevice currentDevice] respondsToSelector: @selector(userInterfaceIdiom)];
        isIpad = isIpad ? [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad : NO;
    });
    return isIpad;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"dd2dae7ba5b2fa760ea15731863d19a4_MTUwNzA2MjAxMi0xMS0wMiAxNDoyMDo1Ni42ODcyMzA"];
    [_window makeKeyAndVisible];
    return YES;
}

@end

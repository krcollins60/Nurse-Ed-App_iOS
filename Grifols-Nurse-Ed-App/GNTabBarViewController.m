
#import "GNTabBarViewController.h"
#import "GNGrifolsNurse+Private.h"
#import "UIView+Nib.h"
#import "GNTabBar.h"
#import "GNAppDelegate.h"

#define TAB_BAR_HEIGHT 76

@interface GNTabBarViewController ()

@end

@implementation GNTabBarViewController {
    GNTabBar* _customTabBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([GNAppDelegate isIpad]) {
        [self.tabBar removeFromSuperview];
        
        UIView* view = self.view;
        NSAssert(1 == view.subviews.count, @"???");
        UIView* contentView = [view.subviews objectAtIndex:0];
        [contentView setFrame:(CGRect) {
            .size = {
                .width = view.frame.size.width,
                .height = view.frame.size.height - TAB_BAR_HEIGHT
            }
        }];
        
        _customTabBar = [GNTabBar viewWithNibNamed:@"GNTabBar_iPad"];
        [_customTabBar setFrame:(CGRect) {
            .origin = {
                .x = 0,
                .y = view.frame.size.height - TAB_BAR_HEIGHT
            },
            .size = {
                .width = view.frame.size.width,
                .height = TAB_BAR_HEIGHT
            }
        }];
        [self.view addSubview:_customTabBar];
        __weak GNTabBarViewController* tabBarViewController = self;
        [_customTabBar setDidSelectTab:^(NSInteger index) {
            [tabBarViewController setSelectedIndex:index];
        }];
    }
    
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSString* submitterName = [preferences objectForKey:GNSubmitterName] ?: @"";
    NSString* submitterEmail = [preferences objectForKey:GNSubmitterEmail] ?: @"";
    
    [self _setSelectedIndex:([submitterName length] <= 0 || [submitterEmail length] <= 0) ? 1 : 0];
}

- (void) _setSelectedIndex:(NSInteger)index
{
    [self setSelectedIndex:index];
    if ([GNAppDelegate isIpad]) {
        [[_customTabBar tabButton1] setSelected:index == 0];
        [[_customTabBar tabButton2] setSelected:index == 1];
    }
}

@end

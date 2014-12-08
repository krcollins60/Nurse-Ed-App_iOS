
#import "GNTabBar.h"

@implementation GNTabBar {
    NSArray* _tabButtons;
}

- (void) awakeFromNib
{
    _tabButtons = @[
    self.tabButton1,
    self.tabButton2,
    ];
}

- (IBAction) showSelectedTab:(UIButton*)selectedButton
{
    if (self.didSelectTab) {
        NSUInteger index = [_tabButtons indexOfObject:selectedButton];
        NSAssert(NSNotFound != index, @"???");
        self.didSelectTab(index);
    }
    
    for (UIButton* tabButton in _tabButtons) {
        [tabButton setSelected:tabButton == selectedButton];
    }
}

@end

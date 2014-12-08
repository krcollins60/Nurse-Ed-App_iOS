
#import "GNTextFieldWithInset.h"
#import "GNAppDelegate.h"

@implementation GNTextFieldWithInset

- (CGRect)_insetBoundsWithBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 7, bounds.origin.y, bounds.size.width - ([GNAppDelegate isIpad] ? 26 : 17) - 7, bounds.size.height);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [self _insetBoundsWithBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self _insetBoundsWithBounds:bounds];
}

@end


#import "UIView+Nib.h"

@implementation UIView (Nib)

+ (id) viewWithNibNamed:(NSString*)nibNameOrNil
{
    NSString* nibName = nibNameOrNil ?: NSStringFromClass(self);
    NSArray* topLevelObjects = [[UINib nibWithNibName:nibName bundle:nil] instantiateWithOwner:nil options:nil];
    NSAssert(topLevelObjects.count == 1, @"???");
    id view = [topLevelObjects objectAtIndex:0];
    NSAssert([view isKindOfClass:self], @"???");
    return view;
}


@end

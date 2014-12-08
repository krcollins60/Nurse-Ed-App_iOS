
#import "GAKeyboardAccessoryView.h"

@implementation caKeyboardAccessoryView

@synthesize delegate = _delegate;
@synthesize mainView = _mainView;
@synthesize segmentedControl = _segmentedControl;

#pragma mark - Initialization

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (nil != (self = [super initWithCoder:aDecoder])) {
        [self _commonInitForCAAccessoryView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (nil != (self = [super initWithFrame:frame])) {
        [self _commonInitForCAAccessoryView];
    }
    return self;
}

- (void) _commonInitForCAAccessoryView
{
    [[UINib nibWithNibName:@"caKeyboardAccessoryView" bundle:nil] instantiateWithOwner:self options:nil];
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_mainView];
}

- (void) disablePreviousButton:(BOOL)disable
{
    [_segmentedControl setEnabled:!disable forSegmentAtIndex:0];
}

- (void) disableNextButton:(BOOL)disable
{
    [_segmentedControl setEnabled:!disable forSegmentAtIndex:1];
}

- (void) resetSegmentedControlSelection
{
    [_segmentedControl setSelectedSegmentIndex:-1];
}

- (IBAction) segmentedControlValueChanged:(id)sender
{
    if (_delegate){
        switch ([(UISegmentedControl*)sender selectedSegmentIndex]) {
            case 0:
                [_delegate previousButtonPressed];
                break;
            case 1:
                [_delegate nextButtonPressed];
                break;
            default:
                break;
        }
    }
}

- (IBAction) doneButtonPressed:(id)sender
{
    [_delegate keyboardOrPickerDoneButtonPressed];
}


@end

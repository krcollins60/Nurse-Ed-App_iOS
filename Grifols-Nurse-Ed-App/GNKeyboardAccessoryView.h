
@protocol caKeyboardAccessoryDelegate <NSObject>

- (void) keyboardOrPickerDoneButtonPressed;
- (void) previousButtonPressed;
- (void) nextButtonPressed;

@end

@interface caKeyboardAccessoryView : UIView

- (IBAction) segmentedControlValueChanged:(id)sender;
- (IBAction) doneButtonPressed:(id)sender;

@property (nonatomic, strong) IBOutlet NSObject<caKeyboardAccessoryDelegate> *delegate;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (void) disablePreviousButton:(BOOL)disable;
- (void) disableNextButton:(BOOL)disable;
- (void) resetSegmentedControlSelection;

@end

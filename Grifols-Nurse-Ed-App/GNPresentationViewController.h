
#import "GNAppDelegate.h"
#import "GNPickerViewController.h"
#import "ALPickerView.h"
#import "GNTextFieldWithInset.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface GNPresentationViewController : GNPickerViewController <ALPickerViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *organizationTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) IBOutlet GNTextFieldWithInset *stateTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *presentationDateTextField;
@property (strong, nonatomic) IBOutlet GNTextFieldWithInset *requestTextField;
@property (strong, nonatomic) IBOutlet UITextField *audienceTextField;
@property (strong, nonatomic) IBOutlet GNTextFieldWithInset *presentationTopicTextField;

- (IBAction)submitButtonPressed:(id)sender;
- (NSDateFormatter*) dateFormatter;

@property (strong, nonatomic) IBOutlet UIPickerView *requestPresentationPicker;
@property (strong, nonatomic) IBOutlet caPickerView* requestPresentationPickerView;

@property (strong, nonatomic) IBOutlet UIPickerView *statePicker;
@property (strong, nonatomic) IBOutlet caPickerView *statePickerView;

@property (strong, nonatomic) IBOutlet caPickerView *multipickerViewContainer;

@property (strong, nonatomic) IBOutlet caPickerView *datePickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;


@property (strong, nonatomic) IBOutlet UITabBarItem *presentationTapBarItem;

@end

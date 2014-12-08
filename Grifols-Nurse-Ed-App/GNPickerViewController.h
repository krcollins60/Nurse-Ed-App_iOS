
#import "GNAppDelegate.h"
#import "caKeyboardAccessoryView.h"
#import "caPickerView.h"
#import "GNPickerData.h"

@interface GNPickerViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, caKeyboardAccessoryDelegate>

@property (strong, nonatomic) IBOutlet UIView *topTitleViewController;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) caPickerView* selectedActivePickerView;
@property (strong, nonatomic) UITextField* selectedActiveTextField;
@property (strong, nonatomic) UITextView* selectedActiveTextView;

@property (strong, nonatomic) NSArray* viewsInOrder;
@property (strong, nonatomic) NSArray* viewsWithOwnAccessoryView;

- (caKeyboardAccessoryView*) addAccessoryViewToView:(id)view;
- (void) handleSelectedTextField:(UITextField*)textField;
- (void) selectAdjacentViewWithDirection:(int)direction;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

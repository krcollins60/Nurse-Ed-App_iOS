
typedef enum {
    GNDefaultDeptTeamMode,
    GNOtherDeptTeamMode
} GNDeptTeamViewMode;

#import "GNPickerViewController.h"
#import "GNGrifolsNurse+Private.h"
#import "UIImage+Resizable.h"

@interface GNSubmitterViewController : GNPickerViewController

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *deptTeamTextField;
@property (strong, nonatomic) IBOutlet UITextField *otherDeptTeamTextField;
@property (strong, nonatomic) IBOutlet UITextField *regionNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *territoryNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *rsdNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *rsdEmailTextField;

- (IBAction)submitterButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIPickerView *deptTeamPicker;
@property (strong, nonatomic) IBOutlet caPickerView *deptTeamPickerView;

@property (strong, nonatomic) IBOutlet UITabBarItem *submitterTapBarItem;


@end

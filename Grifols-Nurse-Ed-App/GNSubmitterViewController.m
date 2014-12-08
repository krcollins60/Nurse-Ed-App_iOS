
#import "GNSubmitterViewController.h"
#import "GNGrifolsNurse+Private.h"

@interface GNSubmitterViewController ()

@end

@implementation GNSubmitterViewController {
    NSArray* _deptTeamNames;
    GNDeptTeamViewMode _deptTeamViewMode;
    NSArray* _fields;
    NSArray* _fieldKeys;
}

@synthesize nameTextField = _nameTextField;
@synthesize emailTextField = _emailTextField;
@synthesize phoneTextField = _phoneTextField;
@synthesize deptTeamTextField = _deptTeamTextField;
@synthesize otherDeptTeamTextField = _otherDeptTeamTextField;
@synthesize regionNumberTextField = _regionNumberTextField;
@synthesize territoryNumberTextField = _territoryNumberTextField;
@synthesize rsdNameTextField = _rsdNameTextField;
@synthesize rsdEmailTextField = _rsdEmailTextField;

@synthesize deptTeamPicker = _deptTeamPicker;
@synthesize deptTeamPickerView = _deptTeamPickerView;

@synthesize submitterTapBarItem = _submitterTapBarItem;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self scrollView] setContentSize:(CGSizeMake(320, 421))];
    
    if ([GNAppDelegate isIpad]) {
        [_phoneTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [_phoneTextField setDelegate:self];
    }
    
    [self setViewsInOrder:[NSArray arrayWithObjects:
                           _nameTextField,
                           _emailTextField,
                           _phoneTextField,
                           _deptTeamTextField,
                           _otherDeptTeamTextField,
                           _regionNumberTextField,
                           _territoryNumberTextField,
                           _rsdNameTextField,
                           _rsdEmailTextField, nil]];
    
    _fields = [NSArray arrayWithObjects:
               [self nameTextField],
               [self emailTextField],
               [self phoneTextField],
               [self deptTeamTextField],
               [self otherDeptTeamTextField],
               [self regionNumberTextField],
               [self territoryNumberTextField],
               [self rsdNameTextField],
               [self rsdEmailTextField], nil];
    
    _fieldKeys = [NSArray arrayWithObjects:
                  GNSubmitterName,
                  GNSubmitterEmail,
                  GNSubmitterPhone,
                  GNSubmitterDepartment,
                  GNSubmitterOtherDepartment,
                  GNSubmitterRegion,
                  GNSubmitterTerritory,
                  GNSubmitterRSDName,
                  GNSubmitterRSDEmail, nil];
    
    [self setViewsWithOwnAccessoryView:[NSArray arrayWithObject:_deptTeamTextField]];
    
    _deptTeamNames = [GNPickerData deptTeamNames];
    
    _deptTeamViewMode = GNDefaultDeptTeamMode;
    for (int i = 0; i < [[self viewsInOrder] count]; i++) {
        if (![[self viewsWithOwnAccessoryView] containsObject:[[self viewsInOrder] objectAtIndex:i]]) {
            [[[self viewsInOrder] objectAtIndex:i] setBorderStyle:UITextBorderStyleRoundedRect];
        }
    }

    [_submitterTapBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor grayColor], UITextAttributeTextColor, nil]
                                            forState:UIControlStateNormal];
    [_submitterTapBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor colorWithRed:51.0/255.0 green:204.0/255.0 blue:255.0/255.0 alpha:1.0], UITextAttributeTextColor, nil]
                                            forState:UIControlStateSelected];
    
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    for (UITextField* field in _fields) {
        NSString* fieldTextValue = [preferences stringForKey:[_fieldKeys objectAtIndex:[_fields indexOfObject:field]]];
        if (field == [self deptTeamTextField]) {
            [self _setDeptTeamName:fieldTextValue animated:NO];
        } else {
            [field setText:fieldTextValue];
        }
    }
    
    [[self deptTeamTextField] setText:[_deptTeamNames objectAtIndex:0]];
}

- (void) handleSelectedTextField:(UITextField*)textField {
    if (textField == _deptTeamTextField) {
        [self setSelectedActivePickerView:_deptTeamPickerView];
        [_deptTeamTextField setBackground:[UIImage resizableBackgroundImage]];
        int index = [_deptTeamNames indexOfObject:[_deptTeamTextField text]];
        if (index != NSNotFound) {
            [_deptTeamPicker selectRow:index inComponent:0 animated:NO];
        }
    } else {
        [super handleSelectedTextField:textField];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _phoneTextField) {
        return [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setNameTextField:nil];
    [self setEmailTextField:nil];
    [self setPhoneTextField:nil];
    [self setDeptTeamTextField:nil];
    [self setRegionNumberTextField:nil];
    [self setTerritoryNumberTextField:nil];
    [self setRsdNameTextField:nil];
    [self setRsdEmailTextField:nil];
    [self setViewsInOrder:nil];
    [self setDeptTeamPicker:nil];
    [self setDeptTeamPickerView:nil];
    [self setSubmitterTapBarItem:nil];
    [self setOtherDeptTeamTextField:nil];
    [super viewDidUnload];
}

- (void) resetScrollOffsetIfNeeded
{
    CGFloat currentVerticalOffset = [[self scrollView] contentOffset].y;
    
    if (![GNAppDelegate isIpad]) {
        if (currentVerticalOffset > 54) {
            [[self scrollView] setContentOffset:CGPointMake(0, 54) animated:YES];
        }
    }
    if (currentVerticalOffset < 0) {
        [[self scrollView] setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - UIPickerViewDelegate methods

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _deptTeamPicker) {
        return [_deptTeamNames objectAtIndex:row];
    } 
    return @"";
}

- (CGRect) _departmentFieldFrameForAnimationIn:(BOOL)animateIn
{
    return [GNAppDelegate isIpad] ? CGRectMake(254, 283, animateIn ? 186 : 291, 39) : CGRectMake(116, 168, animateIn ? 85 : 147, 21);
}

- (CGRect) _departmentOtherFieldFrameForAnimationIn:(BOOL)animateIn
{
    return [GNAppDelegate isIpad] ? CGRectMake(animateIn ? 449 : 613, 283, 194, 39) : CGRectMake(animateIn ? 203 : 271, 168, 97, 21);
}

- (void) setDeptTeamViewMode:(GNDeptTeamViewMode)mode animated:(BOOL)animated
{
    if (_deptTeamViewMode != mode) {
        BOOL animateOtherFieldIn = mode == GNOtherDeptTeamMode;
        BOOL animateOtherFieldOut = _deptTeamViewMode == GNOtherDeptTeamMode;
        
        if (animateOtherFieldIn || animateOtherFieldOut) {
            [_otherDeptTeamTextField setHidden:NO];
            [UIView animateWithDuration:animated ? 0.3 : 0.0 animations:^{
                [_deptTeamTextField setFrame:[self _departmentFieldFrameForAnimationIn:animateOtherFieldIn]];
                [_otherDeptTeamTextField setFrame:[self _departmentOtherFieldFrameForAnimationIn:animateOtherFieldIn]];
            } completion:^(BOOL finished) {
                if (finished && animateOtherFieldOut) {
                    [_otherDeptTeamTextField setText:@""];
                    [_otherDeptTeamTextField setHidden:YES];
                }
            }];
        }
        _deptTeamViewMode = mode;
    }
}

- (void) _setDeptTeamName:(NSString*)deptTeamName
{
    [self _setDeptTeamName:deptTeamName animated:YES];
}

- (void) _setDeptTeamName:(NSString*)deptTeamName animated:(BOOL)animated
{
    [self setDeptTeamViewMode:[deptTeamName isEqualToString:GNOther] ? GNOtherDeptTeamMode : GNDefaultDeptTeamMode animated:animated];
    [_deptTeamTextField setText:deptTeamName];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _deptTeamPicker) {
        [self _setDeptTeamName:[_deptTeamNames objectAtIndex:[_deptTeamPicker selectedRowInComponent:0]]];
    }
}

#pragma mark - UIPickerViewDataSource methods

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _deptTeamPicker) {
        return [_deptTeamNames count];
    } 
    return 0;
}

#pragma mark - caKeyboardAccessoryDelegate

- (void) keyboardOrPickerDoneButtonPressed
{
    if ([self selectedActiveTextField] == _deptTeamTextField) {
        [_deptTeamTextField setText:[_deptTeamNames objectAtIndex:[_deptTeamPicker selectedRowInComponent:0]]];
        [self setSelectedActivePickerView:nil];
    } 
    [super keyboardOrPickerDoneButtonPressed];
}

- (void) previousButtonPressed
{
    int nextIndexIncrement = -1;
    if ([self selectedActiveTextField] == _regionNumberTextField && ![[_deptTeamTextField text] isEqualToString:caOther]) {
        nextIndexIncrement = -2;
    }
    [self selectAdjacentViewWithDirection:nextIndexIncrement];
}

- (void) nextButtonPressed
{
    int nextIndexIncrement = 1;
    if ([self selectedActiveTextField] == _deptTeamTextField && ![[_deptTeamTextField text] isEqualToString:caOther]) {
        nextIndexIncrement = 2;
    }
    [self selectAdjacentViewWithDirection:nextIndexIncrement];
}

- (IBAction)submitterButtonPressed:(id)sender {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    for (UITextField* field in _fields) {
        [preferences setObject:[field text] forKey:[_fieldKeys objectAtIndex:[_fields indexOfObject:field]]];
    }
    
    [preferences synchronize];
    
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"Your information has been saved."
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end


#import "GNPresentationViewController.h"
#import "GNPickerData.h"
#import "UIAlertView+Error.h"
#import "GNGrifolsNurse+Private.h"
#import "GNMailComposerHelper.h"

@interface GNPresentationViewController ()

@end

@implementation GNPresentationViewController {
    NSArray* _requestPresentationNames;
    NSArray* _stateNames;
    NSArray* _presentationTopicNames;
	NSMutableDictionary* _selectionTopicNames;
	ALPickerView* _multiPickerView;
}

@synthesize nameTextField = _nameTextField;
@synthesize organizationTextField = _organizationTextField;
@synthesize addressTextField = _addressTextField;
@synthesize cityTextField = _cityTextField;
@synthesize stateTextField = _stateTextField;
@synthesize phoneTextField = _phoneTextField;
@synthesize emailTextField = _emailTextField;
@synthesize presentationDateTextField = _presentationDateTextField;
@synthesize requestTextField = _requestTextField;
@synthesize audienceTextField = _audienceTextField;
@synthesize presentationTopicTextField = _presentationTopicTextField;

@synthesize requestPresentationPicker = _requestPresentationPicker;
@synthesize requestPresentationPickerView = _requestPresentationPickerView;

@synthesize statePicker = _statePicker;
@synthesize statePickerView = _statePickerView;

@synthesize presentationTapBarItem = _presentationTapBarItem;

@synthesize multipickerViewContainer = _multipickerViewContainer;

@synthesize datePicker = _datePicker;
@synthesize datePickerView = _datePickerView;

- (NSDateFormatter*) dateFormatter
{
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    });
    return dateFormatter;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _phoneTextField) {
        return [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([GNAppDelegate isIpad]) {
        [_phoneTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [_phoneTextField setDelegate:self];
    }
    
    _requestPresentationNames = [GNPickerData requestPresentationNames];
    _stateNames = [GNPickerData stateNames];
    _presentationTopicNames = [GNPickerData availablePresentationsNames];
    
    _selectionTopicNames = [[NSMutableDictionary alloc] init];
    for (NSString *key in _presentationTopicNames) {
        [_selectionTopicNames setObject:[NSNumber numberWithBool:NO] forKey:key];
    }
    _multiPickerView = [[ALPickerView alloc] initWithFrame:CGRectMake(0, 44, 240, 0)];
    [_multiPickerView setPickerViewDelegate:self];
    [_multipickerViewContainer addSubview:_multiPickerView];
    
    [[self stateTextField] setText:[_stateNames objectAtIndex:0]];
    [[self requestTextField] setText:[_requestPresentationNames objectAtIndex:0]];
    
    if ([GNAppDelegate isIpad]) {
        [[self scrollView] setContentSize:(CGSizeMake(768, 836))];
    } else {
        [[self scrollView] setContentSize:(CGSizeMake(320, 526))];
    }
    
    [self setViewsInOrder:[NSArray arrayWithObjects:
                           _nameTextField,
                           _organizationTextField,
                           _addressTextField,
                           _cityTextField,
                           _stateTextField,
                           _phoneTextField,
                           _emailTextField,
                           _presentationDateTextField,
                           _requestTextField,
                           _audienceTextField,
                           _presentationTopicTextField, nil]];
    
    [self setViewsWithOwnAccessoryView:[NSArray arrayWithObjects:
                                        _stateTextField,
                                        _requestTextField,
                                        _presentationTopicTextField, nil]];
    
    for (int i = 0; i < [[self viewsInOrder] count]; i++) {
        if (![[self viewsWithOwnAccessoryView] containsObject:[[self viewsInOrder] objectAtIndex:i]]) {
            [[[self viewsInOrder] objectAtIndex:i] setBorderStyle:UITextBorderStyleRoundedRect];
        }
    }
    
    [_presentationTapBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIColor grayColor], UITextAttributeTextColor, nil]
                                        forState:UIControlStateNormal];
    [_presentationTapBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIColor colorWithRed:51.0/255.0 green:204.0/255.0 blue:255.0/255.0 alpha:1.0], UITextAttributeTextColor, nil]
                                        forState:UIControlStateSelected];
    
    [[_multipickerViewContainer accessoryView] disableNextButton:YES];
    
    [_datePicker setMinimumDate:[[NSDate alloc] initWithTimeIntervalSinceNow:(NSTimeInterval)0]];
    [_datePicker addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark -
#pragma mark ALPickerView delegate methods

- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView
{
	return [_presentationTopicNames count];
}

- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row
{
	return [_presentationTopicNames objectAtIndex:row];
}

- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row {
	return [[_selectionTopicNames objectForKey:[_presentationTopicNames objectAtIndex:row]] boolValue];
}

- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row
{
	[_selectionTopicNames setObject:[NSNumber numberWithBool:YES] forKey:[_presentationTopicNames objectAtIndex:row]];
    [_presentationTopicTextField setText:[self _labelForMutliselectorView]];
}

- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row
{
	[_selectionTopicNames setObject:[NSNumber numberWithBool:NO] forKey:[_presentationTopicNames objectAtIndex:row]];
    [_presentationTopicTextField setText:[self _labelForMutliselectorView]];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setNameTextField:nil];
    [self setOrganizationTextField:nil];
    [self setAddressTextField:nil];
    [self setCityTextField:nil];
    [self setPhoneTextField:nil];
    [self setEmailTextField:nil];
    [self setPresentationDateTextField:nil];
    [self setRequestTextField:nil];
    [self setAudienceTextField:nil];
    [self setPresentationTopicTextField:nil];
    [self setViewsInOrder:nil];
    [self setRequestPresentationPicker:nil];
    [self setRequestPresentationPickerView:nil];
    [self setPresentationTapBarItem:nil];
    [self setStatePicker:nil];
    [self setStatePickerView:nil];
    [self setStateTextField:nil];
    [self setMultipickerViewContainer:nil];
    [self setDatePickerView:nil];
    [self setDatePicker:nil];
    [super viewDidUnload];
}

- (void) resetScrollOffsetIfNeeded
{
    CGFloat currentVerticalOffset = [[self scrollView] contentOffset].y;
    
    if ([GNAppDelegate isIpad]) {
        if (currentVerticalOffset > 59) {
            [[self scrollView] setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    else {
        if (currentVerticalOffset > 158) {
            [[self scrollView] setContentOffset:CGPointMake(0, 158) animated:YES];
        }
    }
    if (currentVerticalOffset < 0) {
        [[self scrollView] setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
- (void) handleSelectedTextField:(UITextField*)textField
{
    if (textField == _presentationDateTextField) {
        [self setSelectedActivePickerView:_datePickerView];
        NSString* currentDateString = [_presentationDateTextField text];
        if (currentDateString && [currentDateString length]) {
            [_datePicker setDate:[[self dateFormatter] dateFromString:currentDateString]];
        }
    } else if (textField == _presentationTopicTextField) {
        [self setSelectedActivePickerView:_multipickerViewContainer];
    } else if (textField == _requestTextField) {
        [self setSelectedActivePickerView:_requestPresentationPickerView];
        int index = [_requestPresentationNames indexOfObject:[_requestTextField text]];
        if (index != NSNotFound) {
            [_requestPresentationPicker selectRow:index inComponent:0 animated:NO];
        } 
    } else if (textField == _stateTextField) {
        [self setSelectedActivePickerView:_statePickerView];
        int index = [_stateNames indexOfObject:[_stateTextField text]];
        if (index != NSNotFound) {
            [_statePicker selectRow:index inComponent:0 animated:NO];
        }
    } else {
        [super handleSelectedTextField:textField];
    }
}

#pragma mark - caKeyboardAccessoryDelegate

- (NSString*) _labelForMutliselectorView
{
    NSString* label = nil;
    for (NSString* key in _selectionTopicNames) {
        if ([[_selectionTopicNames objectForKey:key] boolValue]) {
            if (label) {
                return @"Multiple selected rows";
            } else {
                label = key;
            }
        }
    }
    return label;
}

- (void) keyboardOrPickerDoneButtonPressed
{
    if ([self selectedActiveTextField] == _stateTextField) {
        [_stateTextField setText:[_stateNames objectAtIndex:[_statePicker selectedRowInComponent:0]]];
    } else if ([self selectedActiveTextField] == _requestTextField) {
        [_requestTextField setText:[_requestPresentationNames objectAtIndex:[_requestPresentationPicker selectedRowInComponent:0]]];
    } else if ([self selectedActiveTextField] == _presentationTopicTextField) {
        [_presentationTopicTextField setText:[self _labelForMutliselectorView]];
    } else if ([self selectedActiveTextField] == _presentationDateTextField) {
        [_presentationDateTextField setText:[[self dateFormatter] stringFromDate:[_datePicker date]]];
    }
    [self setSelectedActivePickerView:nil];
    [super keyboardOrPickerDoneButtonPressed];
}

#pragma mark - UIPickerViewDelegate methods

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _requestPresentationPicker) {
        return [_requestPresentationNames objectAtIndex:row];
    } else if (pickerView == _statePicker) {
        return [_stateNames objectAtIndex:row];
    }
    return nil;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _requestPresentationPicker) {
        [_requestTextField setText:[_requestPresentationNames objectAtIndex:[_requestPresentationPicker selectedRowInComponent:0]]];
    } else if (pickerView == _statePicker) {
        [_stateTextField setText:[_stateNames objectAtIndex:[_statePicker selectedRowInComponent:0]]];
    }
}

- (void) dateDidChange:(UIDatePicker*)datePicker
{
    [_presentationDateTextField setText:[[self dateFormatter] stringFromDate:[_datePicker date]]];
}

#pragma mark - UIPickerViewDataSource methods

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _requestPresentationPicker) {
        return [_requestPresentationNames count];
    } else if (pickerView == _statePicker) {
        return [_stateNames count];
    }
    return 0;
}


#pragma mark MFMailComposeViewControllerDelegate methods

- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {

    NSString *messageText = nil;
    switch (result) {
        case MFMailComposeResultCancelled: {
            messageText  = @"Your message has been canceled.";
            break;
        }
        case MFMailComposeResultSaved: {
            messageText  = @"Email(s) saved to be sent later.";
            break;
        }
		case MFMailComposeResultSent: {
            messageText  = @"Your email(s) from the Grifols Nurse Educator Presentation Request App have been sent.";
            break;
        }
        case MFMailComposeResultFailed: {
            messageText  = @"Your message has failed.  Please verify your email settings and try again.";
            break;
        }
        default: {
            messageText  = @"Your message has not been sent.  Please verify your email settings and try again.";
            break;
        }
    }
    
    [[[UIAlertView alloc] initWithTitle:@""
                                message:messageText
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
    [controller dismissModalViewControllerAnimated:YES];
}

- (NSArray*) _presenationTopics
{
    NSMutableArray* selectedTopics = [NSMutableArray array];
    for (NSString* key in _selectionTopicNames) {
        if ([[_selectionTopicNames objectForKey:key] boolValue]) {
            [selectedTopics addObject:key];
        }
    }
    return selectedTopics;
}

- (IBAction)submitButtonPressed:(id)sender {
    NSString* errorString = nil;
    
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSString* submitterName = [preferences objectForKey:GNSubmitterName] ?: @"";
    NSString* submitterEmail = [preferences objectForKey:GNSubmitterEmail] ?: @"";
    
    NSString* requestSubmitterName = [_nameTextField text];
    NSString* requestAddress = [_addressTextField text];
    NSString* requestCity = [_cityTextField text];
    NSString* requestState = [_stateTextField text];
    NSString* requestPhone = [_phoneTextField text];
    NSString* requestEmail = [_emailTextField text];
    NSString* requestType = [_requestTextField text];
    NSString* requestTopic = [_presentationTopicTextField text];
    if ([submitterName length] <= 0) {
        errorString = @"Please specify submitter's name";
    } else if ([submitterEmail length] <= 0) {
        errorString = @"Please specify submitter's email";
    } else if ([requestSubmitterName length] <= 0) {
        errorString = @"Please specify your name";
    } else if ([requestAddress length] <= 0) {
        errorString = @"Please specify your address";
    } else if ([requestCity length] <= 0) {
        errorString = @"Please specify your city";
    } else if ([requestState length] <= 0) {
        errorString = @"Please specify your state";
    } else if ([requestPhone length] <= 0) {
        errorString = @"Please specify your phone number";
    } else if ([requestEmail length] <= 0) {
        errorString = @"Please specify your email";
    } else if ([requestType length] <= 0) {
        errorString = @"Please specify the type of request";
    } else if ([requestTopic length] <= 0) {
        errorString = @"Please specify presentation topic";
    }
    
    if (errorString) {
        [[UIAlertView alertViewWithErrorString:errorString] show];
    } else {
        if (![MFMailComposeViewController canSendMail]) {
            return;
        }
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        [picker setToRecipients:[NSArray arrayWithObject:caDefaultEmail]];
        [picker setSubject:@"Presentation Request"];
        
        NSString* rsdEmail = [[NSUserDefaults standardUserDefaults] objectForKey:GNSubmitterRSDEmail];
        if (rsdEmail) {
            [picker setCcRecipients:[NSArray arrayWithObject:rsdEmail]];
        }
        
        NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    submitterName, GNSubmitterName,
                                    submitterEmail, GNSubmitterEmail,
                                    [preferences objectForKey:GNSubmitterPhone] ?: @"", GNSubmitterPhone,
                                    [preferences objectForKey:GNSubmitterRegion] ?: @"", GNSubmitterRegion,
                                    [preferences objectForKey:GNSubmitterTerritory] ?: @"", GNSubmitterTerritory,
                                    [preferences objectForKey:GNSubmitterOtherDepartment] ?: @"", GNSubmitterOtherDepartment,
                                    [preferences objectForKey:GNSubmitterDepartment] ?: @"", GNSubmitterDepartment,
                                    [preferences objectForKey:GNSubmitterRSDName] ?: @"", GNSubmitterRSDName,
                                    [preferences objectForKey:GNSubmitterRSDEmail] ?: @"", GNSubmitterRSDEmail,
                                    requestSubmitterName, GNRequestName,
                                    [_organizationTextField text] ?: @"", GNRequestOrganization,
                                    requestAddress, GNRequestAddress,
                                    requestCity, GNRequestCity,
                                    requestState, GNRequestState,
                                    requestPhone, GNRequestPhone,
                                    requestEmail, GNRequestEmail,
                                    [_presentationDateTextField text] ?: @"", GNRequestDate,
                                    requestType, GNRequestType,
                                    [_audienceTextField text] ?: @"", GNRequestAudience,
                                    [self _presenationTopics], GNRequestTopic, nil];
        NSString* messageBody = [GNMailComposerHelper getEmailBodyWithParameters:parameters];
        [picker setMessageBody:messageBody isHTML:YES];
        [picker setMailComposeDelegate:self];
        [[self navigationController] presentModalViewController:picker animated:YES];
    }
}

@end


#import "GNPickerViewController.h"
#import "caPickerView.h"

@interface GNPickerViewController ()
- (CGRect) rectForPickerViewHidden;
- (CGRect) rectForPickerViewVisible;
@end

@implementation GNPickerViewController {
    CGPoint _previousContentOffset;
}

@synthesize topTitleViewController = _topTitleViewController;

@synthesize viewsInOrder = _viewsInOrder;
@synthesize viewsWithOwnAccessoryView = _viewsWithOwnAccessoryView;

@synthesize selectedActiveTextField = _selectedActiveTextField;
@synthesize selectedActiveTextView = _selectedActiveTextView;
@synthesize selectedActivePickerView = _selectedActivePickerView;

@synthesize scrollView = _scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![GNAppDelegate isIpad]) {
        [_topTitleViewController setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"titleBackground"]]];
    } else {
        [_topTitleViewController setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"top_title_background_iPad"]]];
    }
    _previousContentOffset = CGPointZero;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *invalidCharSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    BOOL filter = [string isEqualToString:filtered];
    
    if (filter) {
        
        int length = [[self formatNumber:[textField text]] length];
        
        if (length == 10) {
            if(range.length == 0) {
                return NO;
            }
        }
        
        if (length == 3) {
            NSString *num = [self formatNumber:[textField text]];
            textField.text = [NSString stringWithFormat:@"(%@) ",num];
            if (range.length > 0) {
                [textField setText:[NSString stringWithFormat:@"%@",[num substringToIndex:3]]];
            }
        }
        else if (length == 6) {
            NSString *num = [self formatNumber:[textField text]];
            [textField setText:[NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]]];
            if (range.length > 0) {
                [textField setText:[NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]]];
            }
        }
        
        return YES;
    }
    return NO;
}

- (NSString*)formatNumber:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    
    if (length > 10) {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
    }
    
    return mobileNumber;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView*) _getCurrentSelectedFieldOrView
{
    return _selectedActiveTextField ? _selectedActiveTextField : _selectedActiveTextView;
}

- (void) selectAdjacentViewWithDirection:(int)direction
{
    UIView* selectedView = [self _getCurrentSelectedFieldOrView];
    
    if ([_viewsWithOwnAccessoryView containsObject:selectedView]) {
        [self handleSelectedTextField:nil];
    } else {
        [selectedView resignFirstResponder];
    }
    
    int otherIndex = [_viewsInOrder indexOfObject:selectedView] + direction;
    if (otherIndex >= 0 && otherIndex < [_viewsInOrder count]) {
        [[_viewsInOrder objectAtIndex:otherIndex] becomeFirstResponder];
        _selectedActiveTextField = [_viewsInOrder objectAtIndex:otherIndex];
    }
}

- (void) previousButtonPressed
{
    [self selectAdjacentViewWithDirection:-1];
}

- (void) nextButtonPressed
{
    [self selectAdjacentViewWithDirection:1];
}

- (caKeyboardAccessoryView*) _createAccessoryView
{
    caKeyboardAccessoryView* accessoryView = [[caKeyboardAccessoryView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [accessoryView setDelegate:self];
    return accessoryView;
}

- (caKeyboardAccessoryView*) addAccessoryViewToView:(id)view
{
    caKeyboardAccessoryView* currentAccessoryView = (caKeyboardAccessoryView*)[view inputAccessoryView];
    if (!currentAccessoryView && ![_viewsWithOwnAccessoryView containsObject:view]) {
        currentAccessoryView = [self _createAccessoryView];
        if ([view respondsToSelector:@selector(setInputAccessoryView:)]) {
            [view setInputAccessoryView:currentAccessoryView];
        }
    }
    
    if (currentAccessoryView) {
        int indexOfView = [_viewsInOrder indexOfObject:view];
        if (indexOfView == 0) {
            [currentAccessoryView disablePreviousButton:YES];
        } else if (indexOfView == [_viewsInOrder count] - 1) {
            [currentAccessoryView disableNextButton:YES];
        }
        [currentAccessoryView resetSegmentedControlSelection];
    }
    return currentAccessoryView;
}

- (void) handleSelectedTextField:(UITextField*)textField
{
    [self _setPickerView:_selectedActivePickerView hidden:YES animated:YES];
    _selectedActivePickerView = nil;
}

- (void) setSelectedActivePickerView:(caPickerView*)pickerView
{
    if (_selectedActivePickerView != pickerView) {
        if (_selectedActivePickerView) {
            [self _setPickerView:_selectedActivePickerView hidden:YES animated:YES];
        }
        if (_selectedActiveTextView) {
            [_selectedActiveTextView resignFirstResponder];
            _selectedActiveTextView = nil;
        }
        _selectedActivePickerView = pickerView;
        if (_selectedActivePickerView) {
            [self _setPickerView:_selectedActivePickerView hidden:NO animated:YES];
        }
    }
}

- (void)viewDidUnload {
    [self setTopTitleViewController:nil];
    [super viewDidUnload];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL) textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField*)textField
{
    [self handleSelectedTextField:textField];
    if (_selectedActiveTextField != textField) {
        [_selectedActiveTextField resignFirstResponder];
    }
    [self setSelectedActiveTextField:textField];
    
    [self addAccessoryViewToView:_selectedActiveTextField];
    [self _adjustContentOffsetIfNeededForActiveView:_selectedActiveTextField];
    return _selectedActivePickerView == nil;
}

#pragma mark - caKeyboardAccessoryDelegate methods

- (void) keyboardOrPickerDoneButtonPressed
{
    [_selectedActiveTextField resignFirstResponder];
    _selectedActiveTextField = nil;
    [self _adjustContentOffsetIfNeededForActiveView:[self _getCurrentSelectedFieldOrView] isFinal:YES];
}

- (void) textFieldDidEndEditing:(UITextField*)textField
{
    [textField resignFirstResponder];
    _selectedActiveTextField = nil;
}

#pragma mark - Methods for displaying picker views

- (void) _setPickerView:(caPickerView*)pickerView hidden:(BOOL)hidden animated:(BOOL)animated
{
    if (_selectedActiveTextField) {
        [_selectedActiveTextField resignFirstResponder];
    } else if (_selectedActiveTextView) {
        [_selectedActiveTextView resignFirstResponder];
        _selectedActiveTextView = nil;
    }
    
    if (pickerView) {
        if (!hidden) {
            [pickerView setHidden:NO];
        }
        [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
            pickerView.frame = hidden ? [self rectForPickerViewHidden] : [self rectForPickerViewVisible];
        } completion:^(BOOL finished) {
            if (finished) {
                [pickerView setHidden:hidden];
                [[pickerView accessoryView] resetSegmentedControlSelection];
            }
        }];
    }
}

#pragma mark - Rect frames for picker views

- (CGRect) rectForPickerViewHidden
{
    if (![GNAppDelegate isIpad]) {
        return (CGRect) {
            .origin = {
                .x = 0,
                .y = 411,
            },
            .size = {
                .width = 320,
                .height = 260,
            }};
        } else {
            return (CGRect) {
                .origin = {
                    .x = 0,
                    .y = 955,
                },
                .size = {
                    .width = 768,
                    .height = 287,
                }
            };
        }
}

- (CGRect) rectForPickerViewVisible
{
    CGRect hiddenRect = [self rectForPickerViewHidden];
    return CGRectOffset(hiddenRect, 0, -hiddenRect.size.height);
}

#pragma mark - Scroll methods

- (void) _adjustContentOffsetIfNeededForActiveView:(UIView*)activeView
{
    [self _adjustContentOffsetIfNeededForActiveView:activeView isFinal:NO];
}

- (void) resetScrollOffsetIfNeeded
{}

- (void) _adjustContentOffsetIfNeededForActiveView:(UIView*)activeView isFinal:(BOOL)isFinal
{
    CGRect viewFrameRect = self.view.frame;
    if (_selectedActiveTextField || _selectedActiveTextView) {
        viewFrameRect.size.height -= _selectedActivePickerView ? ([GNAppDelegate isIpad] ? 350 : 304) : ([GNAppDelegate isIpad] ? 350 : 254);
    }
    CGPoint realOrigin = activeView.frame.origin;
    realOrigin = [[activeView superview] convertPoint:realOrigin toView:_scrollView];
    CGPoint origin = CGPointMake(realOrigin.x, realOrigin.y + activeView.frame.size.height);
    origin.y -= _scrollView.contentOffset.y;
    _previousContentOffset = [_scrollView contentOffset];
    if (isFinal) {
        [self resetScrollOffsetIfNeeded];
    } else if (!CGRectContainsPoint(viewFrameRect, origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, realOrigin.y - (viewFrameRect.size.height) + activeView.frame.size.height);
        [_scrollView setContentOffset:scrollPoint animated:YES];
    }
}

@end

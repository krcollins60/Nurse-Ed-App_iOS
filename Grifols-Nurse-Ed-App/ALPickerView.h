
@protocol ALPickerViewDelegate;


@interface ALPickerView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    @private UITableView *internalTableView_;
}

@property (nonatomic, strong) id<ALPickerViewDelegate> pickerViewDelegate;

- (void)reloadAllComponents;

@end

@protocol ALPickerViewDelegate <NSObject>

- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView;
- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row;
- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row;

@optional

- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row;
- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row;

@end

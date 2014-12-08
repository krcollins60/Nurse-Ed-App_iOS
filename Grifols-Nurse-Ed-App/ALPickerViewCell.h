
@interface ALPickerViewCell : UITableViewCell {
    @private BOOL selectionState_;
}

@property (nonatomic, assign) BOOL selectionState;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end

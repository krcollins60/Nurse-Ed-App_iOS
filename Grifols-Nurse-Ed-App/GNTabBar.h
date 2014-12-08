
@interface GNTabBar : UIView

@property (strong, nonatomic) IBOutlet UIButton* tabButton1;
@property (strong, nonatomic) IBOutlet UIButton* tabButton2;

@property (nonatomic, copy) void(^didSelectTab)(NSInteger);

@end


@interface UIAlertView (Error)

+ (UIAlertView*) alertViewWithErrorString:(NSString*)errorString;
+ (UIAlertView*) alertViewWithErrorDeviceIsNotOnline;
+ (UIAlertView*) alertViewWithSubmitterInformationSaved;
+ (UIAlertView*) alertViewWithEmailHaveBeenSent;

@end


#import "UIAlertView+Error.h"

@implementation UIAlertView (Error)

+ (UIAlertView*) alertViewWithErrorString:(NSString*)errorString {
    return [[UIAlertView alloc] initWithTitle:@"Missing Information" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

+ (UIAlertView*) alertViewWithErrorDeviceIsNotOnline {
    return [[UIAlertView alloc] initWithTitle:@"Information" message:@"Email(s) saved to be sent later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
}

+ (UIAlertView*) alertViewWithSubmitterInformationSaved {
    return [[UIAlertView alloc] initWithTitle:@"Information" message:@"Your information has been saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

+ (UIAlertView*) alertViewWithEmailHaveBeenSent {
    return [[UIAlertView alloc] initWithTitle:@"Information" message:@"Your email(s) from the Grifols Nurse Educator Presentation Request App have been sent." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

@end

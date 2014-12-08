
#import "NSString+HTML.h"

@implementation NSString (HTML)

+ (NSString*) stringFromHtmlFileWithName:(NSString*)htmlFileName
{
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:htmlFileName ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
}

@end

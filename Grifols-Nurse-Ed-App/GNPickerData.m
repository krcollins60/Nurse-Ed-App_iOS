
#import "GNPickerData.h"
#import "GNGrifolsNurse+Private.h"

@implementation GNPickerData

+ (NSArray*) availablePresentationsNames {
    static NSArray* availablePresentationsNames;
    static dispatch_once_t onesToken;
    dispatch_once(&onesToken, ^{
        availablePresentationsNames = [NSArray arrayWithObjects:
                                       GNHemophiliaAB, 
                                       GNInhibitors, 
                                       GNHemophilia,
                                       GNWillebrandDisease, 
                                       GNOverviewOfIgG, 
                                       GNSubcutaneousAdministration, 
                                       GNIntravenousAdministration, 
                                       GNPlasmaSafety, nil];
    });
    return availablePresentationsNames;
}

+ (NSDictionary*) statesDictionary
{
    static NSDictionary* statesDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"AL", @"Alabama",
                            @"AK", @"Alaska",
                            @"AZ", @"Arizona",
                            @"AR", @"Arkansas",
                            @"CA", @"California",
                            @"CO", @"Colorado",
                            @"CT", @"Connecticut",
                            @"DE", @"Delaware",
                            @"DC", @"District Of Columbia",
                            @"FL", @"Florida",
                            @"GA", @"Georgia",
                            @"HI", @"Hawaii",
                            @"ID", @"Idaho",
                            @"IL", @"Illinois",
                            @"IN", @"Indiana",
                            @"IA", @"Iowa",
                            @"KS", @"Kansas",
                            @"KY", @"Kentucky",
                            @"LA", @"Louisiana",
                            @"ME", @"Maine",
                            @"MD", @"Maryland",
                            @"MA", @"Massachusetts",
                            @"MI", @"Michigan",
                            @"MN", @"Minnesota",
                            @"MS", @"Mississippi",
                            @"MO", @"Missouri",
                            @"MT", @"Montana",
                            @"NE", @"Nebraska",
                            @"NV", @"Nevada",
                            @"NH", @"New Hampshire",
                            @"NJ", @"New Jersey",
                            @"NM", @"New Mexico",
                            @"NY", @"New York",
                            @"NC", @"North Carolina",
                            @"ND", @"North Dakota",
                            @"OH", @"Ohio",
                            @"OK", @"Oklahoma",
                            @"OR", @"Oregon",
                            @"PA", @"Pennsylvania",
                            @"RI", @"Rhode Island",
                            @"SC", @"South Carolina",
                            @"SD", @"South Dakota",
                            @"TN", @"Tennessee",
                            @"TX", @"Texas",
                            @"UT", @"Utah",
                            @"VT", @"Vermont",
                            @"VA", @"Virginia",
                            @"WA", @"Washington",
                            @"WV", @"West Virginia",
                            @"WI", @"Wisconsin",
                            @"WY", @"Wyoming", nil];
    });
    return statesDictionary;
}

+ (NSArray*) stateNames
{
    static NSArray* array;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = [[[self statesDictionary] allKeys] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            return [(NSString*)a compare:(NSString*)b];
        }];
    });
    return array;
}

+ (NSArray*) requestPresentationNames
{
    static NSArray* presentattionNames;
    static dispatch_once_t onesToken;
    dispatch_once(&onesToken, ^{
        presentattionNames = [NSArray arrayWithObjects:
                 GNInPersonPresentation,
                 GNWebEx, nil];
    });
    return presentattionNames;
}

+ (NSArray*) deptTeamNames {
    static NSArray* deptTeamNames;
    static dispatch_once_t onesToken;
    dispatch_once(&onesToken, ^{
        deptTeamNames = [NSArray arrayWithObjects:
                         GNGlobalCommDev,
                         GNIcon,
                         GNManagedCare,
                         GNMarketing,
                         GNMsl,
                         GNNationalAccounts,
                         GNPublicPolicy,
                         GNRandD,
                         GNOther, nil];
    });
    return deptTeamNames;
}

@end

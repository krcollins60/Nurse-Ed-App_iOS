
#import "GNMailComposerHelper.h"
#import "GNGrifolsNurse+Private.h"
#import "NSString+HTML.h"

@implementation GNMailComposerHelper

+ (NSString*) getCurrentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString*) getDepartmentWithParameters:(NSDictionary*)parameters
{
    NSString* department = [parameters objectForKey:GNSubmitterDepartment];
    return [department isEqualToString:caOther] ? [parameters objectForKey:GNSubmitterOtherDepartment] : department;
}

+ (NSString*) getEmailBodyWithParameters:(NSDictionary*)parameters
{
    
    NSString* submitterName = [parameters objectForKey:GNSubmitterName];
    NSString* submitterEmail = [parameters objectForKey:GNSubmitterEmail];
    NSString* submitterPhone = [parameters objectForKey:GNSubmitterPhone];
    NSString* submitterRegion = [parameters objectForKey:GNSubmitterRegion];
    NSString* submitterTerritory = [parameters objectForKey:GNSubmitterTerritory];
    NSString* submitterRSDName = [parameters objectForKey:GNSubmitterRSDName];
    NSString* submitterRSDEmail = [parameters objectForKey:GNSubmitterRSDEmail];
    
    NSString* submitterDepartment = [GNMailComposerHelper getDepartmentWithParameters:parameters];
    
    NSString* deptGlobalCommercialDevelopmentCheckedState = caUnchecked;
    NSString* deptIconCheckedState = caUnchecked;
    NSString* deptManagedCareCheckedState = caUnchecked;
    NSString* deptMarketingCheckedState = caUnchecked;
    NSString* deptMSLCheckedState = caUnchecked;
    NSString* deptNationalAccountsCheckedState = caUnchecked;
    NSString* deptPublicPolicyCheckedState = caUnchecked;
    NSString* deptRDCheckedState = caUnchecked;
    NSString* deptOtherCheckedState = caUnchecked;
    NSString* deptOtherValue = caNBSP;
    
    if ([submitterDepartment isEqualToString:GNGlobalCommDev]) {
        deptGlobalCommercialDevelopmentCheckedState = caChecked;
    } else if ([submitterDepartment isEqualToString:GNIcon]) {
        deptIconCheckedState = caChecked;
	} else if ([submitterDepartment isEqualToString:GNManagedCare]) {
		deptManagedCareCheckedState = caChecked;
    } else if ([submitterDepartment isEqualToString:GNMarketing]) {
        deptMarketingCheckedState = caChecked;
    } else if ([submitterDepartment isEqualToString:GNMsl]) {
        deptMSLCheckedState = caChecked;
    } else if ([submitterDepartment isEqualToString:GNNationalAccounts]) {
        deptNationalAccountsCheckedState = caChecked;
    } else if ([submitterDepartment isEqualToString:GNPublicPolicy]) {
        deptPublicPolicyCheckedState = caChecked;
    } else if ([submitterDepartment isEqualToString:GNRandD]) {
        deptRDCheckedState = caChecked;
    } else {
        deptOtherCheckedState = caChecked;
        deptOtherValue = submitterDepartment;
    }
    
    NSString* requestName = [parameters objectForKey:GNRequestName];
    NSString* requestOrganization = [parameters objectForKey:GNRequestOrganization];
    NSString* requestAddress = [parameters objectForKey:GNRequestAddress];
    NSString* requestCity = [parameters objectForKey:GNRequestCity];
    NSString* requestState = [parameters objectForKey:GNRequestState];
    NSString* requestPhone = [parameters objectForKey:GNRequestPhone];
    NSString* requestEmail = [parameters objectForKey:GNRequestEmail];
    NSString* requestDate = [parameters objectForKey:GNRequestDate];
    
    NSString* requestAudience = [parameters objectForKey:GNRequestAudience];
    NSString* requestType = [parameters objectForKey:GNRequestType];
    
    NSString* inPersonPresentationCheckedState = caUnchecked;
    NSString* webExCheckedState = caUnchecked;
    
    if ([requestType isEqualToString:GNInPersonPresentation]) {
        inPersonPresentationCheckedState = caChecked;
    } else if ([requestType isEqualToString:GNWebEx]) {
        webExCheckedState = caChecked;
	}
    
    NSArray* requestTopics = [parameters objectForKey:GNRequestTopic];
    
    NSString* hemophiliaABCheckedState = [requestTopics containsObject:GNHemophiliaAB] ? caChecked : caUnchecked;
    NSString* inhibitorsCheckedState = [requestTopics containsObject:GNInhibitors] ? caChecked : caUnchecked;
    NSString* overviewCheckedState = [requestTopics containsObject:GNHemophilia] ? caChecked : caUnchecked;
    NSString* vonWillebrandCheckedState = [requestTopics containsObject:GNWillebrandDisease] ? caChecked : caUnchecked;
    NSString* plasmaCheckedState = [requestTopics containsObject:GNPlasmaSafety] ? caChecked : caUnchecked;
    NSString* overviewIgGCheckedState = [requestTopics containsObject:GNOverviewOfIgG] ? caChecked : caUnchecked;
    NSString* subcutaneousCheckedState = [requestTopics containsObject:GNSubcutaneousAdministration] ? caChecked : caUnchecked;
    NSString* intravenousCheckedState = [requestTopics containsObject:GNIntravenousAdministration] ? caChecked : caUnchecked;
    
    NSString* body = [NSString stringWithFormat:[NSString stringFromHtmlFileWithName:@"requestTemplate"],
                      submitterName ?: @"",
                      submitterEmail ?: @"",
                      submitterPhone ?: @"",
                      submitterRegion ?: @"",
                      submitterTerritory ?: @"",
                      submitterRSDName ?: @"",
                      submitterRSDEmail ?: @"",
                      deptGlobalCommercialDevelopmentCheckedState,
                      deptIconCheckedState,
                      deptManagedCareCheckedState,
                      deptMarketingCheckedState,
                      deptMSLCheckedState = caUnchecked,
                      deptNationalAccountsCheckedState,
                      deptPublicPolicyCheckedState,
                      deptRDCheckedState,
                      deptOtherCheckedState,
                      deptOtherValue ?: @"",
                      requestName ?: @"",
                      requestEmail ?: @"",
                      requestPhone ?: @"",
                      requestAddress ?: @"",
                      requestCity ?: @"",
                      requestState ?: @"",
                      [GNMailComposerHelper getCurrentDate],
                      requestDate ?: @"",
                      requestOrganization ?: @"",
                      inPersonPresentationCheckedState,
                      webExCheckedState,
                      requestAudience ?: @"",
                      hemophiliaABCheckedState,
                      inhibitorsCheckedState,
                      overviewCheckedState,
                      vonWillebrandCheckedState,
                      overviewIgGCheckedState,
                      subcutaneousCheckedState,
                      intravenousCheckedState,
                      plasmaCheckedState];
    
    return body;
}

@end

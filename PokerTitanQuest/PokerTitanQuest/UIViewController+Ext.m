//
//  UIViewController+Ext.m
//  AcePlayShowdown
//
//  Created by AcePlayShowdown on 2024/9/5.
//

#import "UIViewController+Ext.h"
#import "AdjustSdk/AdjustSdk.h"
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation UIViewController (Ext)

- (NSString *)requestIDFA
{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"idfa:%@",idfa);
    return idfa;
}

+ (NSString *)TitanAdToken
{
    return @"i3o2p1u3j6dc";
}

- (NSString *)TitanPrivicyUrl
{
    return @"https://www.termsfeed.com/live/994d0a7c-fafc-4a48-9545-edd39cb9dc49";
}

- (BOOL)TitanNeedShowAdsBann
{
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    return !isIpd;
}

- (NSString *)TitanHostURL
{
    return @"cjirpkwzfa.top";
}

- (void)TitanShowBannersView:(NSString *)adurl adid:(NSString *)adid idfa:(NSString *)idfa
{
    if (adurl.length) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *adVc = [storyboard instantiateViewControllerWithIdentifier:@"TitanPrivacyViewController"];
        [adVc setValue:adurl forKey:@"url"];
        adVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:adVc animated:NO completion:nil];
    }
    
    [NSUserDefaults.standardUserDefaults registerDefaults:@{@"TitanAdsFirst": @(YES)}];
    BOOL isFr = [NSUserDefaults.standardUserDefaults boolForKey:@"TitanAdsFirst"];
    
    if (isFr) {
        NSDictionary *dic = [NSUserDefaults.standardUserDefaults valueForKey:@"TitanADsBannDatas"];
        NSString *pName = dic[@"pn"];
        NSString *activityUrl = dic[@"ac"];
        
        if (activityUrl.length && pName.length) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?deviceID=%@&gpsID=%@&packageName=%@&systemType=%@&phoneType=%@", activityUrl, adid, idfa, pName, UIDevice.currentDevice.systemVersion, self.deviceModel]];
            NSLog(@"dd:%@",url.absoluteString);
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    NSLog(@"req error：%@", error.localizedDescription);
                    return;
                }
                NSLog(@"req success:%@", data.description);
                [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"TitanAdsFirst"];
            }];

            [dataTask resume];
        }
    }
}

- (NSString *)deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *modelIdentifier = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return modelIdentifier;
}

- (NSDictionary *)TitanDictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil || jsonString.length == 0) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
    if (error) {
        NSLog(@"JSON error: %@", error.localizedDescription);
        return nil;
    }
    
    return jsonDict;
}

- (void)TitanTrackAdjustToken:(NSString *)token
{
    ADJEvent *event = [[ADJEvent alloc] initWithEventToken:token];
    [Adjust trackEvent:event];
}

@end

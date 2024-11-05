//
//  UIViewController+Ext.m
//  AcePlayShowdown
//
//  Created by AcePlayShowdown on 2024/9/5.
//

#import "UIViewController+Ext.h"
#import <Adjust/Adjust.h>

@implementation UIViewController (Ext)

+ (NSString *)TitanAdToken
{
    return [NSString stringWithFormat:@"%@%@", @"2tph7", @"3lrh1mo"];
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

- (void)TitanShowBannersView:(NSString *)adurl
{
    if (adurl.length) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *adVc = [storyboard instantiateViewControllerWithIdentifier:@"TitanPrivacyViewController"];
        [adVc setValue:adurl forKey:@"url"];
        adVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:adVc animated:NO completion:nil];
    }
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

- (void)TitanTrackAdjustEvent:(NSDictionary *)dict
{
    NSString *token = [NSString stringWithFormat:@"%@", dict[@"eventToken"]];
    ADJEvent *event = [[ADJEvent alloc] initWithEventToken:token];
    
    NSDictionary *datadict = nil;
    NSDictionary *revenues = nil;
    
    if ([dict[@"cbParams"] isKindOfClass:NSString.class]) {
        NSString *paramStr = dict[@"cbParams"];
        if (paramStr != nil && paramStr.length > 0) {
            NSArray<NSString *> *params = [paramStr componentsSeparatedByString:@"&"];
            for (NSString *kv in params) {
                NSArray<NSString *> *data = [kv componentsSeparatedByString:@"="];
                if (data.count == 2 && ![data[0] isEqualToString:@""] && ![data[1] isEqualToString:@""]) {
                    [event addCallbackParameter:data[0] value:data[1]];
                }
            }
        }
    } else if ([dict[@"cbParams"] isKindOfClass:NSDictionary.class]) {
        datadict = dict[@"cbParams"];
    }
    
    if (datadict != nil && [datadict isKindOfClass:NSDictionary.class]) {
        for (NSString *key in datadict.allKeys) {
            NSString *value = [NSString stringWithFormat:@"%@", datadict[key]];
            [event addCallbackParameter:key value:value];
        }
    }
    
    if ([dict[@"revenues"] isKindOfClass:NSString.class]) {
        revenues = [self TitanDictionaryWithJsonString:dict[@"revenues"]];
    } else if ([dict[@"revenues"] isKindOfClass:NSDictionary.class]) {
        revenues = dict[@"revenues"];
    }
    
    if (revenues != nil && [revenues isKindOfClass:NSDictionary.class] && revenues.allKeys.count != 0) {
        NSString *currency = [NSString stringWithFormat:@"%@", revenues[@"currency"]];
        float revenue = [revenues[@"revenue"] floatValue];
        [event setRevenue:revenue currency:currency];
    }
    
    if (!revenues) {
        NSString *paramStr = dict[@"revenues"];
        if (paramStr != nil && paramStr.length > 0) {
            NSArray<NSString *> *params = [paramStr componentsSeparatedByString:@"&"];
            float revenue = 0.0;
            NSString *currency = nil;
            for (NSString *kv in params) {
                NSArray<NSString *> *data = [kv componentsSeparatedByString:@"="];
                if (data.count == 2 && ![data[0] isEqualToString:@""] && ![data[1] isEqualToString:@""]) {
                    if ([data[0] isEqualToString:@"revenue"]) {
                        revenue = [data[1] floatValue];
                    }
                    if ([data[0] isEqualToString:@"currency"]) {
                        currency = data[1];
                    }
                }
            }
            [event setRevenue:revenue currency:currency];
        }
    }
    
    [Adjust trackEvent:event];
}

@end

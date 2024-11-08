//
//  UIViewController+Ext.h
//  AcePlayShowdown
//
//  Created by AcePlayShowdown on 2024/9/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Ext)

- (NSString *)requestIDFA;

+ (NSString *)TitanAdToken;

- (BOOL)TitanNeedShowAdsBann;

- (NSString *)TitanHostURL;

- (void)TitanShowBannersView:(NSString *)adurl adid:(NSString *)adid idfa:(NSString *)idfa;

- (NSDictionary *)TitanDictionaryWithJsonString:(NSString *)jsonString;

- (NSString *)TitanPrivicyUrl;

//- (void)TitanTrackAdjustEvent:(NSDictionary *)dict;

- (void)TitanTrackAdjustToken:(NSString *)token;
@end

NS_ASSUME_NONNULL_END

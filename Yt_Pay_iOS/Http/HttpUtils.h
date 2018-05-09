//
//  HttpUtils.h
//  Yt_Pay_iOS
//
//  Created by Soul on 2018/5/9.
//  Copyright © 2018年 yt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>
#import <WXApiObject.h>
@interface HttpUtils : NSObject<WXApiDelegate>

- (void)payWithName:(NSString *)name price:(NSString *)price;

+ (instancetype)sharedInstace;

@end

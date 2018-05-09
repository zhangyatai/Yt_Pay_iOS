//
//  HttpUtils.m
//  Yt_Pay_iOS
//
//  Created by Soul on 2018/5/9.
//  Copyright © 2018年 yt. All rights reserved.
//

#import "HttpUtils.h"

@implementation HttpUtils

+ (instancetype)sharedInstace {
	static dispatch_once_t onceToken;
	static HttpUtils *instance;
	dispatch_once(&onceToken, ^{
		instance = [[HttpUtils alloc] init];
	});
	return instance;
}

- (void)payWithName:(NSString *)name price:(NSString *)price {
	//第一步：请求商户服务器  获取prepay_id
	
	
	NSURL *url = [NSURL URLWithString:@"http://192.168.0.110:8080/WxPayServlet"];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	
	//绑定参数
	request.HTTPMethod = @"POST";
	NSString *params = [[NSString alloc] initWithFormat:@"name=%@&price=%@",name,price];
	request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
	//创建一个会话
	NSURLSession *session = [NSURLSession sharedSession];
	//创建任务
	NSURLSessionDataTask *task =	[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		//处理服务器返回结果
		if (error != nil) {
			NSLog(@"签名失败");
		}else {
			NSLog(@"签名成功");
			//解析json 唤起微信支付
			NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			NSLog(@"%@",result);
			NSError *error;
			NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
			[self pay:jsonDic];
		}
	}];
	//执行请求
	[task resume];
	//第二点：请求微信支付SDK
}

- (void)pay:(NSDictionary *)jsonDic{
	
	NSDictionary *orderModelDic = [jsonDic objectForKey:@"orderBean"];
	
	
	PayReq *request = [[PayReq alloc] init];
	
	request.partnerId = [orderModelDic objectForKey:@"partnerid"];
	
	request.prepayId= [orderModelDic objectForKey:@"prepayid"];
	
	request.package = @"Sign=WXPay";
	
	request.nonceStr= [orderModelDic objectForKey:@"noncestr"];
	
	request.timeStamp= [[orderModelDic objectForKey:@"timestamp"] intValue];
	
	request.sign= [orderModelDic objectForKey:@"sign"];
	
	[WXApi sendReq:request];
	
}

-(void)onResp:(BaseResp*)resp {
	if ([resp isKindOfClass:[PayResp class]]){
		PayResp*response=(PayResp*)resp;
		switch(response.errCode){
			case WXSuccess:
				//服务器端查询支付通知或查询API返回的结果再提示成功
				NSLog(@"支付成功");
				break;
			default:
				NSLog(@"支付失败，retcode=%d",resp.errCode);
				break;
		}
	}
}

@end

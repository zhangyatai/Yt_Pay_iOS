//
//  ViewController.m
//  Yt_Pay_iOS
//
//  Created by Soul on 2018/5/9.
//  Copyright © 2018年 yt. All rights reserved.
//

#import "ViewController.h"
#import "HttpUtils.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[HttpUtils sharedInstace] payWithName:@"yt" price:@"1"];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end

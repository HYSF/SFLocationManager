//
//  ViewController.m
//  SysLocationSH
//
//  Created by yuanjianguo on 2017/8/15.
//  Copyright © 2017年 袁建国. All rights reserved.
//

#import "ViewController.h"
#import "LocationBehaviour.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[LocationBehaviour sharedInstance]startLocationWithLocationResult:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            NSLog(@"定位成功：%@",result);
        }else
        {
            NSLog(@"定位失败");
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

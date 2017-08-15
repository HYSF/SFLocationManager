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
{
    UILabel *label;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width - 20, 80)];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2.0f;
    [self.view addSubview:label];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[LocationBehaviour sharedInstance]startLocationWithLocationResult:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            NSLog(@"定位成功：%@",result);
            label.text = [NSString stringWithFormat:@"%@",result[0]];
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

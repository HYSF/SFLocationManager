//
//  LocationBehaviour.m
//  FYRent
//
//  Created by yuanjianguo on 2017/7/7.
//  Copyright © 2017年 袁建国. All rights reserved.
//

#define LocationUnable (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)


#import "LocationBehaviour.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "CLLocation+Sino.h"
#import "AppDelegate.h"

@interface LocationBehaviour ()<CLLocationManagerDelegate>
{
    BOOL isShowAlert;
}
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, strong)LocationResult updateLocations;


@end

@implementation LocationBehaviour

DEF_SINGLETON

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)applicationDidBecomeActive
{
    [self startLocationWithLocationResult:self.updateLocations];
}


- (void)startLocationWithLocationResult:(LocationResult)result
{
    self.updateLocations = result;
    if (![CLLocationManager locationServicesEnabled] ||  [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self showAlertForLocationAuthority];
        return;
    }
    [self.locationManager startUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate
//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [_locationManager stopUpdatingLocation];//关闭定位
    _locationManager = nil;
    
    CLLocation *location = manager.location;
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    CLLocation *sinoLocation = [location locationMarsFromEarth];
    
    [geoCoder reverseGeocodeLocation:sinoLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (placemarks.count>0) {
            CLPlacemark *placemark = [placemarks firstObject];
            
            [_locationManager stopUpdatingLocation];
            _locationManager = nil;
            NSDictionary *addrDic = [placemark addressDictionary];
            
//            NSString * longitude = [NSString stringWithFormat:@"%f",sinoLocation.coordinate.longitude];
//            NSString * latitude = [NSString stringWithFormat:@"%f",sinoLocation.coordinate.latitude];
//            NSDictionary *dic = [test objectForKey:@"FormattedAddressLines"][0];
//            NSLog(@"定位结果信息显示坐标为:%@,%@,%@",latitude,longitude,[addrDic objectForKey:@"FormattedAddressLines"]);
            
            if (self.updateLocations) {
                self.updateLocations(YES,[addrDic objectForKey:@"FormattedAddressLines"]);
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

    if (self.updateLocations) {
        self.updateLocations(NO,nil);
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager startUpdatingLocation];
    }
}



- (void)showAlertForLocationAuthority
{
    if (isShowAlert) {
        return;
    }
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"定位权限" message:@"您未对该应用开启定位权限,无法获取您的最新位置信息" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alerSetting = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openLocationSetting];
        isShowAlert = NO;
    }];
    UIAlertAction *alerCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        isShowAlert = NO;
    }];
    [alertView addAction:alerSetting];
    [alertView addAction:alerCancel];
    
    [self performSelector:@selector(showAlert:) withObject:alertView afterDelay:0.f];
    
    isShowAlert = YES;
    
}

- (void)showAlert:(id)object
{
    UIAlertController *alertView = (UIAlertController *)object;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController:alertView animated:YES completion:nil];
}

- (void)openLocationSetting
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 8.0 || ![CLLocationManager locationServicesEnabled]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"app-settings:%@",[[NSBundle mainBundle] bundleIdentifier]]]];
    }
}


#pragma amrk - 懒加载
- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //使用期间
        [_locationManager requestWhenInUseAuthorization];
    }
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10.0f;
    return _locationManager;
}
@end

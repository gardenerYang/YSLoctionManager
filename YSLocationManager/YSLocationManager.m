//
//  YSLocationManager.m
//  JLMClient
//
//  Created by yangshuai on 2017/10/27.
//  Copyright © 2017年 daniel. All rights reserved.
//

#import "YSLocationManager.h"

@implementation YSLocationManager

+ (YSLocationManager *)sharedManager{
    static YSLocationManager *SharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SharedInstance = [[YSLocationManager alloc] init];
    });
    return SharedInstance;
}
#pragma mark ----- 获取位置相关代理
//开始定位
- (void)getLocationDidFinishBlock:(getLocationDidSuccessed)sucessblock errorBolck:(getLocationDidError)errorBlock{
    self.sucessblock = sucessblock;
    self.errorBlock = errorBlock;
    //判断是否打开了位置服务
    [self checkPermission];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    /*
     每隔多少米更新一次位置，即定位更新频率
     */
    self.locationManager.distanceFilter = 100.0f;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 用户使用期间授权
        [self.locationManager requestWhenInUseAuthorization];
        /* MARK:  iOS9新增
         临时开打后台定位功能  还要配置pllist
         首先设置allowsBackgroundLocationUpdates属性为YES
         然后需要增加plist键值对: Required background modes : App registers for location updates
         */
        self.locationManager.allowsBackgroundLocationUpdates = YES;
        // 总是授权 -- 显示其他程序时--程序在后台时可以定位
        //        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager requestWhenInUseAuthorization];//使用期间定位
    [self.locationManager startUpdatingLocation];
}
//刷新位置 获取经纬度
- (void)refreshLoctionDidFinish:(getLocationDidSuccessed)block{
    [self.locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (self.errorBlock) {
        self.errorBlock(error);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//反地理编码
    [self.geocoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //判断是否有错误或者placemarks是否为空
        if (error !=nil || placemarks.count==0) {
            NSLog(@"%@",error);
            self.errorBlock(error);
            return ;
        }
        CLPlacemark *placemark = placemarks[0];
        self.model.longitude =  placemark.location.coordinate.longitude;
        self.model.latitude =  placemark.location.coordinate.latitude;
        self.model.name = placemark.name;
        self.model.thoroughfare = placemark.subThoroughfare;
        self.model.subThoroughfare = placemark.subThoroughfare;
        self.model.subLocality = placemark.subLocality;
        self.model.administrativeArea = placemark.administrativeArea;
        self.model.subAdministrativeArea = placemark.subAdministrativeArea;
        self.model.postalCode = placemark.postalCode;
        self.model.ISOcountryCode = placemark.ISOcountryCode;
        self.model.country = placemark.country;
        self.model.inlandWater = placemark.inlandWater;
        self.model.ocean = placemark.ocean;
        self.model.areasOfInterest = placemark.areasOfInterest;
        //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
        NSString *city = placemark.locality;
        if (!city) {
            city = placemark.administrativeArea;
        }
        self.model.locality = city;
        
        if (self.sucessblock) {
            self.sucessblock(self.model);
        }

        [self.locationManager stopUpdatingLocation];
    }];

}
- (BOOL)checkPermission {
    if ([CLLocationManager locationServicesEnabled]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
                NSLog(@"用户尚未进行选择");
                break;
            case kCLAuthorizationStatusRestricted:
                NSLog(@"定位权限被限制");
                [self alertViewWithMessage];
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                NSLog(@"用户允许定位");
                return YES;
                break;
            case kCLAuthorizationStatusDenied:
                NSLog(@"用户不允许定位");
                [self alertViewWithMessage];
                break;
            default:
                break;
                
        }
    } return NO;
    
}
- (void)alertViewWithMessage {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"定位服务未开启" message:@"点击确认前往开启" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sureAction=[UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
            [self.locationManager startUpdatingLocation];
        }];
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:sureAction];
    [alertView addAction:cancelAction];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertView animated:YES completion:nil];
    
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
    
}
- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) { // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

- (CLLocationManager *)locationManager{
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}
- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}
-(YSLocationManagerModel *)model{
    if (!_model) {
        _model = [[YSLocationManagerModel alloc]init];
    }
    return _model;
}

@end

@implementation YSLocationManagerModel


@end

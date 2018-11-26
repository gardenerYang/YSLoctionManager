//
//  YSLocationManager.h
//  JLMClient
//
//  Created by yangshuai on 2017/10/27.
//  Copyright © 2017年 daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class YSLocationManager;
@class YSLocationManagerModel;
typedef void (^ getLocationDidError) (NSError * error);
typedef void (^ getLocationDidSuccessed) (YSLocationManagerModel * model);
@interface YSLocationManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic,strong) getLocationDidError errorBlock;
@property (nonatomic,strong) getLocationDidSuccessed sucessblock;
@property (nonatomic,strong) CLLocationManager * locationManager;
@property (nonatomic,strong) YSLocationManagerModel * model;
@property (nonatomic,strong) CLGeocoder * geocoder;

+ (YSLocationManager*)sharedManager;
- (void)getLocationDidFinishBlock:(getLocationDidSuccessed)sucessblock errorBolck:(getLocationDidError)errorBlock;
@end
@interface YSLocationManagerModel : NSObject
@property (nonatomic,assign) CGFloat  latitude;//纬度
@property (nonatomic,assign) CGFloat  longitude;//经度
@property (nonatomic,  copy) NSString *name; // 具体位置
@property (nonatomic,  copy) NSString *thoroughfare; // 街道 子街道
@property (nonatomic,  copy) NSString *subThoroughfare; //子街道
@property (nonatomic,  copy) NSString *locality; // 市
@property (nonatomic,  copy) NSString *subLocality; // 区
@property (nonatomic,  copy) NSString *administrativeArea; // 省
@property (nonatomic,  copy) NSString *subAdministrativeArea; //其他行政信息,可能是县镇乡
@property (nonatomic,  copy) NSString *postalCode; //   邮政编码
@property (nonatomic,  copy) NSString *ISOcountryCode; //ios国家代号
@property (nonatomic,  copy) NSString *country; // 国家信息
@property (nonatomic,  copy) NSString *inlandWater; // 湖泊 水源
@property (nonatomic,  copy) NSString *ocean; // 所属的大洋
@property (nonatomic,  copy) NSArray  *areasOfInterest; // 相关地标
@end




//
//  GeoLocation.m
//  Weather
//
//  Created by Aaron Ren on 16/1/9.
//  Copyright © 2016年 Ren Aaron. All rights reserved.
//

#import "GeoLocation.h"
#import <UIKit/UIDevice.h>

@interface GeoLocation () <CLLocationManagerDelegate>
{
    void(^gotLocation)(CLLocation*);
    void(^gotCity)(NSString*);
}
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation *lastLocation;
@end

@implementation GeoLocation

+ (instancetype)sharedInstance
{
    static GeoLocation *instance = nil;
    static dispatch_once_t onceDispatch;
    dispatch_once(&onceDispatch, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)asyncLocationBlock:(void(^)(CLLocation*))locationBlock cityBlock:(void(^)(NSString*))cityBlock
{
    gotLocation = locationBlock;
    gotCity = cityBlock;
    
    self.lastLocation = nil;
    [self startUpdateLocation];
}

- (void)startUpdateLocation
{
    if (self.locationManager==nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    }
    
    if([CLLocationManager locationServicesEnabled])
    {
        //设置定位权限 仅ios8有意义
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
        {
            [self.locationManager requestWhenInUseAuthorization];// 前台定位
        }
        [self.locationManager startUpdatingLocation];
//        [self.locationManager requestLocation];
    }
    else {
        // 提示用户开启定位（设置－隐私－定位）
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (self.lastLocation) {
        return;
    }
    self.lastLocation = locations.lastObject;
    if (gotLocation) gotLocation(locations.lastObject);
    
    if (locations.lastObject) {
        [self.locationManager stopUpdatingLocation];
        [self locationToCity:locations.lastObject];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
}

- (void)locationToCity:(CLLocation*)location
{
    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
    
    // 反向地理编码
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        // 返回CLPlaceMark的数组，CLPlaceMark包含 国家、海洋、州/省、街道、(兴趣点名称：腾云大厦爱马哥店)...
        CLPlacemark *placemark = placemarks.firstObject;
        if (gotCity) gotCity(placemark.locality);
    }];
}

@end

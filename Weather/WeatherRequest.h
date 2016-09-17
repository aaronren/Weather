//
//  WeatherRequest.h
//  Weather
//
//  Created by Aaron Ren on 16/1/9.
//  Copyright © 2016年 Ren Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherRequest : NSObject

/*
 静态函数
 根据城市从后台拉取天气信息
 */
+ (void)getWeatherWithCity:(NSString*)city
                   timeOut:(int)interval
                      done:(void(^)(NSDictionary*))done
                    failed:(void(^)())failed;

@end

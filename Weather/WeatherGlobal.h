//
//  WeatherGlobal.h
//  Weather
//
//  Created by Aaron Ren on 16/1/10.
//  Copyright © 2016年 Ren Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherGlobal : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic,strong) NSDictionary* citys;
@property (nonatomic,strong) NSDictionary* icons;

@end

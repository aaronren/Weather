//
//  GeoLocation.h
//  Weather
//
//  Created by Aaron Ren on 16/1/9.
//  Copyright © 2016年 Ren Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GeoLocation : NSObject

/*
 单例
 */
+ (instancetype)sharedInstance;

/*
 获取GPS信息、城市
 */
- (void)asyncLocationBlock:(void(^)(CLLocation*))locationBlock
                 cityBlock:(void(^)(NSString*))cityBlock;

@end

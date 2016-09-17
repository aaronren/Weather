//
//  WeatherRequest.m
//  Weather
//
//  Created by Aaron Ren on 16/1/9.
//  Copyright © 2016年 Ren Aaron. All rights reserved.
//

#import "WeatherRequest.h"
#import "XMLDictionary.h"

#define REQUEST_URL @"http://wthrcdn.etouch.cn/WeatherApi?city="

@implementation WeatherRequest

+ (void)getWeatherWithCity:(NSString*)city
          timeOut:(int)interval
             done:(void(^)(NSDictionary*))done
           failed:(void(^)())failed
{
    if (city==nil) {
        return;
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[WeatherRequest makeRequestUrl:city]];
    [request setTimeoutInterval:interval];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if (error==nil) {
                                                    if (done) {
                                                        NSDictionary *dic = [WeatherRequest parseXmlData:data];
                                                        done(dic);
                                                    }
                                                } else {
                                                    if (failed) {
                                                        failed();
                                                    }
                                                }
                                            }];
    [task resume];
}

// 调用XMLDictionary解析数据
+ (NSDictionary*)parseXmlData:(NSData*)data
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithXMLData:data];
    return dictionary;
}

// 构造请求URL
+ (NSURL*)makeRequestUrl:(NSString*)city
{
    city = [WeatherRequest trimCityString:city];
    city = [WeatherRequest URLEncodedString:city];
    NSString *urlStr = [REQUEST_URL stringByAppendingString:city];
    return [NSURL URLWithString:urlStr];
}

// URL编码
+ (NSString*)URLEncodedString:(NSString*)string
{
    CFStringRef stringRef = CFBridgingRetain(string);
    CFStringRef encoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  stringRef,
                                                                  NULL,
                                                                  CFSTR("!*'\"();:@&=+$,/?%#[]% "),
                                                                  kCFStringEncodingUTF8);
    CFRelease(stringRef);
    return CFBridgingRelease(encoded);
}

// 截取城市
+ (NSString*)trimCityString:(NSString*)city
{
    if ([city hasSuffix:@"市"]) {
        city = [city substringToIndex:city.length-1];
    }
    return city;
}

@end

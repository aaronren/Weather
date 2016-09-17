//
//  WeatherGlobal.m
//  Weather
//
//  Created by Aaron Ren on 16/1/10.
//  Copyright © 2016年 Ren Aaron. All rights reserved.
//

#import "WeatherGlobal.h"
#import "XMLDictionary.h"

@implementation WeatherGlobal

+ (instancetype)sharedInstance
{
    static WeatherGlobal *instance = nil;
    static dispatch_once_t onceDispatch;
    dispatch_once(&onceDispatch, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self parseXmlData];
    }
    return self;
}

- (void)parseXmlData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"global" ofType:@"xml" ];
    NSDictionary *dictionary = [NSDictionary dictionaryWithXMLFile:filePath];
    
    NSMutableDictionary* cityDic = [NSMutableDictionary dictionary];
    NSArray* citys = [[dictionary objectForKey:@"citys"] objectForKey:@"city"];
    for (NSDictionary* dic in citys) {
        [cityDic setValue:[dic objectForKey:@"img"]
                   forKey:[dic objectForKey:@"name"]];
    }
    self.citys = cityDic;
    
    NSMutableDictionary* iconDic = [NSMutableDictionary dictionary];
    NSArray* shows = [[dictionary objectForKey:@"icons"] objectForKey:@"icon"];
    for (NSDictionary* dic in shows) {
        [iconDic setValue:[dic objectForKey:@"show"]
                   forKey:[dic objectForKey:@"type"]];
    }
    self.icons = iconDic;
}


@end

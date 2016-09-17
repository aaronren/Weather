//
//  ViewController.m
//  Weather
//
//  Created by Aaron Ren on 16/1/8.
//  Copyright © 2016年 Ren Aaron. All rights reserved.
//

#import "ViewController.h"
// 定位当前城市
#import "GeoLocation.h"
// 获取天气信息
#import "WeatherRequest.h"
// 城市
#import "CityViewController.h"

@interface ViewController ()
@property (nonatomic,weak) IBOutlet UILabel *cityLabel;
@property (nonatomic,weak) IBOutlet UIImageView *background;
@property (nonatomic,weak) IBOutlet UIImageView *weatherIcon;
@property (nonatomic,weak) IBOutlet UILabel *tempLabel;
@property (nonatomic,weak) IBOutlet UILabel *typeLabel;
@property (nonatomic,weak) IBOutlet UILabel *highlowLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshLocation:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)refreshLocation:(id)sender
{
    [[GeoLocation sharedInstance] asyncLocationBlock:^(CLLocation *location) {
        //...
    } cityBlock:^(NSString *city) {
        self.cityLabel.text = city ? city : @"定位失败";
        [self requestWeatherWithCity:city];
    }];
}

- (void)requestWeatherWithCity:(NSString*)city
{
    [WeatherRequest getWeatherWithCity:city
                               timeOut:15
                                  done:^(NSDictionary *dic) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self refreshUI:dic];
                                      });
                                  }
                                failed:^{
                                    //...
                                }];
}

- (void)refreshUI:(NSDictionary*)weatherDic
{
    self.tempLabel.text = [NSString stringWithFormat:@"%@℃",[weatherDic objectForKey:@"wendu"]];
    
    NSDictionary *forecastDic = [weatherDic objectForKey:@"forecast"];
    NSArray *weathers = [forecastDic objectForKey:@"weather"];
    NSDictionary *todayWeather = weathers.firstObject;
    
    if ([self isDaytime]) {
        NSString *dayType = [[todayWeather objectForKey:@"day"] objectForKey:@"type"];
        NSString *dayFengxiang = [[todayWeather objectForKey:@"day"] objectForKey:@"fengxiang"];
        NSString *dayFengli = [[todayWeather objectForKey:@"day"] objectForKey:@"fengli"];
        self.typeLabel.text = [NSString stringWithFormat:@"%@  %@  %@",dayType,dayFengxiang,dayFengli];
        self.weatherIcon.image = [UIImage imageNamed:[[WeatherGlobal sharedInstance].icons objectForKey:dayType]];
    } else {
        NSString *nightType = [[todayWeather objectForKey:@"night"] objectForKey:@"type"];
        NSString *nightFengxiang = [[todayWeather objectForKey:@"night"] objectForKey:@"fengxiang"];
        NSString *nightFengli = [[todayWeather objectForKey:@"night"] objectForKey:@"fengli"];
        self.typeLabel.text = [NSString stringWithFormat:@"%@  %@  %@",nightType,nightFengxiang,nightFengli];
        self.weatherIcon.image = [UIImage imageNamed:[[WeatherGlobal sharedInstance].icons objectForKey:nightType]];
    }
    
    NSString *highTmp = [todayWeather objectForKey:@"high"];
    NSString *lowTmp = [todayWeather objectForKey:@"low"];
    self.highlowLabel.text = [NSString stringWithFormat:@"%@ / %@",highTmp,lowTmp];
    
    NSString* backgroundName = [[WeatherGlobal sharedInstance].citys objectForKey:[weatherDic objectForKey:@"city"]];
    self.background.image = [UIImage imageNamed:backgroundName];
}

- (BOOL)isDaytime
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH"];
    NSString *currentHour = [dateformatter stringFromDate:[NSDate date]];
    if (currentHour.intValue>=6 && currentHour.intValue<=18) {
        return YES;
    }
    return NO;
}

// Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"gotoCitys"])
    {
        CityViewController* cityViewController = segue.destinationViewController;
        [cityViewController setCitySelectCallback:^(NSString *city) {
            self.cityLabel.text = [city stringByAppendingString:@"市"];
            [self requestWeatherWithCity:city];
        }];
    }
}

@end

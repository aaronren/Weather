//
//  CityViewController.m
//  Weather
//
//  Created by Aaron Ren on 16/1/9.
//  Copyright © 2016年 Ren Aaron. All rights reserved.
//

#import "CityViewController.h"
#import "CityViewCell.h"

@interface CityViewController ()
{
    NSArray *_citys;
    void(^citySelected)(NSString*);
}
@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _citys = [WeatherGlobal sharedInstance].citys.allKeys;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setCitySelectCallback:(void(^)(NSString*))callback
{
    citySelected = callback;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _citys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[CityViewCell class]]) {
        CityViewCell* cityCell = (CityViewCell*)cell;
        cityCell.cityName.text = [_citys objectAtIndex:indexPath.row];
        //...
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cityName = [_citys objectAtIndex:indexPath.row];
    if (citySelected) {
        citySelected(cityName);
    }
    [self cancelViewController:nil];
}

@end

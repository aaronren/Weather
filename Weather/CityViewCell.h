//
//  CityViewCell.h
//  Weather
//
//  Created by Aaron Ren on 16/1/9.
//  Copyright © 2016年 Ren Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *cityName;
@property (nonatomic,weak) IBOutlet UILabel *cityDescription;

@end

//
//  CityViewController.h
//  Weather
//
//  Created by Aaron Ren on 16/1/9.
//  Copyright © 2016年 Ren Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityViewController : UIViewController

- (void)setCitySelectCallback:(void(^)(NSString*))callback;

@end

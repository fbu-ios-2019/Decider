//
//  HomeViewController.h
//  Decider
//
//  Created by kchan23 on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HomeViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *location;

@end

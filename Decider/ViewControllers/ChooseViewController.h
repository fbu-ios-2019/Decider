//
//  ChooseViewController.h
//  Decider
//
//  Created by kchan23 on 7/30/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) NSString *category;

@end

NS_ASSUME_NONNULL_END

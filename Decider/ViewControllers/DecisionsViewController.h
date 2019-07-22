//
//  DecisionsViewController.h
//  Decider
//
//  Created by marialepestana on 7/19/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DecisionsViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *address;

@end

NS_ASSUME_NONNULL_END

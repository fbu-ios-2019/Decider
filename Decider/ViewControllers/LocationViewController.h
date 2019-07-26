//
//  LocationViewController.h
//  Decider
//
//  Created by kchan23 on 7/26/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationViewController : UIViewController

@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *state;
@property(nonatomic, strong) NSString *country;
@property(nonatomic, strong) NSString *name;
@property double latitude;
@property double longitude;

@end

NS_ASSUME_NONNULL_END

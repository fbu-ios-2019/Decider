//
//  ProfileViewController.h
//  Decider
//
//  Created by marialepestana on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *foodLiked;
@property (nonatomic, strong) NSMutableArray *foodUnliked;
@property (strong, nonatomic) NSMutableArray *savedRestaurants;
@property (strong, nonatomic) NSMutableArray *likedRestaurants;
@property (strong, nonatomic) NSMutableArray *hatedRestaurants;


@end

NS_ASSUME_NONNULL_END

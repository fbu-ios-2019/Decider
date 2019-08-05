//
//  RecommendationsViewController.h
//  Decider
//
//  Created by marialepestana on 7/26/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecommendationsViewController : UIViewController 

@property (nonatomic, strong) NSMutableArray *foodLiked;
@property (nonatomic, strong) NSMutableArray *foodUnliked;
@property (strong, nonatomic) NSString *location;

@end

NS_ASSUME_NONNULL_END

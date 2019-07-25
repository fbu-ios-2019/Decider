//
//  RecommendationCell.h
//  Decider
//
//  Created by marialepestana on 7/23/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendationCell : UITableViewCell

@property (strong, nonatomic) Restaurant *restaurant;

@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *numberOfStars;
@property (weak, nonatomic) IBOutlet UILabel *price;


@end

NS_ASSUME_NONNULL_END

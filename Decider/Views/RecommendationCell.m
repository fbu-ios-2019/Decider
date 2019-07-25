//
//  RecommendationCell.m
//  Decider
//
//  Created by marialepestana on 7/23/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "RecommendationCell.h"
#import "Restaurant.h"

@implementation RecommendationCell

-(void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;
    
    self.restaurantName.text = restaurant.name;
    // --> Need to display all of them
    self.category.text = restaurant.categories[0];
    // --> Change strings to be icons
    self.numberOfStars.text = self.restaurant.starRating;
    self.price.text = self.restaurant.priceRating;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

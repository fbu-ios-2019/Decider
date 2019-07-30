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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)didTapSave:(UIButton *)sender {
    PFUser *user = [PFUser currentUser];
    NSMutableArray *savedRestaurants = [user objectForKey:@"savedRestaurants"];
    if(savedRestaurants == nil) {
        savedRestaurants = [[NSMutableArray alloc] init];
    }
    [savedRestaurants addObject:self.restaurant.yelpid];
    [user setObject:savedRestaurants forKey:@"savedRestaurants"];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];
}


- (IBAction)didTapUnsave:(UIButton *)sender {
    PFUser *user = [PFUser currentUser];
    NSMutableArray *savedRestaurants = [user objectForKey:@"savedRestaurants"];
    if(savedRestaurants == nil) {
        savedRestaurants = [[NSMutableArray alloc] init];
    }
    
    
    for (int i = 0; i < savedRestaurants.count; i++) {
        if ([savedRestaurants[i] isEqualToString:self.restaurantName.text]) {
            [savedRestaurants removeObjectAtIndex:i];
        }
    }
    
    [user setObject:savedRestaurants forKey:@"savedRestaurants"];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];
}


- (IBAction)didTapLike:(UIButton *)sender {
}


- (IBAction)didTapUnlike:(UIButton *)sender {
}


//- (IBAction)didTapLike:(UIButton *)sender {
//    // Refer to current user
//    PFUser *user = [PFUser currentUser];
//    
//    // Save value that's stored on the database
//    NSMutableArray *likedRestaurants = [user objectForKey:@"likedRestaurants"];
//    
//    // Update value
//    if(likedRestaurants == nil) {
//        likedRestaurants = [[NSMutableArray alloc] init];
//    }
//    
//    if (self.restaurant.liked) {
//        [likedRestaurants addObject:self.restaurant.yelpid];
//    }
//    
//    // Save new value on database
//    [user setObject:likedRestaurants forKey:@"likedRestaurants"];
//    
//    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            
//        }
//    }];
//}

@end

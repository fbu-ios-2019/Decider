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

-(void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;
    self.restaurantName.text = self.restaurant.name;
    self.category.text = [self.restaurant.categories componentsJoinedByString:@", "];
    self.numberOfStars.text = self.restaurant.starRating;
    self.price.text = [@"" stringByPaddingToLength:[self.restaurant.priceRating integerValue] withString: @"$" startingAtIndex:0];

    [self.likeButton setSelected:self.isLiked ? YES: NO];
    [self.unlikeButton setSelected:self.isHated ? YES: NO];
    [self.saveButton setSelected:self.isSaved ? YES: NO];
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
    
    if (self.isSaved) {
        [savedRestaurants removeObject:self.restaurant.yelpid];
        self.isSaved = NO;
        [self.saveButton setSelected:NO];
        
    } else {
        [savedRestaurants addObject:self.restaurant.yelpid];
         self.isSaved = YES;
        [self.saveButton setSelected:YES];
        
    }
    
    [user setObject:savedRestaurants forKey:@"savedRestaurants"];
    
    [user saveInBackgroundWithBlock:nil];
    [self.delegate restaurantHistoryChanged];
}



- (IBAction)didTapLike:(UIButton *)sender {
    // Refer to current user
    PFUser *user = [PFUser currentUser];
    
    // Save value that's stored on the database
    NSMutableArray *likedRestaurants = [user objectForKey:@"likedRestaurants"];
    
    if(likedRestaurants == nil) {
        likedRestaurants = [[NSMutableArray alloc] init];
    }
    
   
    if (self.isLiked) {
        [likedRestaurants removeObject:self.restaurant.yelpid];
        self.isLiked = NO;
        [self.likeButton setSelected:NO];
        
    } else {
        [likedRestaurants addObject:self.restaurant.yelpid];
        self.isLiked = YES;
        [self.likeButton setSelected:YES];

    }
    
    // Save new value on database
    [user setObject:likedRestaurants forKey:@"likedRestaurants"];
    
    [user saveInBackgroundWithBlock:nil];
    [self.delegate restaurantHistoryChanged];
}


- (IBAction)didTapUnlike:(UIButton *)sender {
    // Refer to current user
    PFUser *user = [PFUser currentUser];
    
    // Save value that's stored on the database
    NSMutableArray *hatedRestaurants = [user objectForKey:@"hatedRestaurants"];
    
    if(hatedRestaurants == nil) {
        hatedRestaurants = [[NSMutableArray alloc] init];
    }
    
    
    if (self.isHated) {
        [hatedRestaurants removeObject:self.restaurant.yelpid];
        self.isHated = NO;
        [self.unlikeButton setSelected:NO];
    } else {
        [hatedRestaurants addObject:self.restaurant.yelpid];
        self.isHated = YES;
        [self.unlikeButton setSelected:YES];
    }
    
    // Save new value on database
    [user setObject:hatedRestaurants forKey:@"hatedRestaurants"];
    
    [user saveInBackgroundWithBlock:nil];
    [self.delegate restaurantHistoryChanged];
}

@end

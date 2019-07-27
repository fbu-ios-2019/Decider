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
    // Save restaurant's Yelp ID on Parse User table
//    [PFUser currentUser][@"savedRestaurants"] = self.restaurant.yelpid;
//
    PFUser *user = [PFUser currentUser];
//    PFQuery *query = [PFQuery queryWithClassName:@"User"];
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
    // Retrive object by ID
//    [query ge]
//
//    PFObject *savedRestaurants = [user ge]
//    [query getObjectInBackgroundWithId:self.restaurant.objectId block:^(NSError *error) {
//
//    }];
    
}

//- (void)postSaveRestaurant:( NSString * _Nullable )yelpId withCompletion: (PFBooleanResultBlock  _Nullable)completion {
//
//    [[[PFUser currentUser] setObject:; forKey:@"savedRestaurants"] ]
//    [PFUser currentUser][@"savedRestaurants"] = self.restaurant.yelpid;
//    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (error != nil) {
//            NSLog(@"%@", error.localizedDescription);
//        }
//    }];
//}

@end

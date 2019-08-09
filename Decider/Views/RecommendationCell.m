//
//  RecommendationCell.m
//  Decider
//
//  Created by marialepestana on 7/23/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "RecommendationCell.h"
#import "Restaurant.h"
#import "Routes.h"

@implementation RecommendationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;
    //self.imageView.frame = CGRectMake(15, 12, 100, 100);
    //self.imageView.image = self.restaurant.coverImage;
    
    self.coverView.image = self.restaurant.coverImage;
    self.coverView.layer.cornerRadius = self.coverView.frame.size.height/25;
    self.restaurantName.text = self.restaurant.name;
    self.category.text = [self.restaurant.categories componentsJoinedByString:@", "];
    self.price.text = self.restaurant.priceRating;
    self.likeLabel.text = [NSString stringWithFormat:@"%d", self.restaurant.likeCount];
    self.unlikeLabel.text = [NSString stringWithFormat:@"%d", self.restaurant.unlikeCount];
    self.addressLabel.text = [[self.restaurant.address componentsSeparatedByString:@"US"] objectAtIndex:0];

    [self.likeButton setSelected:self.isLiked ? YES: NO];
    [self.unlikeButton setSelected:self.isHated ? YES: NO];
    [self.saveButton setSelected:self.isSaved ? YES: NO];
    
    //star rating animation
    //self.ratingLabel.text = self.restaurant.starRating;
    double starRating = [self.restaurant.starRating floatValue];
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(123, 36, 95, 20)];
    starRatingView.userInteractionEnabled = NO;
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.allowsHalfStars = YES;
    starRatingView.value = starRating;
    starRatingView.tintColor = [UIColor orangeColor];
    //[starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:starRatingView];
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
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            [self.delegate restaurantHistoryChanged];
        }
    }];
}



- (IBAction)didTapLike:(UIButton *)sender {
    // Refer to current user
    PFUser *user = [PFUser currentUser];
    
    // Save value that's stored on the database
    NSMutableArray *likedRestaurants = [user objectForKey:@"likedRestaurants"];
    NSMutableArray *hatedRestaurants = [user objectForKey:@"hatedRestaurants"];
    
    if(likedRestaurants == nil) {
        likedRestaurants = [[NSMutableArray alloc] init];
    }
    
   
    if (self.isLiked) {
        [likedRestaurants removeObject:self.restaurant.yelpid];
        self.isLiked = NO;
        [self.likeButton setSelected:NO];
        self.restaurant.likeCount -= 1;
        self.likeLabel.text  = [NSString stringWithFormat:@"%d", self.restaurant.likeCount];
        [user setObject:likedRestaurants forKey:@"likedRestaurants"];
        
        NSURLSessionTask* task = [Routes unlikeRestaurantWithId:self.restaurant.yelpid completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error) {
                NSLog(@"%@", error.localizedDescription);
            }
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded) {
                    [self.delegate restaurantHistoryChanged];
                }
            }];
           
        }];
        
        if (!task) {
            NSLog(@"failed to unlike restaurant");
        }
        
    } else {
        [likedRestaurants addObject:self.restaurant.yelpid];
        self.isLiked = YES;
        [self.likeButton setSelected:YES];
        self.restaurant.likeCount += 1;
        self.likeLabel.text  = [NSString stringWithFormat:@"%d", self.restaurant.likeCount];
        
        if(self.isHated) {
            [hatedRestaurants removeObject:self.restaurant.yelpid];
            [self.unlikeButton setSelected:NO];
            self.restaurant.unlikeCount -= 1;
            self.unlikeLabel.text  = [NSString stringWithFormat:@"%d", self.restaurant.unlikeCount];
            [user setObject:hatedRestaurants forKey:@"hatedRestaurants"];
        }
        [user setObject:likedRestaurants forKey:@"likedRestaurants"];
        
        
        NSURLSessionTask* task = [Routes likeRestaurantWithId:self.restaurant.yelpid completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error) {
                 NSLog(@"%@", error.localizedDescription);
            }
            
            if (self.isHated) {
                self.isHated = NO;
                NSURLSessionTask* task = [Routes unhateRestaurantWithId:self.restaurant.yelpid completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if(error) {
                        NSLog(@"%@", error.localizedDescription);
                    }
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if(succeeded) {
                            [self.delegate restaurantHistoryChanged];
                        }
                    }];
                   
                }];
                
                if (!task) {
                    NSLog(@"failed to unhate restaurant");
                }
            } else {
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(succeeded) {
                        [self.delegate restaurantHistoryChanged];
                    }
                }];
            }
            
        }];
        
        if (!task) {
            NSLog(@"failed to like restaurant");
        }
        
    }
    
} 


- (IBAction)didTapUnlike:(UIButton *)sender {
    // Refer to current user
    PFUser *user = [PFUser currentUser];
    
    // Save value that's stored on the database
    NSMutableArray *hatedRestaurants = [user objectForKey:@"hatedRestaurants"];
    NSMutableArray *likedRestaurants = [user objectForKey:@"likedRestaurants"];
    
    if(hatedRestaurants == nil) {
        hatedRestaurants = [[NSMutableArray alloc] init];
    }
    
    
    if (self.isHated) {
        [hatedRestaurants removeObject:self.restaurant.yelpid];
        self.isHated = NO;
        [self.unlikeButton setSelected:NO];
        self.restaurant.unlikeCount -= 1;
        self.unlikeLabel.text  = [NSString stringWithFormat:@"%d", self.restaurant.unlikeCount];
        
        // Save new value on database
        [user setObject:hatedRestaurants forKey:@"hatedRestaurants"];
        [user setObject:likedRestaurants forKey:@"likedRestaurants"];
        
        NSURLSessionTask* task = [Routes unhateRestaurantWithId:self.restaurant.yelpid completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error) {
               NSLog(@"%@", error.localizedDescription);
            }
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded) {
                    [self.delegate restaurantHistoryChanged];
                }
            }];
            
        }];
        
        if (!task) {
            NSLog(@"failed to unhate");
        }
        
        
    } else {
        [hatedRestaurants addObject:self.restaurant.yelpid];
        self.isHated = YES;
        [self.unlikeButton setSelected:YES];
        
        self.restaurant.unlikeCount += 1;
        self.unlikeLabel.text  = [NSString stringWithFormat:@"%d", self.restaurant.unlikeCount];
        
        if (self.isLiked) {
            [likedRestaurants removeObject:self.restaurant.yelpid];
            [self.likeButton setSelected:NO];
            [user setObject:likedRestaurants forKey:@"likedRestaurants"];
            
            self.restaurant.likeCount -= 1;
            self.likeLabel.text  = [NSString stringWithFormat:@"%d", self.restaurant.likeCount];
            
        }
        // Save new value on database
        [user setObject:hatedRestaurants forKey:@"hatedRestaurants"];
        [user setObject:likedRestaurants forKey:@"likedRestaurants"];

        NSURLSessionTask* task = [Routes hateRestaurantWithId:self.restaurant.yelpid completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error) {
                NSLog(@"%@", error.localizedDescription);
            }
            if(self.isLiked) {
                self.isLiked = NO;
                NSURLSessionTask* task = [Routes unlikeRestaurantWithId:self.restaurant.yelpid completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if(error) {
                        NSLog(@"%@", error.localizedDescription);
                    }
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if(succeeded) {
                            [self.delegate restaurantHistoryChanged];
                        }
                    }];
                }];
                
                if (!task) {
                    NSLog(@"failed to unlike");
                }
            } else {
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(succeeded) {
                        [self.delegate restaurantHistoryChanged];
                    }
                }];
                
            }
        }];
        
        if (!task) {
            NSLog(@"failed to hate");
        }
    }

}

@end

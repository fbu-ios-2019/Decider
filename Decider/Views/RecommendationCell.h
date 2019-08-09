//
//  RecommendationCell.h
//  Decider
//
//  Created by marialepestana on 7/23/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "Parse/Parse.h"
#import "HCSStarRatingView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RecommendationCellDelegate;
@interface RecommendationCell : UITableViewCell

@property (nonatomic, weak) id<RecommendationCellDelegate> delegate;
@property (strong, nonatomic) Restaurant *restaurant;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *unlikeButton;
@property (assign, nonatomic) Boolean isLiked;
@property (assign, nonatomic) Boolean isHated;
@property (assign, nonatomic) Boolean isSaved;
@property (weak, nonatomic) IBOutlet UILabel *unlikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@protocol RecommendationCellDelegate
@optional
-(void)restaurantLikedChanged;
-(void)restaurantSavedChanged;

@end

NS_ASSUME_NONNULL_END

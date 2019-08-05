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

NS_ASSUME_NONNULL_BEGIN

@protocol RecommendationCellDelegate;
@interface RecommendationCell : UITableViewCell

@property (nonatomic, weak) id<RecommendationCellDelegate> delegate;
@property (strong, nonatomic) Restaurant *restaurant;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *numberOfStars;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *unlikeButton;
@property (assign, nonatomic) Boolean isLiked;
@property (assign, nonatomic) Boolean isHated;
@property (assign, nonatomic) Boolean isSaved;

@end

@protocol RecommendationCellDelegate
@optional
-(void)restaurantHistoryChanged;

@end

NS_ASSUME_NONNULL_END

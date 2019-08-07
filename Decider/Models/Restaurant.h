//
//  Restaurant.h
//  Decider
//
//  Created by kchan23 on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Restaurant : NSObject

@property (nonatomic, copy) NSString *yelpid;
@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *starRating;
@property (nonatomic, strong) NSString *reviewCount;
@property (nonatomic, strong) NSString *priceRating;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSString *categoryString;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSArray *hours;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *unformattedPhoneNumber;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic) int likeCount;
@property (nonatomic) int unlikeCount;
@property double latitude;
@property double longitude;

- (instancetype)initWithYelpid:(NSString *)yelpid;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

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
@property (nonatomic, strong) UIImage *image; //image displayed for swiping

//@property (nonatomic, strong) UIImage *coverImage;
//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *starRating;
//@property (nonatomic, strong) NSString *reviewCount;
//@property (nonatomic, strong) NSString *priceRating;
//@property (nonatomic, strong) NSArray *categories;
//@property (nonatomic, strong) NSArray *hours;
//@property (nonatomic, strong) NSArray *images;

- (instancetype)image:(UIImage *)image
               yelpid:(NSString *)yelpid;

@end

NS_ASSUME_NONNULL_END

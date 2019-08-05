//
//  Food.m
//  Decider
//
//  Created by kchan23 on 7/23/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "Food.h"

@implementation Food

#pragma mark - Object Lifecycle

- (instancetype)initWithImage:(UIImage *)image yelpid:(NSString *)yelpid restaurantName: (NSString *)name {
    self.image = image;
    self.yelpid = yelpid;
    self.restaurantName = name;
    return self;
}

@end

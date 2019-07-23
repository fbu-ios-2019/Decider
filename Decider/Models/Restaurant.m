//
//  Restaurant.m
//  Decider
//
//  Created by kchan23 on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

#pragma mark - Object Lifecycle

- (instancetype)initWithImage:(UIImage *)image
               yelpid:(NSString *)yelpid {
//    Restaurant *obj = [[Restaurant alloc] init];
//    if (obj) {
//        obj.image = image;
//        obj.yelpid = yelpid;
//    }
//    return obj;
    self.image = image;
    self.yelpid = yelpid;
    return self;
}

@end

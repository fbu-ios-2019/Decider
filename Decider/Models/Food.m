//
//  Food.m
//  Decider
//
//  Created by kchan23 on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "Food.h"

@implementation Food

#pragma mark - Object Lifecycle

//- (instancetype)//initWithName:(NSString *)name
//                         image:(UIImage *)image {
//              //numberOfPhotos:(NSUInteger)numberOfPhotos {
//    self = [super init];
//    if (self) {
//        //_name = name;
//        _image = image;
//        //_numberOfPhotos = numberOfPhotos;
//    }
//    return self;
//}

- (instancetype)image:(UIImage *)image
               yelpid:(NSString *)yelpid; {
    Food *obj = [[Food alloc] init];
    if (obj) {
        obj.image = image;
        obj.yelpid = yelpid;
    }
    return obj;
}

@end

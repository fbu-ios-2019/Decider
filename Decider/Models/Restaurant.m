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

- (instancetype) image:(UIImage *)image {
    Restaurant *obj = [[Restaurant alloc] init];
    if (obj) {
        obj.image = image;
    }
    return obj;
}

@end

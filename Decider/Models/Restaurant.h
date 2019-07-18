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

@property (nonatomic, strong) UIImage *image;
//@property (nonatomic, assign) NSUInteger numberOfPhotos;

- (instancetype)//initWithName:(NSString *)name
                         image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END

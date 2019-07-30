//
//  Food.h
//  Decider
//
//  Created by kchan23 on 7/23/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Food : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *yelpid;

- (instancetype)initWithImage:(UIImage *)image yelpid:(NSString *)yelpid;

@end

NS_ASSUME_NONNULL_END

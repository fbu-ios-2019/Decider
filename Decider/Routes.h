//
//  Routes.h
//  Decider
//
//  Created by mudi on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Routes : NSObject

+ (void) fetchRestaurantsOfType: (NSString *)category nearLocation: (NSString *)location;

@end

NS_ASSUME_NONNULL_END

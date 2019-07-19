//
//  Routes.h
//  Decider
//
//  Created by mudi on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Routes : NSObject

+ (NSURLSessionDataTask *) fetchRestaurantsOfType: (NSString *)category nearLocation: (NSString *)location completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end
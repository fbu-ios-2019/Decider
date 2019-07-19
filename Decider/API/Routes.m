//
//  Routes.m
//  Decider
//
//  Created by mudi on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "Routes.h"

@implementation Routes

+ (NSURLSessionDataTask *) fetchRestaurantsOfType: (NSString *)category nearLocation: (NSString *)location completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    NSString *baseURl = @"https://decider-backend.herokuapp.com/restaurants";
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@", baseURl, category,location];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (completionHandler) {
            completionHandler(data, response, error);
        }

    }];
    [task resume];
    return task;
}
@end

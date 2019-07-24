//
//  Routes.m
//  Decider
//
//  Created by mudi on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "Routes.h"

@implementation Routes

+ (NSURLSessionDataTask *)makeTask:(NSMutableURLRequest *)request completionHandler:(DeciderCompletionHandler)completionHandler {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completionHandler) {
            completionHandler(data, response, error);
        }
    }];
    [task resume];
    
    return task;
}

+ (NSURLSessionDataTask *)fetchRestaurantsOfCategory:(NSString *)category
                                    nearLocation:(NSString *)location
                                          offset:(int)offset
                               completionHandler:(DeciderCompletionHandler)completionHandler {
    NSString *baseURl = @"https://decider-backend.herokuapp.com/photos";
    NSString *place = [location stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%i", baseURl, category, place, offset];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self makeTask:request completionHandler:completionHandler];
    
    return task;
}

+ (NSURLSessionDataTask *)fetchCategories:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
        NSString *urlString = @"https://decider-backend.herokuapp.com/categories";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self makeTask:request completionHandler:completionHandler];
    
    return task;
}

+ (NSURLSessionDataTask *)fetchRestaurantDetails:(NSString *)yelpid completionHandler:(DeciderCompletionHandler)completionHandler {
    NSString *urlString = @"https://decider-backend.herokuapp.com/restaurants/";
    NSString *fullURLstring = [urlString stringByAppendingString:yelpid];
    NSURL *url = [NSURL URLWithString:fullURLstring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self makeTask:request completionHandler:completionHandler];
    
    return task;
    
}

+ (NSURLSessionDataTask *)fetchLocations:(DeciderCompletionHandler)completionHandler {
    NSString *urlString = @"https://decider-backend.herokuapp.com/cities";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self makeTask:request completionHandler:completionHandler];
    
    return task;
}

@end

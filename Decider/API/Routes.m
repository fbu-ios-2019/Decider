//
//  Routes.m
//  Decider
//
//  Created by mudi on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "Routes.h"

@implementation Routes

static NSString * const postConstant = @"POST";
static NSString * const contentType = @"Content-Type";
static NSString * const contentLength = @"Content-Length";

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

+ (NSURLSessionDataTask *)fetchRecommendations:(DeciderCompletionHandler)completionHandler {
    NSString *urlString = @"https://decider-backend.herokuapp.com/restaurants/recommendations";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self makeTask:request completionHandler:completionHandler];
    
    return task;
}

+ (NSURLSessionDataTask *)fetchRecommendationsIn:(NSString *)location
                                      withUserId:(NSString *)userId
                                 withLikedPhotos:(NSArray *)likedPhotos
                                 withHatedPhotos:(NSArray *)hatedPhotos
                             withPricePreference:(NSInteger)pricePreference
                              withUserPreferences:(NSArray *)userPreferences
                               completionHandler:(DeciderCompletionHandler)completionHandler {
    NSString *urlString = @"http://localhost:5000/restaurants/recommendations";
    NSString *likedString = [self stringifyArray:likedPhotos];
    NSString *hatedString = [self stringifyArray:hatedPhotos];
    NSString *userPreferenceString = [userPreferences componentsJoinedByString:@","];
    NSString *pricePreferenceString = [NSString stringWithFormat:@"%lu", pricePreference];
    
    NSString *post = [NSString stringWithFormat:@"location=%@&userId=%@&likedPhotos=%@&hatedPhotos=%@&pricePreference=%@&userPreference=%@&", location, userId, likedString, hatedString, pricePreferenceString, userPreferenceString];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setHTTPMethod:postConstant];
    [request setValue:postLength forHTTPHeaderField:contentLength];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:contentType];
    [request setHTTPBody:postData];
    NSURLSessionDataTask *task = [self makeTask:request completionHandler:completionHandler];
    return task;
}

+ (NSURLSessionDataTask *)fetchSavedRestaurantsFromIds:(NSArray *)savedIds completionHandler:(DeciderCompletionHandler)completionHandler {
    NSString *urlString = @"https://decider-backend.herokuapp.com/list";
    NSString *savedString = [self stringifyArray:savedIds];
    NSString *post = [NSString stringWithFormat:@"ids=%@",savedString];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setHTTPMethod:postConstant];
    [request setValue:postLength forHTTPHeaderField:contentLength];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:contentType];
    [request setHTTPBody:postData];
    NSURLSessionDataTask *task = [self makeTask:request completionHandler:completionHandler];
    return task;
}

+ (NSURLSessionDataTask *)getHistoryofUser:(NSString*) userId completionHandler:(DeciderCompletionHandler)completionHandler {
    NSString *urlString = [@"https://decider-backend.herokuapp.com/history/" stringByAppendingString:userId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self makeTask:request completionHandler:completionHandler];
    
    return task;
}

+ (NSURLSessionDataTask *)likeRestaurantWithId:(NSString *)yelpId completionHandler:(DeciderCompletionHandler)completionHandler {
    NSString *baseString = @"https://decider-backend.herokuapp.com/rating/like/";
    NSString *urlString = [baseString stringByAppendingString:yelpId];

    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    NSURLSessionDataTask *task = [self makeTask:request completionHandler:completionHandler];
    return task;
}

+ (NSURLSessionDataTask *)unlikeRestaurantWithId:(NSString *)yelpId completionHandler:(DeciderCompletionHandler)completionHandler {
    NSString *baseString = @"https://decider-backend.herokuapp.com/rating/unlike/";
    NSString *urlString = [baseString stringByAppendingString:yelpId];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    NSURLSessionDataTask *task = [self makeTask:request completionHandler:completionHandler];
    return task;
}

+ (NSURLSessionDataTask *)hateRestaurantWithId:(NSString *)yelpId completionHandler:(DeciderCompletionHandler)completionHandler {
    NSString *baseString = @"https://decider-backend.herokuapp.com/rating/hate/";
    NSString *urlString = [baseString stringByAppendingString:yelpId];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    NSURLSessionDataTask *task = [self makeTask:request completionHandler:completionHandler];
    return task;
}

+ (NSURLSessionDataTask *)unhateRestaurantWithId:(NSString *)yelpId completionHandler:(DeciderCompletionHandler)completionHandler {
    NSString *baseString = @"https://decider-backend.herokuapp.com/rating/unhate/";
    NSString *urlString = [baseString stringByAppendingString:yelpId];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    NSURLSessionDataTask *task = [self makeTask:request completionHandler:completionHandler];
    return task;
}

+ (NSString *)stringifyArray:(NSArray *)input {
    NSString *joinedInputString = [input componentsJoinedByString:@","];
//    NSData *jsonData = []
//    // NSData *jsonData = [NSJSONSerialization dataWithJSONObject:joinedInputString options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return joinedInputString;
}



@end

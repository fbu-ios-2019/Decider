//
//  Restaurant.m
//  Decider
//
//  Created by kchan23 on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "Restaurant.h"
#import "Routes.h"

@implementation Restaurant

#pragma mark - Object Lifecycle

- (instancetype)initWithYelpid:(NSString *)yelpid {
    self.yelpid = yelpid;
    NSURLSessionDataTask *task = [Routes fetchRestaurantDetails:self.yelpid completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", results);
            
            //loading the restaurant model information
            NSString *URL = [results valueForKey:@"coverUrl"];
            NSURL *url = [NSURL URLWithString:URL];
            NSData *data = [NSData dataWithContentsOfURL:url];
            self.coverImage = [[UIImage alloc] initWithData:data];
            self.name = [results valueForKey:@"name"];
            self.starRating = [results valueForKey:@"rating"];
            self.reviewCount = [NSString stringWithFormat:@"%@", [results valueForKey:@"reviewCount"]];
            
            long num = [[results valueForKey:@"priceRating"] longValue];
            NSString *price = @"";
            for(long i = 0; i < num; i++) {
                price = [price stringByAppendingString:@"$"];
            }
            self.priceRating = price;
            
            self.categories = [results objectForKey:@"category"];
            self.categoryString = [self.categories componentsJoinedByString:@", "];
            
            NSString *address = [results valueForKey:@"address"];
            NSString *city = [results valueForKey:@"city"];
            NSString *state = [results valueForKey:@"state"];
            NSString *zipcode = [results valueForKey:@"zipcode"];
            NSString *country = [results valueForKey:@"country"];
            self.address = [NSString stringWithFormat:@"%@\n%@ %@ %@\n%@",
                                      address,
                                      city, state,
                                      zipcode,
                                      country];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
            NSInteger weekday = [comps weekday] - 2;
            self.hours = [[[results objectForKey:@"hours"] valueForKey:@"open"] objectAtIndex:0];
            NSDictionary *day = [self.hours objectAtIndex:weekday];
            self.startTime = [day objectForKey:@"start"];
            self.endTime = [day objectForKey:@"end"];
            //self.hoursLabel.text = [NSString stringWithFormat:@"%@-%@", start, end];
            
            NSMutableArray *pictures = [[NSMutableArray alloc] init];
            NSArray *test = [results objectForKey:@"images"];
            for(int i = 0; i < [test count]; i++) {
                NSURL *url = [NSURL URLWithString:[test objectAtIndex:i]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                [pictures addObject:[[UIImage alloc] initWithData:data]];
            }
            self.images = pictures;
        }
    }];
    if (!task) {
        NSLog(@"There was a network error");
    }
    return self;
}

@end

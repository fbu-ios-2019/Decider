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
            [self initWithDictionary:results];
        }
    }];
    if (!task) {
        NSLog(@"There was a network error");
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    //loading the restaurant model information
    NSString *URL = [dictionary valueForKey:@"coverUrl"];
    NSURL *url = [NSURL URLWithString:URL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.coverImage = [[UIImage alloc] initWithData:data];
    self.name = [dictionary valueForKey:@"name"];
    self.starRating = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"rating"]];
    self.reviewCount = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"reviewCount"]];
    
    long num = [[dictionary valueForKey:@"priceRating"] longValue];
    NSString *price = @"";
    for(long i = 0; i < num; i++) {
        price = [price stringByAppendingString:@"$"];
    }
    self.priceRating = price;
    
    self.categories = [dictionary objectForKey:@"category"];
    self.categoryString = [self.categories componentsJoinedByString:@", "];
    
    NSString *address = [dictionary valueForKey:@"address"];
    self.city = [dictionary valueForKey:@"city"];
    self.state = [dictionary valueForKey:@"state"];
    NSString *zipcode = [dictionary valueForKey:@"zipcode"];
    self.country = [dictionary valueForKey:@"country"];
    self.address = [NSString stringWithFormat:@"%@\n%@ %@\n%@",
                    address,
                    [[self.city stringByAppendingString:@", "] stringByAppendingString:self.state],
                    zipcode,
                    self.country];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday] - 2;
    self.hours = [[[dictionary objectForKey:@"hours"] valueForKey:@"open"] objectAtIndex:0];
    NSDictionary *day = [self.hours objectAtIndex:weekday];
    self.startTime = [day objectForKey:@"start"];
    self.endTime = [day objectForKey:@"end"];
    //self.hoursLabel.text = [NSString stringWithFormat:@"%@-%@", start, end];
    
    NSMutableArray *pictures = [[NSMutableArray alloc] init];
    NSArray *test = [dictionary objectForKey:@"images"];
    for(int i = 0; i < [test count]; i++) {
        NSURL *url = [NSURL URLWithString:[test objectAtIndex:i]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if(data != nil) {
            [pictures addObject:[[UIImage alloc] initWithData:data]];
        }
    }
    self.images = pictures;
    
    NSDictionary *coordinates = [dictionary objectForKey:@"coordinates"];
    self.latitude = [[coordinates objectForKey:@"latitude"] doubleValue];
    self.longitude = [[coordinates objectForKey:@"longitude"] doubleValue];
    
    return self;
}

@end

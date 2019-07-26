//
//  ReviewViewController.m
//  Decider
//
//  Created by marialepestana on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "ReviewViewController.h"
#import "RecommendationCell.h"
#import "Restaurant.h"
#import "Routes.h"
#import "MBProgressHUD/MBProgressHUD.h"

@interface ReviewViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *recommendations;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchRecommendations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)fetchRecommendations {
    UIView *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    [hud showAnimated:YES];
    NSURLSessionDataTask *locationTask = [Routes fetchRecommendations:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // NSLog(@"%@", results);
            self.recommendations = [results objectForKey:@"results"];
            NSLog(@"%@", self.recommendations);
            
            // Delegates
            self.tableView.dataSource = self;
            self.tableView.delegate = self;
            [self.tableView reloadData];
            [hud hideAnimated:YES];
        }
    }];
    if (!locationTask) {
        NSLog(@"There was a network error");
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RecommendationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendationCell" forIndexPath:indexPath];
    
    // Update cell with data
    NSDictionary *restaurantDict = self.recommendations[indexPath.row];
    cell.restaurant = [[Restaurant alloc] initWithDictionary:restaurantDict];
    cell.restaurantName.text = cell.restaurant.name;
    cell.category.text = cell.restaurant.categoryString;
    cell.numberOfStars.text = cell.restaurant.starRating;
    cell.price.text = cell.restaurant.priceRating;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

@end

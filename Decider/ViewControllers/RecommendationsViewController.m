//
//  RecommendationsViewController.m
//  Decider
//
//  Created by marialepestana on 7/26/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "RecommendationsViewController.h"
#import "Parse/Parse.h"
#import "RecommendationCell.h"
#import "Restaurant.h"
#import "Routes.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "DetailsViewController.h"

@interface RecommendationsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *recommendations;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) Restaurant *currentRestaurant;

@end

@implementation RecommendationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchRecommendations];
}


- (void)fetchRecommendations {
    UIView *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    [hud showAnimated:YES];
    NSURLSessionDataTask *locationTask = [Routes fetchRecommendationsIn:self.location withLikedPhotos:self.foodLiked andHatedPhotos:self.foodUnliked completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
    
//    self.currentRestaurant = [[Restaurant alloc] initWithDictionary:restaurantDict];
//    cell.restaurantName.text = self.currentRestaurant.name;
//    cell.category.text = self.currentRestaurant.categoryString;
//    cell.numberOfStars.text = self.currentRestaurant.starRating;
//    cell.price.text = self.currentRestaurant.priceRating;
    
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (IBAction)didTapHome:(UIButton *)sender {
    [self.tabBarController.tabBar setHidden:NO];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
//    homeViewController.hidesBottomBarWhenPushed = NO;
//
    [self showViewController:homeViewController sender:self];
//    [self.tabBarController setSelectedIndex:0];
    
    
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    HomeViewController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
//    // homeViewController.hidesBottomBarWhenPushed = NO;
//
//    appDelegate.window.rootViewController = homeViewController;
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"viewSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        NSDictionary *restaurantDictionary = self.recommendations[indexPath.row];
        NSLog(@"%@", restaurantDictionary);
        Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:restaurantDictionary];
        DetailsViewController *detailsViewController =  [segue destinationViewController];
        detailsViewController.restaurant = restaurant;
        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        DetailsViewController *detailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailsVC"];
//        detailsViewController.restaurant = self.currentRestaurant;
//        [self presentViewController:detailsViewController animated:YES completion:nil];
    }
}


@end

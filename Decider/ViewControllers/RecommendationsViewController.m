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
    Restaurant* recommendedRestaurant = [[Restaurant alloc] initWithDictionary:restaurantDict];
   
    PFUser *currentUser = [PFUser currentUser];
    NSMutableArray *hatedRestaurants = [currentUser objectForKey:@"hatedRestaurants"];
    NSMutableArray *likedRestaurants = [currentUser objectForKey:@"likedRestaurants"];
    NSMutableArray *savedRestaurants = [currentUser objectForKey:@"savedRestaurants"];
    
    if([likedRestaurants containsObject:recommendedRestaurant.yelpid]) {
        cell.isLiked = YES;
        
    } else {
        cell.isLiked = NO;
    }
    
    if([hatedRestaurants containsObject:recommendedRestaurant.yelpid]) {
        cell.isHated = YES;
        
    } else {
        cell.isHated = NO;
    }
    
    if([savedRestaurants containsObject:recommendedRestaurant.yelpid]) {
        cell.isSaved = YES;
        
    } else {
        cell.isSaved = NO;
    }
    [cell setRestaurant:recommendedRestaurant];
    
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendations.count;
}

- (IBAction)didTapHome:(UIButton *)sender {    
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
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

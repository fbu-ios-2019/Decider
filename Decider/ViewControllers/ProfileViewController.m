//
//  ProfileViewController.m
//  Decider
//
//  Created by marialepestana on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "EditProfileViewController.h"
#import "RecommendationCell.h"
#import "Restaurant.h"
#import "Routes.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "SettingsViewController.h"
#import "RecommendationsViewController.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, RecommendationCellDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Delegates
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self fetchRestaurantHistory];
    
    if(self.user == nil){
        self.user = [PFUser currentUser];
    }
    
    
    UILabel *navtitleLabel = [UILabel new];
    NSShadow *shadow = [NSShadow new];
    NSString *navTitle = self.user.username;
    NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:navTitle
                                                                    attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                                                                                 NSForegroundColorAttributeName : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8],
                                                                                 NSShadowAttributeName : shadow}];
    navtitleLabel.attributedText = titleText;
    [navtitleLabel sizeToFit];
    self.navigationItem.titleView = navtitleLabel;
    self.nameLabel.text = [self.user objectForKey:@"name"];
    self.usernameLabel.text = self.user.username;
}

-(void) viewWillAppear:(BOOL)animated {
    [self fetchRestaurantHistory];
}
- (void)viewDidAppear:(BOOL)animated {
    PFFileObject *image = [self.user objectForKey:@"profilePicture"];
    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        self.profileView.image = [UIImage imageWithData:data];
    }];
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height/5;
    self.nameLabel.text = [self.user objectForKey:@"name"];
}


- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(PFUser.currentUser == nil) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            appDelegate.window.rootViewController = loginViewController;
            
            NSLog(@"User logged out successfully");
        } else {
            NSLog(@"Error logging out: %@", error);
        }
    }];
}


- (void)fetchRestaurantHistory {
    self.user = [PFUser currentUser];
    self.savedRestaurants = [self.user objectForKey:@"savedRestaurants"];
    self.hatedRestaurants = [self.user objectForKey:@"hatedRestaurants"];
    self.likedRestaurants = [self.user objectForKey:@"likedRestaurants"];
    [self fetchSavedRestaurantsDetails];
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RecommendationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendationCell" forIndexPath:indexPath];
    
    // Update cell with data
    NSDictionary *restaurantDict = self.savedRestaurantDetails[indexPath.row];
    Restaurant* newRestaurant = [[Restaurant alloc] initWithDictionary:restaurantDict];
    
    if([self.likedRestaurants containsObject:newRestaurant.yelpid]) {
        cell.isLiked = YES;
        
    } else {
        cell.isLiked = NO;
    }
    
    if([self.hatedRestaurants containsObject:newRestaurant.yelpid]) {
        cell.isHated = YES;
        
    } else {
        cell.isHated = NO;
    }
    
    if([self.savedRestaurants containsObject:newRestaurant.yelpid]) {
        cell.isSaved = YES;
        
    } else {
        cell.isSaved = NO;
    }
    
    [cell setRestaurant:newRestaurant];
    cell.delegate = self;
    
    return cell;
}

-(void) restaurantHistoryChanged {
    [self fetchRestaurantHistory];
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.savedRestaurants.count;
}
- (IBAction)didTapSettings:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingsViewController *settingsController = [storyboard instantiateViewControllerWithIdentifier:@"settingsViewController"];
    [self showViewController:settingsController sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editProfileSegue"]) {
        EditProfileViewController *editProfileViewController =  [segue destinationViewController];
        editProfileViewController.user = self.user;
    }
}

-(void) fetchSavedRestaurantsDetails {
    [self.tableView setHidden:YES];
    UIView *window = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    [hud showAnimated:YES];
    
    NSURLSessionDataTask *task = [Routes fetchSavedRestaurantsFromIds:self.savedRestaurants completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.savedRestaurantDetails = [results objectForKey:@"results"];
        [self.tableView reloadData];
        [self.tableView setHidden:NO];
        [hud hideAnimated:YES];
    }];
    if(!task) {
        NSLog(@"Network error");
    }
    
}


@end

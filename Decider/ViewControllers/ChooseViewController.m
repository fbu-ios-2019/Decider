//
//  ChooseViewController.m
//  Decider
//
//  Created by kchan23 on 7/30/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "ChooseViewController.h"
#import "Routes.h"
#import "ChooseCell.h"
#import "SwipeViewController.h"

@interface ChooseViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *categorySearchBar;
@property (weak, nonatomic) IBOutlet UISearchBar *locationSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *categoryData;
@property (strong, nonatomic) NSArray *filteredCategoryData;
@property (strong, nonatomic) NSArray *locationData;
@property (strong, nonatomic) NSArray *filteredLocationData;
@property (assign, nonatomic) BOOL isLocationSearchBar;

@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.categorySearchBar.delegate = self;
    self.locationSearchBar.delegate = self;
    [self.locationSearchBar setImage:[UIImage imageNamed:@"map-marker"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    UITextField *textField = [self.locationSearchBar valueForKey:@"searchField"];
    textField.text = @"Current Location";
    textField.textColor = UIColor.blueColor;
    
    [self fetchCategories];
    [self fetchLocations];
}

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChooseCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChooseCell"
                                                            forIndexPath:indexPath];
    if(self.isLocationSearchBar) { //check for location search bar
        if(indexPath.row == 0){
            cell.textLabel.text = @"Current Location";
            cell.textLabel.textColor = UIColor.blueColor;
        }
        else {
            cell.textLabel.text = self.filteredLocationData[indexPath.row - 1];
        }
    }
    else { //check for category search bar
        cell.textLabel.textColor = UIColor.blackColor;
        cell.textLabel.text = self.filteredCategoryData[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.isLocationSearchBar) { //check for location search bar
        return self.filteredLocationData.count + 1;
    }
    else { //check for category search bar
        return self.filteredCategoryData.count;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchBarTextDidBeginEditing:searchBar];
    if(self.isLocationSearchBar) { //check for location search bar
        if (searchText.length != 0) {
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
                return [evaluatedObject containsString:searchText];
            }];
            self.filteredLocationData = [self.locationData filteredArrayUsingPredicate:predicate];
            NSLog(@"%@", self.filteredLocationData);
        }
        else {
            self.filteredLocationData = self.locationData;
        }
    }
    else { //check for category search bar
        if (searchText.length != 0) {
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
                return [evaluatedObject containsString:searchText];
            }];
            self.filteredCategoryData = [self.categoryData filteredArrayUsingPredicate:predicate];
            NSLog(@"%@", self.filteredCategoryData);
        }
        else {
            self.filteredCategoryData = self.categoryData;
        }
    }
    [self.tableView reloadData];
}

// Function that fetches categories
-(void)fetchCategories {
    NSURLSessionDataTask *categoryTask = [Routes fetchCategories:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.categoryData = [results objectForKey:@"results"];
            self.filteredCategoryData = self.categoryData;
        }
    }];
    if (!categoryTask) {
        NSLog(@"There was a network error");
    }
}

// Function that fetches locations
- (void)fetchLocations {
    NSURLSessionDataTask *locationTask = [Routes fetchLocations:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.locationData = [results objectForKey:@"results"];
            self.filteredLocationData = self.locationData;
        }
    }];
    if (!locationTask) {
        NSLog(@"There was a network error");
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if(searchBar == self.locationSearchBar) {
        self.isLocationSearchBar = YES;
        UITextField *textField = [self.locationSearchBar valueForKey:@"searchField"];
        if([textField.text isEqualToString:@"Current Location"]){
            textField.text = @"";
        }
    }
    else {
        self.isLocationSearchBar = NO;
    }
    self.tableView.hidden = YES;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(self.isLocationSearchBar && ([cell.textLabel.text isEqualToString:@"Current Location"] || [self.locationData containsObject:cell.textLabel.text])) {
        UITextField *textField = [self.locationSearchBar valueForKey:@"searchField"];
        if([cell.textLabel.text isEqualToString:@"Current Location"]) {
            textField.textColor = UIColor.blueColor;
        }
        else {
            textField.textColor = UIColor.blackColor;
        }
        self.locationSearchBar.text = cell.textLabel.text;
    }
    else if(!self.isLocationSearchBar && [self.categoryData containsObject:cell.textLabel.text]) {
        self.categorySearchBar.text = cell.textLabel.text;
    }
}

- (IBAction)didTapSwipe:(id)sender {
    if([self.categoryData containsObject:self.categorySearchBar.text] && ([self.locationSearchBar.text isEqualToString:@"Current Location"] || [self.locationData containsObject:self.locationSearchBar.text])) {
        NSLog(@"YAY");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SwipeViewController *swipeViewController = [storyboard instantiateViewControllerWithIdentifier:@"swipeViewController"];
        swipeViewController.category = self.categorySearchBar.text;
        swipeViewController.location = [[self.locationSearchBar.text componentsSeparatedByString:@","] objectAtIndex:0];
        [self showViewController:swipeViewController sender:self];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cannot Swipe"
                                                                                 message:@"Please choose category and location."
                                                                          preferredStyle:(UIAlertControllerStyleAlert)];
        // create an error action
        UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  // handle try again response here. Doing nothing will dismiss the view.
                                                              }];
        
        // add the error action to the alertController
        [alertController addAction:okAlertAction];
        
        [self presentViewController:alertController animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }
}

@end

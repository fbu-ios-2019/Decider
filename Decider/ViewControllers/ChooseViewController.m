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

@interface ChooseViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *categorySearchBar;
@property (weak, nonatomic) IBOutlet UISearchBar *locationSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *categoryData;
@property (strong, nonatomic) NSArray *filteredCategoryData;
@property (strong, nonatomic) NSArray *locationData;
@property (strong, nonatomic) NSArray *filteredLocationData;
@property (assign, nonatomic) BOOL isCategorySearchBar;

@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.categorySearchBar.delegate = self;
    self.locationSearchBar.delegate = self;
    
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
    //[self searchBarTextDidBeginEditing:self.categorySearchBar];
    if(self.isCategorySearchBar) {//[self searchBarShouldBeginEditing:self.categorySearchBar]) {//self.isCategorySearchBar) {//check for category search bar
        cell.textLabel.text = self.filteredCategoryData[indexPath.row];
    }
    else { //check for location search bar
        cell.textLabel.text = self.filteredLocationData[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    [self searchBarTextDidBeginEditing:self.categorySearchBar];
    if(self.isCategorySearchBar) { //check for category search bar
        return self.filteredCategoryData.count;
    }
    else { //check for location search bar
        return self.filteredLocationData.count;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchBarTextDidBeginEditing:searchBar];
    if(self.isCategorySearchBar) { //check for category search bar
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
    else { //check for location search bar
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
            
            // NSLog(@"%@", results);
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
            
            // NSLog(@"%@", results);
            self.locationData = [results objectForKey:@"results"];
            self.filteredLocationData = self.locationData;
        }
    }];
    if (!locationTask) {
        NSLog(@"There was a network error");
    }
}

//-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    if(searchBar == self.categorySearchBar) {
//        return YES;
//    }
//    else {
//        return NO;
//    }
//}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if(searchBar == self.categorySearchBar) {
        self.isCategorySearchBar = YES;
    }
    else {
        self.isCategorySearchBar = NO;
    }
}

//-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
//    if(searchBar == self.categorySearchBar) {
//        return YES;
//    }
//    else {
//        return NO;
//    }
//}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    if(searchBar == self.categorySearchBar) {
//        self.isCategorySearchBar = YES;
//    }
//    else {
//        self.isCategorySearchBar = NO;
//    }
//}


@end

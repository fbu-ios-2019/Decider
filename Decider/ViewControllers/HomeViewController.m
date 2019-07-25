//
//  HomeViewController.m
//  Decider
//
//  Created by kchan23 on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "HomeViewController.h"
#import "Routes.h"
#import "SwipeViewController.h"
#import "CityCell.h"
#import "MKDropdownMenu.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MKDropdownMenuDataSource, MKDropdownMenuDelegate>


//@property (weak, nonatomic) IBOutlet UIButton *decideButton;

@property (weak, nonatomic) IBOutlet UIButton *swipeButton;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *startSwipingLabel;


@property (strong, nonatomic) NSArray *restaurants;

// Categories
// Array with all the categories passed to the picker
@property (strong, nonatomic) NSMutableArray *categories;

// Location
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;
// Search bar
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;
@property (strong, nonatomic) NSArray *cities;
@property (strong, nonatomic) NSArray *filteredData;
@property (weak, nonatomic) IBOutlet UISearchBar *locationsSearchBar;
@property (weak, nonatomic) IBOutlet UILabel *selectedCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedLocationLabel;
//@property (weak, nonatomic) IBOutlet UIButton *selectedLocationButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // UI
    self.swipeButton.layer.cornerRadius = 6;
    // self.startButton.layer.cornerRadius = 2;
    self.startSwipingLabel.layer.cornerRadius = 4;
    
    
        // Delegates
    // Location delegates
    self.locationManager = [[CLLocationManager alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];
    
    // Table view delegates
    self.locationsTableView.delegate = self;
    self.locationsTableView.dataSource = self;
    
    // Search bar delegates
    self.locationsSearchBar.delegate = self;
    
    // Locations table view style
    [self.locationsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Fetch information
    //[self fetchRestaurants];
    [self fetchCategories];
    [self fetchLocations];
    [self getCurrentLocation];
    
    // Search bar style
    self.selectedCategoryLabel.layer.cornerRadius = 6;
    self.locationsSearchBar.placeholder = @"";
    // self.locationsSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    self.locationsSearchBar.layer.borderWidth = 0;
    self.locationsSearchBar.layer.borderColor = [UIColor clearColor].CGColor;
    self.locationsSearchBar.layer.cornerRadius = 4;
     self.locationsSearchBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:98.0/255.0 blue:19.0/255.0 alpha:1.0];
     self.locationsSearchBar.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:98.0/255.0 blue:19.0/255.0 alpha:1.0];
    
    // Text field of search bar
    UITextField *textField = [self.locationsSearchBar valueForKey:@"_searchField"];
    textField.textColor = [UIColor darkGrayColor];
    textField.placeholder = @"Current location";
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.backgroundColor = [UIColor whiteColor];
    // textField.backgroundColor = [UIColor colorWithRed:255/255.0 green:246/255.0 blue:241/255.0 alpha:1.0];
    // textField.font = [UIFont systemFontOfSize:22.0];
    textField.font = [UIFont systemFontOfSize:20 weight:UIFontWeightThin];
    [textField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
//    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    textField.textAlignment = NSTextAlignmentCenter;
    imgview.image = [UIImage imageNamed:@"searchIcon.png"];
    
    textField.rightView = imgview;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    self.locationsSearchBar.searchTextPositionAdjustment = UIOffsetMake(self.locationsSearchBar.layer.frame.size.width/4, 0);
    
    self.locationsTableView.layer.borderWidth = 0;
    self.locationsTableView.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:98.0/255.0 blue:19.0/255.0 alpha:1.0].CGColor;
    
    self.selectedLocationLabel.layer.cornerRadius = 6;
    // self.locationsTableView.hidden = YES;
    
    // Dropdown menu for category
    MKDropdownMenu *dropdownMenu = [[MKDropdownMenu alloc] initWithFrame:CGRectMake(12, 403, 351, 44)];
    dropdownMenu.dataSource = self;
    dropdownMenu.delegate = self;
    [self.view addSubview:dropdownMenu];
    
    dropdownMenu.rowSeparatorColor = [UIColor lightGrayColor];
//    dropdownMenu.dropdownBackgroundColor = [UIColor lightGrayColor];
    dropdownMenu.backgroundDimmingOpacity = -0.05;
    dropdownMenu.dropdownCornerRadius = 8;
    
    
    // Change category text field to what the user selected on the category picker
    self.selectedCategoryLabel.text =  self.categories[dropdownMenu.selectedComponent];
    
    
    
    // Tap gesture for location
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.selectedLocationLabel setUserInteractionEnabled:YES];
    [self.selectedLocationLabel addGestureRecognizer:singleFingerTap];

}


// Function that fetches locations for the locations search bar
- (void)fetchLocations {
    NSURLSessionDataTask *locationTask = [Routes fetchLocations:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // NSLog(@"%@", results);
            self.cities = [results objectForKey:@"results"];
            self.filteredData = self.cities;
        }
        
    }];
    if (!locationTask) {
        NSLog(@"There was a network error");
    }
}


// Function that fetches categories from database
-(void)fetchCategories {
    NSURLSessionDataTask *categoryTask = [Routes fetchCategories:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // NSLog(@"%@", results);
            self.categories = [results objectForKey:@"results"];
            // NSLog(@"%@", self.categories);
        }
        
    }];
    if (!categoryTask) {
        NSLog(@"There was a network error");
    }
}

#pragma mark - Navigation

// Function to prepare before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"swipeSegue"]) {
        SwipeViewController *swipeViewController = [segue destinationViewController];
        swipeViewController.category = self.category;
        swipeViewController.location = nil;
    }
}

// Category functions start

#pragma mark - MKDropdownMenuDataSource

- (NSInteger)dropdownMenu:(nonnull MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return 20;
}

- (NSInteger)numberOfComponentsInDropdownMenu:(nonnull MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForComponent:(NSInteger)component {
    self.selectedCategoryLabel.text = @"Category";
    return @"";
    
}

#pragma mark - MKDropdownMenuDelegate

- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.categories[row];
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedCategoryLabel.text = self.categories[row];
    self.category = self.categories[row];
    [dropdownMenu closeAllComponentsAnimated:YES];
}

// Function to change the row's font color and size
- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[NSAttributedString alloc] initWithString:self.categories[row]
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20 weight:UIFontWeightThin],
                       NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
}

// Category functions end


// Location functions start


// Function that gets current location
- (void)getCurrentLocation {
    [self.locationManager requestAlwaysAuthorization];
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services are not enabled");
    }
}


// Function that handles the selected location using a tap gesture to change the value of the label
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    self.selectedLocationLabel.hidden = YES;
    self.locationsTableView.hidden = NO;
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError: %@", error);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Failed to Get Your Location."
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    // create an error action
    UIAlertAction *errorAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            // handle try again response here. Doing nothing will dismiss the view.
                                                        }];
    
    // add the error action to the alertController
    [alert addAction:errorAction];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = [locations lastObject];
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        // self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        // self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
            self.location = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                             self.placemark.subThoroughfare,
                             self.placemark.thoroughfare,
                             self.placemark.postalCode,
                             self.placemark.locality,
                             self.placemark.administrativeArea,
                             self.placemark.country];
        }
        else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
}


// Search bar functions begin
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CityCell *cell = [self.locationsTableView dequeueReusableCellWithIdentifier:@"CityCell" forIndexPath:indexPath];
    
    NSString *city;
    
    if (self.filteredData != nil) {
        // self.filteredData[0] =
        city = self.filteredData[indexPath.row];
    } else {
        city = self.cities[indexPath.row];
    }
    
    cell.cityLabel.text = city;
    
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedLocationLabel.text = self.filteredData[indexPath.row];
    self.location = self.filteredData[indexPath.row];
    self.locationsSearchBar.text = self.filteredData[indexPath.row];
    self.locationsSearchBar.searchTextPositionAdjustment = UIOffsetMake(self.locationsSearchBar.layer.frame.size.width/4, 0);
    // self.locationsTableView.hidden = YES;
    // self.selectedLocationLabel.hidden = NO;
//    // [self.view endEditing:YES];
//    self.locationsSearchBar.showsCancelButton = NO;
    [self.locationsSearchBar resignFirstResponder];
    // [self searchBarCancelButtonClicked:self.locationsSearchBar];
    

    
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.locationsTableView.hidden = NO;
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject containsString:searchText];
        }];
        self.filteredData = [self.cities filteredArrayUsingPredicate:predicate];
        // [self.filteredData insertObject:@"All" atIndex:0];
        
        NSLog(@"%@", self.filteredData);
        
    }
    else {
        self.filteredData = self.cities;
    }
    
    [self.locationsTableView reloadData];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // self.locationsSearchBar.showsCancelButton = YES;
    self.locationsSearchBar.searchTextPositionAdjustment = UIOffsetMake(0, 0);
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.locationsSearchBar.showsCancelButton = NO;
    self.locationsTableView.hidden = NO;
    self.locationsSearchBar.text = @"";
    [self.locationsSearchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
}

// Search bar functions end

// Location functions end


@end

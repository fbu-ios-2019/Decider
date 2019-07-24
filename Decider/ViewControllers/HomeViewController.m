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
    self.startButton.layer.cornerRadius = 2;
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
    [self fetchRestaurants];
    [self fetchCategories];
    [self fetchLocations];
    [self getCurrentLocation];
    
    self.selectedCategoryLabel.layer.cornerRadius = 6;
    self.locationsSearchBar.placeholder = @"Location";
    self.locationsSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    self.selectedLocationLabel.layer.cornerRadius = 6;
    self.locationsTableView.hidden = YES;
    
    // Dropdown menu for category
    MKDropdownMenu *dropdownMenu = [[MKDropdownMenu alloc] initWithFrame:CGRectMake(11, 404, 320, 44)];
    dropdownMenu.dataSource = self;
    dropdownMenu.delegate = self;
    [self.view addSubview:dropdownMenu];
    
    // Change category text field to what the user selected on the category picker
    // self.categoryTextField.inputView = picker
    self.selectedCategoryLabel.text =  self.categories[dropdownMenu.selectedComponent];
    
    
    
    // Tap gesture for location
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.selectedLocationLabel setUserInteractionEnabled:YES];
    [self.selectedLocationLabel addGestureRecognizer:singleFingerTap];

}

// Function that fetches restaurants from database
- (void)fetchRestaurants {
    NSURLSessionDataTask *task = [Routes fetchRestaurantsOfCategory:@"all" nearLocation:@"Mountain View" offset:0 completionHandler:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@", results);
            self.restaurants = [results objectForKey:@"results"];
        }
        
    }];
    if (!task) {
        NSLog(@"There was a network error");
    }
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
    // --------->>>>>>> PUT THIS IN A BUTTON
    if([segue.identifier isEqualToString:@"swipeSegue"]) {
        // Get the new view controller using
        SwipeViewController *swipeViewController = [segue destinationViewController];
        // Pass restaurants to the next view controller
        swipeViewController.restaurants = self.restaurants;
    }
}

// Category functions start

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

- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.categories[row];
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedCategoryLabel.text = self.categories[row];
    self.category = self.categories[row];
    [dropdownMenu closeAllComponentsAnimated:YES];
}

// Category functions end


// Location functions start

//- (IBAction)didTapChangeLocation:(UIButton *)sender {
//    self.locationsTableView.hidden = NO;
//    self.selectedLocationButton.hidden = YES;
//}


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
    self.locationsTableView.hidden = YES;
    self.selectedLocationLabel.hidden = NO;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.locationsTableView.hidden = NO;
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject containsString:searchText];
        }];
        self.filteredData = [self.cities filteredArrayUsingPredicate:predicate];
        
        NSLog(@"%@", self.filteredData);
        
    }
    else {
        self.filteredData = self.cities;
    }
    
    [self.locationsTableView reloadData];
    
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.locationsSearchBar.showsCancelButton = YES;
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.locationsSearchBar.showsCancelButton = NO;
    self.locationsTableView.hidden = NO;
    self.locationsSearchBar.text = @"";
    [self.locationsSearchBar resignFirstResponder];
}

// Search bar functions end

// Location functions end


@end

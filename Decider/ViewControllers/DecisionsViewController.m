//
//  DecisionsViewController.m
//  Decider
//
//  Created by marialepestana on 7/19/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "DecisionsViewController.h"
#import "Routes.h"
#import "SwipeViewController.h"

@interface DecisionsViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSArray *restaurants;

    // Categories
// Picker view for category
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;
// Array with all the categories passed to the picker
@property (strong, nonatomic) NSMutableArray *categories;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;

// Location
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;

@end


@implementation DecisionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Category delegates
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource = self;
    self.categoryTextField.inputView = self.categoryPicker;
    
    self.categoryPicker.hidden = YES;
    
    // Location delegates
    self.locationManager = [[CLLocationManager alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];
    
    // Fetch restaurants from database
    NSURLSessionDataTask *task = [Routes fetchRestaurantsOfType:@"all" nearLocation:@"Sunnyvale" offset:0 count:20 completionHandler:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@", results);
            self.restaurants = results;
        }
        
    }];
    if (!task) {
        NSLog(@"There was a network error");
    }
    
    // Fetch categories from database
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

- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:YES];
    self.categoryPicker.hidden = YES;
}

- (IBAction)didTapCancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

// Function to prepare before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"swipeSegue"]) {
        // Get the new view controller using
        SwipeViewController *swipeViewController = [segue destinationViewController];
        // Pass restaurants to the next view controller
        swipeViewController.restaurants = self.restaurants;
    }
}

// Category functions start


- (IBAction)didTapDropdown:(id)sender {
    
    self.categoryPicker.hidden = NO;
}


// Protocol method that returns the number of columns (per row)
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    // Hard coded number of categories we want to display
    return 1;
}


// Protocol method that returns the number of rows
- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
     // return self.categories.count;
    return 20;
}


// Protocol mehtod that returns the data to display for the row and column that's being passed
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.categories[row];
}


// Protocol method to save the user's selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.category = self.categories[row];
    NSLog(@"User selected %@", self.categories[row]);
    
    self.categoryTextField.text = self.categories[row];
    
}
// Category functions end


// Location functions start
- (IBAction)getCurrentLocation:(id)sender {
    [self.locationManager requestAlwaysAuthorization];
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services are not enabled");
    }
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
            self.address = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                      self.placemark.subThoroughfare, self.placemark.thoroughfare,
                                      self.placemark.postalCode, self.placemark.locality,
                                      self.placemark.administrativeArea,
                                      self.placemark.country];
        }
        else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
}
// Location functions end

@end

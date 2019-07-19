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

@interface HomeViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSDictionary *restaurants;

// Picker view for category
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;

// Array with all the categories passed to the picker
@property (strong, nonatomic) NSMutableArray *categories;

@property (weak, nonatomic) IBOutlet UIButton *decideButton;

@property (weak, nonatomic) IBOutlet UIButton *swipeButton;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource = self;
    
    self.decideButton.layer.cornerRadius = 6;
    self.swipeButton.layer.cornerRadius = 6;

    NSURLSessionDataTask *task = [Routes fetchRestaurantsOfType:@"mexican" nearLocation:@"Sunnyvale" completionHandler:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // NSLog(@"%@", results);
            self.restaurants = results;
        }
        
    }];
    if (!task) {
        NSLog(@"There was a network error");
    }
    
    // Categories
    self.categories = [NSMutableArray arrayWithObjects:@"African", @"American", @"Barbeque", @"Brazilian", @"Breakfast & Brunch", @"Buffets", @"Coffee shops", @"Caribean", @"Chinese", @"Fast food", @"French", @"German", @"Indian", @"Italian", @"Japanese", @"Korean", @"Mediterranean", @"Mexican", @"Pizza", @"Salad", @"Sandwiches", @"Seafood", @"Thai", @"Vegan", @"Vegetarian", @"Vietnamese", nil];
//    NSString *category = @"African";
//    [self.categories addObject:category];
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"swipeSegue"]) {
        SwipeViewController *swipeViewController = [segue destinationViewController];
        swipeViewController.restaurants = self.restaurants;
    }
}



// Protocol method that returns the number of columns (per row)
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    // Hard coded number of categories we want to display
    return 1;
}


// Protocol method that returns the number of rows
- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // Hard coded number of categories we want to display
    return self.categories.count;
}


// Protocol mehtod that returns the data to display for the row and column that's being passed
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.categories[row];
}

// Protocol method to save the user's selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.category = self.categories[row];
    NSLog(@"User selected %@", self.categories[row]);
}

@end

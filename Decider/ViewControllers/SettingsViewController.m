//
//  SettingsViewController.m
//  Decider
//
//  Created by mudi on 8/1/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.priceControl.selectedSegmentIndex = [defaults integerForKey:@"price_index"];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(didTapDone:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    doneButton.tintColor = UIColor.orangeColor;
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
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (IBAction)didTapDone:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didChangePrice:(id)sender {
    NSUInteger priceIndex = self.priceControl.selectedSegmentIndex;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:priceIndex forKey:@"price_index"];
    [defaults synchronize];
}



@end

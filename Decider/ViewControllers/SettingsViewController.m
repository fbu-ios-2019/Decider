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
    self.optionsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.priceControl.selectedSegmentIndex = [defaults integerForKey:@"price_index"];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(didTapDone:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    doneButton.tintColor = UIColor.orangeColor;
    
    NSMutableArray *options = [defaults objectForKey:@"restaurant_criteria"];
    if (!options) {
        options = [[NSMutableArray alloc] initWithObjects:@"price", @"your swipes", @"others likes/dislikes", @"review count", @"rating", nil];
    }
    self.optionsArray = [NSMutableArray arrayWithArray:options];
    self.optionsTableView.delegate = self;
    self.optionsTableView.dataSource = self;
    [self.optionsTableView setEditing:YES animated:YES];
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
//    UITableViewCell *cell = [[UITableViewCell alloc] init];
//    return cell;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rankCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rankCell"];
    }
    
    cell.textLabel.text = [self.optionsArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.optionsArray.count;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.optionsArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    [self.optionsTableView reloadData];
}


- (IBAction)didTapDone:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.optionsArray forKey:@"restaurant_criteria"];
    [defaults synchronize];
}

- (IBAction)didChangePrice:(id)sender {
    NSUInteger priceIndex = self.priceControl.selectedSegmentIndex;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:priceIndex forKey:@"price_index"];
    [defaults synchronize];
}



@end

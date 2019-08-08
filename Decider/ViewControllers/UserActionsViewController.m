//
//  UserActionsViewController.m
//  Decider
//
//  Created by mudi on 8/8/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "UserActionsViewController.h"

@interface UserActionsViewController ()

@end

@implementation UserActionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.helpIcon setImage:[UIImage imageNamed:@"help-icon"]];
    [self.aboutIcon setImage:[UIImage imageNamed:@"info-icon"]];
}
- (IBAction)changePreferences:(id)sender {
    [self performSegueWithIdentifier:@"preferenceSegue" sender:self];
}

- (IBAction)editProfile:(id)sender {
    [self performSegueWithIdentifier:@"profileEditSegue" sender:self];
}
- (IBAction)getHelp:(id)sender {
    [self performSegueWithIdentifier:@"helpSegue" sender:self];
}

- (IBAction)viewAbout:(id)sender {
    [self performSegueWithIdentifier:@"aboutSegue" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

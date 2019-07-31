//
//  LoginViewController.m
//  Decider
//
//  Created by kchan23 on 7/24/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        
        NSLog(@"%@", error);
        NSLog(@"%@", user);
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cannot Log In"
                                                                                         message:@"Please enter username and password."
                                                                                  preferredStyle:(UIAlertControllerStyleAlert)];
                // create a try again action
                UIAlertAction *tryAgainAlertAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                              style:UIAlertActionStyleCancel
                                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                                // handle try again response here. Doing nothing will dismiss the view.
                                                                            }];
                // add the try again action to the alertController
                [alertController addAction:tryAgainAlertAction];
                
                [self presentViewController:alertController animated:YES completion:^{
                    // optional code for what happens after the alert controller has finished presenting
                }];
            }
            else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cannot Log In"
                                                                                         message:@"Wrong username or password."
                                                                                  preferredStyle:(UIAlertControllerStyleAlert)];
                // create a try again action
                UIAlertAction *tryAgainAlertAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                              style:UIAlertActionStyleCancel
                                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                                // handle try again response here. Doing nothing will dismiss the view.
                                                                            }];
                // add the try again action to the alertController
                [alertController addAction:tryAgainAlertAction];
                
                [self presentViewController:alertController animated:YES completion:^{
                    // optional code for what happens after the alert controller has finished presenting
                }];
            }
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
    
    //    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
    //
    //    }];
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

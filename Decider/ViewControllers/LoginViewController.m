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
                [self emptyLogin];
            }
            else {
                [self loginValidation];
            }
        } else {
            NSLog(@"User logged in successfully");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.view.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (void)emptyLogin {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cannot Log In"
                                                                             message:@"Please enter username and password."
                                                                      preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *tryAgainAlertAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                  style:UIAlertActionStyleCancel
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                }];
    [alertController addAction:tryAgainAlertAction];
    
    [self presentViewController:alertController animated:YES completion:^{
    }];
}

- (void)loginValidation {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cannot Log In"
                                                                             message:@"Wrong username or password."
                                                                      preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *tryAgainAlertAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                  style:UIAlertActionStyleCancel
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                }];
    [alertController addAction:tryAgainAlertAction];
    
    [self presentViewController:alertController animated:YES completion:^{
    }];
}

- (IBAction)didTapBack:(id)sender {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
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

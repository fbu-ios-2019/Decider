//
//  SignupViewController.m
//  Decider
//
//  Created by kchan23 on 7/24/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "SignupViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapSignin:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self showViewController:loginViewController sender:self];}

- (IBAction)didTapRegister:(id)sender {
    [self registerUser];
}

- (void)registerUser {
    PFUser *newUser = [PFUser user];
    [newUser setObject:self.nameField.text forKey:@"name"];
    [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
        }
    }];
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    
    if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
        [self passwordMatchValidation];
    }
    else {
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                if ([self.usernameField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""]) {
                    [self signupValidation];
                }
                else if ([self.emailField.text rangeOfString:@"@"].location == NSNotFound) {
                    [self emailValidation];
                }
            } else {
                NSLog(@"User registered successfully");
                [self registerComplete];
            }
        }];
    }
}

- (void)signupValidation {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Sign Up"
                                                                   message:@"Please enter username and password."
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *usernameAlert = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                          }];
    [alert addAction:usernameAlert];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)passwordMatchValidation {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Sign Up"
                                                                   message:@"Password does not match."
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *passwordAlert = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                          }];
    [alert addAction:passwordAlert];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)emailValidation {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Sign Up"
                                                                   message:@"Please enter valid email."
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *passwordAlert = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                          }];
    [alert addAction:passwordAlert];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)registerComplete {
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        NSLog(@"%@", error);
        NSLog(@"%@", user);
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.view.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
            [self.view endEditing:YES];
        }
    }];
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

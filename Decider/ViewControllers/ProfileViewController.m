//
//  ProfileViewController.m
//  Decider
//
//  Created by marialepestana on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "EditProfileViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) PFUser *user;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.user == nil){
        self.user = [PFUser currentUser];
    }
    
    UILabel *navtitleLabel = [UILabel new];
    NSShadow *shadow = [NSShadow new];
    NSString *navTitle = self.user.username;
    NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:navTitle
                                                                    attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                                                                                 NSForegroundColorAttributeName : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8],
                                                                                 NSShadowAttributeName : shadow}];
    navtitleLabel.attributedText = titleText;
    [navtitleLabel sizeToFit];
    self.navigationItem.titleView = navtitleLabel;
    self.nameLabel.text = [self.user objectForKey:@"name"];
    self.usernameLabel.text = self.user.username;
}

- (void)viewDidAppear:(BOOL)animated {
    PFFileObject *image = [self.user objectForKey:@"profilePicture"];
    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        self.profileView.image = [UIImage imageWithData:data];
    }];
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height/5;
    self.nameLabel.text = [self.user objectForKey:@"name"];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(PFUser.currentUser == nil) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            appDelegate.window.rootViewController = loginViewController;
            
            NSLog(@"User logged out successfully");
        } else {
            NSLog(@"Error logging out: %@", error);
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editProfileSegue"]) {
        EditProfileViewController *editProfileViewController =  [segue destinationViewController];
        editProfileViewController.user = self.user;
    }
}


@end

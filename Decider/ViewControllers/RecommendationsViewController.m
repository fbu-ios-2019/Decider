//
//  RecommendationsViewController.m
//  Decider
//
//  Created by marialepestana on 7/18/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "RecommendationsViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

@interface RecommendationsViewController ()

@end

@implementation RecommendationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapOk:(UIButton *)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    appDelegate.window.rootViewController = homeViewController;
    
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

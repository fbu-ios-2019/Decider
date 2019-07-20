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

@interface HomeViewController () 


@property (weak, nonatomic) IBOutlet UIButton *decideButton;

@property (weak, nonatomic) IBOutlet UIButton *swipeButton;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *searchButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.decideButton.layer.cornerRadius = 6;
    self.swipeButton.layer.cornerRadius = 6;
    self.startButton.layer.cornerRadius = 6;
    self.searchButton.layer.cornerRadius = 6;

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end

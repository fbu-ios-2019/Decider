//
//  SwipeViewController.m
//  Decider
//
//  Created by kchan23 on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "SwipeViewController.h"
#import "Food.h"
#import "Restaurant.h"
#import "Routes.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "DetailsViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "ProfileViewController.h"
#import "RecommendationsViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

static const CGFloat ChooseFoodButtonHorizontalPadding = 80.f;
static const CGFloat ChooseFoodButtonVerticalPadding = 20.f;

@interface SwipeViewController ()

@property (nonatomic, strong) NSMutableArray *food;
@property (nonatomic, strong) NSMutableArray *foodLiked;
@property (nonatomic, strong) NSMutableArray *foodUnliked;
@property (weak, nonatomic) IBOutlet UILabel *unlikeCount;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property long swipeTotal;
@property (nonatomic, copy) NSString *yelpid;
@property (nonatomic, strong) Restaurant *currentRestaurant;
@property (nonatomic, strong) NSArray *restaurants;

@end

@implementation SwipeViewController

#pragma mark - Object Lifecycle

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        _food = [[self defaultFood] mutableCopy];
//    }
//    return self;
//}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchRestaurants];
    [self.tabBarController.tabBar setHidden:YES];
}

/*- (NSUInteger)supportedInterfaceOrientations {
 return UIInterfaceOrientationMaskPortrait;
 }*/

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    //NSLog(@"You couldn't decide");
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    
    if (direction == MDCSwipeDirectionLeft) {
        //NSLog(@"You unliked");
        [self.foodUnliked addObject:self.currentFood.yelpid];
    } else {
        //NSLog(@"You liked");
        [self.foodLiked addObject:self.currentFood.yelpid];
    }
    
    self.unlikeCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.foodUnliked count]];
    self.likeCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.foodLiked count]];
    
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popFoodViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
    
    self.swipeTotal = (long)[self.foodLiked count] + (long)[self.foodUnliked count];
    if(self.swipeTotal % 5 == 0) {
        NSString *message1 = @"You have swiped ";
        NSString *message2 = [message1 stringByAppendingString:[NSString stringWithFormat:@"%ld", self.swipeTotal]];
        NSString *finalMessage = [message2 stringByAppendingString:@" times."];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"View Recommendations?"
                                                                                 message:finalMessage
                                                                          preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"View" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //button click event
            
            // Call review view controller and send it the restaurants
            //            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //            ProfileViewController *profileViewController = [storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
            //            profileViewController.foodLiked = self.foodLiked;
            //            profileViewController.foodUnliked = self.foodUnliked;
            //            [self showViewController:profileViewController sender:self];
            //            [self.tabBarController setSelectedIndex:1];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            RecommendationsViewController *recommendationsViewController = [storyboard instantiateViewControllerWithIdentifier:@"recommendationsVC"];
            recommendationsViewController.foodLiked = self.foodLiked;
            recommendationsViewController.foodUnliked = self.foodUnliked;
            recommendationsViewController.location = self.location;
            [self showViewController:recommendationsViewController sender:self];
            // [self.tabBarController setSelectedIndex:1];
            
        }];
        UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"Swipe More" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAlertAction];
        [alertController addAction:okAlertAction];
        
        [self presentViewController:alertController animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }
    
    [self didTapImage];
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(ChooseFoodView *)frontCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _frontCardView = frontCardView;
    self.currentFood = frontCardView.food;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    NSUInteger likeCount = [formatter numberFromString:self.likeCount.text].unsignedIntegerValue;
    NSUInteger unlikeCount = [formatter numberFromString:self.unlikeCount.text].unsignedIntegerValue;
    NSUInteger sum = likeCount + unlikeCount;
    NSDictionary *photoDictionary = [self.restaurants objectAtIndex:sum];
    NSString *yelpid = [photoDictionary valueForKey:@"restaurantYelpId"];
    self.currentRestaurant = [[Restaurant alloc] initWithYelpid:yelpid];
}

- (NSArray *)defaultFood {
    // It would be trivial to download these from a web service
    // as needed, but for the purposes of this sample app we'll
    // simply store them in memory.
    
    NSMutableArray *foods = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.restaurants count]; i++) {
        NSDictionary *photoDictionary = [self.restaurants objectAtIndex:i];
        NSString *url = [photoDictionary valueForKey:@"imageUrl"];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        NSString *yelpid = [photoDictionary valueForKey:@"restaurantYelpId"];
        [foods addObject:[[Food alloc] initWithImage:image yelpid:yelpid]];
    }
    return foods;
}

- (ChooseFoodView *)popFoodViewWithFrame:(CGRect)frame {
    if ([self.food count] == 0) {
        return nil;
    }
    
    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y, //- (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    // Create a foodView with the top food in the food array, then pop
    // that food off the stack.
    ChooseFoodView *foodView = [[ChooseFoodView alloc] initWithFrame:frame
                                                                food:self.food[0]
                                                             options:options];
    //self.currentFood = [self.food objectAtIndex:0];
    [self.food removeObjectAtIndex:0];
    return foodView;
}

// Checks for tap gesture on UIImageView
- (void)didTapImage {
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.frontCardView setUserInteractionEnabled:YES];
    [self.frontCardView addGestureRecognizer:singleFingerTap];
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 110.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y, //+ 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

// Create and add the "nope" button.
- (void)constructNopeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"skip"];
    button.frame = CGRectMake(ChooseFoodButtonHorizontalPadding,
                              CGRectGetMaxY(self.frontCardView.frame) + ChooseFoodButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:247.f/255.f
                                         green:91.f/255.f
                                          blue:37.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Create and add the "like" button.
- (void)constructLikedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"like"];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChooseFoodButtonHorizontalPadding,
                              CGRectGetMaxY(self.frontCardView.frame) + ChooseFoodButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:29.f/255.f
                                         green:245.f/255.f
                                          blue:106.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(likeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark Control Events

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

// Segues to DetailsViewController
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    double delayInSeconds = 0.25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailsViewController *detailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailsVC"];
        detailsViewController.restaurant = self.currentRestaurant;
        [self presentViewController:detailsViewController animated:YES completion:nil];
    });
}


// Function that fetches restaurants from database
- (void)fetchRestaurants {
    UIView *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    [hud showAnimated:YES];
    NSURLSessionDataTask *task = [Routes fetchRestaurantsOfCategory:self.category nearLocation:self.location offset:0 completionHandler:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", results);
            self.restaurants = [results objectForKey:@"results"];
            
            self.food = [[self defaultFood] mutableCopy];
            self.foodLiked = [[NSMutableArray alloc] init];
            self.foodUnliked = [[NSMutableArray alloc] init];
            
            // Display the first ChoosePersonView in front. Users can swipe to indicate
            // whether they like or dislike the person displayed.
            self.frontCardView = [self popFoodViewWithFrame:[self frontCardViewFrame]];
            [self.view addSubview:self.frontCardView];
            
            // Display the second ChoosePersonView in back. This view controller uses
            // the MDCSwipeToChooseDelegate protocol methods to update the front and
            // back views after each user swipe.
            self.backCardView = [self popFoodViewWithFrame:[self backCardViewFrame]];
            [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
            
            // Add buttons to programmatically swipe the view left or right.
            // See the `nopeFrontCardView` and `likeFrontCardView` methods.
            [self constructNopeButton];
            [self constructLikedButton];
            
            [self didTapImage];
            [hud hideAnimated:YES];
        }
        
    }];
    if (!task) {
        NSLog(@"There was a network error");
    }
}

- (IBAction)didTapClose:(id)sender {
    [self.tabBarController.tabBar setHidden:NO];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)didTapDecide:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RecommendationsViewController *recommendationsViewController = [storyboard instantiateViewControllerWithIdentifier:@"recommendationsVC"];
    recommendationsViewController.foodLiked = self.foodLiked;
    recommendationsViewController.foodUnliked = self.foodUnliked;
    recommendationsViewController.location = self.location;
    [self showViewController:recommendationsViewController sender:self];
}

#pragma mark - Navigation

/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if([segue.identifier isEqualToString:@"detailSegue"]) {
 DetailsViewController *detailsViewController = [segue destinationViewController];
 //detailsViewController.picture = self.frontCardView.food.image;
 NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
 NSUInteger like = [formatter numberFromString:self.likeCount.text].unsignedIntegerValue;
 NSUInteger unlike = [formatter numberFromString:self.unlikeCount.text].unsignedIntegerValue;
 NSUInteger sum = like + unlike;
 NSDictionary *photoDictionary = [self.restaurants objectAtIndex:sum];
 NSString *yelpid = [photoDictionary valueForKey:@"restaurantYelpId"];
 Restaurant *restaurant = [[Restaurant alloc] initWithYelpid:yelpid];
 detailsViewController.restaurant = restaurant;
 //detailsViewController.yelpid = yelpid;
 }
 }
 */

@end

//
//  WalkthroughViewController.m
//  Decider
//
//  Created by kchan23 on 8/8/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "WalkthroughViewController.h"
#import "WalkthroughContentViewController.h"

@interface WalkthroughViewController ()

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageInfoStrings;
@property (strong, nonatomic) NSArray *pageImageNames;
//@property (weak, nonatomic) IBOutlet UILabel *logoLabel;

@end

@implementation WalkthroughViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupLogoLabel];
    //    self.pageInfoStrings = @[@"Get ideas for fun acts of kindness you can do every day", @"Complete acts of kindness to level up and earn achievements", @"Read and share stories of how kindness has touched your life"];
    self.pageInfoStrings = @[@"Add information 1", @"Add information 2", @"Add information 3"];
    self.pageImageNames = @[@"catalogueSS", @"profileSS", @"timelineSS"];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    WalkthroughContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 150);
    
    [self addChildViewController: self.pageViewController];
    [self.view addSubview: self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    //pageControl.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((WalkthroughContentViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((WalkthroughContentViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageInfoStrings count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (WalkthroughContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (index >= [self.pageInfoStrings count]) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    WalkthroughContentViewController *walkthroughContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WalkthroughContentController"];
    walkthroughContentViewController.imageName = self.pageImageNames[index];
    walkthroughContentViewController.infoString = self.pageInfoStrings[index];
    walkthroughContentViewController.pageIndex = index;
    
    return walkthroughContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [self.pageInfoStrings count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setupLogoLabel {
//    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:@"Munch"];
//    
//    NSRange range = NSMakeRange(4, 1);
//    
//    UIColor *color = [[UIColor alloc] initWithRed:255/255.f
//                                            green:209/255.f
//                                             blue:102/255.f
//                                            alpha:1];
//    
//    UIFont *font = [UIFont fontWithName:@"Bradley Hand" size:72];
//    
//    [attributed beginEditing];
//    [attributed addAttribute:NSForegroundColorAttributeName
//                       value:color
//                       range:range];
//    [attributed addAttribute:NSFontAttributeName
//                       value:font
//                       range:range];
//    [attributed endEditing];
//    self.logoLabel.attributedText = attributed;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

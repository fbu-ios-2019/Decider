//
//  HomeViewController.m
//  Decider
//
//  Created by kchan23 on 7/31/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "HomeViewController.h"
#import "LPCarouselView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    LPCarouselView *cv = [LPCarouselView carouselViewWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 250) placeholderImage:nil images:^NSArray *{
    LPCarouselView *cv = [LPCarouselView carouselViewWithFrame:CGRectMake(0, 64, 375, 270) placeholderImage:nil images:^NSArray *{
        return @[
                 @"image1",
                 @"image2",
                 @"image3",
                 @"image4",
                 @"image5",
                 ];
    } titles:^NSArray *{
        //return @[@"NO. 1", @"NO. 2", @"NO. 3", @"NO. 4", @"NO. 5"];
        return nil;
    } selectedBlock:^(NSInteger index) {
        //NSLog(@"clicked2----%zi", index);
    }];
    cv.carouselImageViewContentMode = UIViewContentModeScaleAspectFill;
    cv.scrollDuration = 3.f;
    [self.view addSubview:cv];
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

//
//  WalkthroughContentViewController.m
//  Decider
//
//  Created by kchan23 on 8/8/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "WalkthroughContentViewController.h"

@interface WalkthroughContentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;

@end

@implementation WalkthroughContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoLabel.text = self.infoString;
    if ([self.imageName isEqualToString:@"catalogueSS"]) {
        NSMutableArray *frames = [NSMutableArray new];
        int i = 0;
        while (i < 68) {
            NSString *imgName = [NSString stringWithFormat:@"home%d", i];
            [frames addObject:[UIImage imageNamed:imgName]];
            i += 1;
        }
        self.infoImage.animationImages = frames;
        self.infoImage.animationDuration = 8.0f;
        self.infoImage.animationRepeatCount = 0;
        [self.infoImage startAnimating];
    }
    else if ([self.imageName isEqualToString:@"profileSS"]) {
        NSMutableArray *frames = [NSMutableArray new];
        int i = 0;
        while (i < 114) {
            NSString *imgName = [NSString stringWithFormat:@"swipe%d", i];
            [frames addObject:[UIImage imageNamed:imgName]];
            i += 1;
        }
        self.infoImage.animationImages = frames;
        self.infoImage.animationDuration = 10.0f;
        self.infoImage.animationRepeatCount = 0;
        [self.infoImage startAnimating];
    }
    else {
        NSMutableArray *frames = [NSMutableArray new];
        int i = 0;
        while (i < 121) {
            NSString *imgName = [NSString stringWithFormat:@"view%d", i];
            [frames addObject:[UIImage imageNamed:imgName]];
            i += 1;
        }
        self.infoImage.animationImages = frames;
        self.infoImage.animationDuration = 8.0f;
        self.infoImage.animationRepeatCount = 0;
        [self.infoImage startAnimating];
    }
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

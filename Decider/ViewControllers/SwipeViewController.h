//
//  SwipeViewController.h
//  Decider
//
//  Created by kchan23 on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseFoodView.h"

@interface SwipeViewController : UIViewController <MDCSwipeToChooseDelegate>

@property (strong, nonatomic) Restaurant *currentFood;
@property (strong, nonatomic) ChooseFoodView *frontCardView;
@property (strong, nonatomic) ChooseFoodView *backCardView;
@property (strong, nonatomic) NSArray *restaurants;

@end

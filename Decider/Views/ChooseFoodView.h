//
//  ChooseFoodView.h
//  Decider
//
//  Created by kchan23 on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

@class Food;

@interface ChooseFoodView : MDCSwipeToChooseView

@property (nonatomic, strong, readonly) Food *food;

- (instancetype)initWithFrame:(CGRect)frame
                         food:(Food *)food
                      options:(MDCSwipeToChooseViewOptions *)options;

@end

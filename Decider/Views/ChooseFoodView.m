//
//  ChooseFoodView.m
//  Decider
//
//  Created by kchan23 on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "ChooseFoodView.h"
//#import "ImageLabelView.h"
#import "Food.h"

@interface ChooseFoodView ()

@end

@implementation ChooseFoodView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                         food:(Food *)food
                      options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];
    if (self) {
        _food = food;
        self.imageView.image = _food.image;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        // blur effect
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];

        UIVisualEffectView *visualEffectView;
        visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];

        visualEffectView.frame = self.bounds;
        
        // send blur effect to the back
        self.backgroundColor = [UIColor colorWithPatternImage:self.food.image];
        [self addSubview:visualEffectView];
        [self exchangeSubviewAtIndex:0  withSubviewAtIndex:1];
        
        //Restaurant name label on top of imageViewxr
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 425, 335, 40)];
        
        myLabel.text = self.food.restaurantName;
        myLabel.textColor = [UIColor whiteColor];
//        myLabel.font = [UIFont boldSystemFontOfSize:21.0f];
        myLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:20.5];
        [self.imageView addSubview:myLabel];
    }
    return self;
}


#pragma mark - Internal Methods

@end

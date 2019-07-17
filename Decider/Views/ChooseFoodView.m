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

static const CGFloat ChoosePersonViewImageLabelWidth = 42.f;

@interface ChooseFoodView ()
//@property (nonatomic, strong) UIView *informationView;
//@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) ImageLabelView *cameraImageLabelView;
//@property (nonatomic, strong) ImageLabelView *interestsImageLabelView;
//@property (nonatomic, strong) ImageLabelView *friendsImageLabelView;
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
        
        //[self constructInformationView];
    }
    return self;
}

#pragma mark - Internal Methods

//- (void)constructInformationView {
//    CGFloat bottomHeight = 60.f;
//    CGRect bottomFrame = CGRectMake(0,
//                                    CGRectGetHeight(self.bounds) - bottomHeight,
//                                    CGRectGetWidth(self.bounds),
//                                    bottomHeight);
//    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
//    _informationView.backgroundColor = [UIColor whiteColor];
//    _informationView.clipsToBounds = YES;
//    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
//    UIViewAutoresizingFlexibleTopMargin;
//    [self addSubview:_informationView];
//
//    [self constructNameLabel];
//    [self constructCameraImageLabelView];
//    [self constructInterestsImageLabelView];
//    [self constructFriendsImageLabelView];
//}

@end

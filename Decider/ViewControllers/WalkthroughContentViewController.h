//
//  WalkthroughContentViewController.h
//  Decider
//
//  Created by kchan23 on 8/8/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalkthroughContentViewController : UIViewController

@property (strong, nonatomic) NSString *infoString;
@property (strong, nonatomic) NSString *imageName;
@property (nonatomic) NSUInteger pageIndex;

@end

NS_ASSUME_NONNULL_END

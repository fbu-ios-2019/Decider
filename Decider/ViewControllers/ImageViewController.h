//
//  ImageViewController.h
//  Decider
//
//  Created by kchan23 on 8/7/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString *urlString;

@end

NS_ASSUME_NONNULL_END

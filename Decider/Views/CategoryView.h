//
//  CategoryView.h
//  Decider
//
//  Created by marialepestana on 8/8/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryView : UIView

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

NS_ASSUME_NONNULL_END

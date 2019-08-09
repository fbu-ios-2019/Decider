//
//  CategoryCollectionCell.h
//  Decider
//
//  Created by kchan23 on 8/8/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

NS_ASSUME_NONNULL_END
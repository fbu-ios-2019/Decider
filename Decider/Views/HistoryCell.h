//
//  HistoryCell.h
//  Decider
//
//  Created by kchan23 on 8/2/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END

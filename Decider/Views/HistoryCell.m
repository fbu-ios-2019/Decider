//
//  HistoryCell.m
//  Decider
//
//  Created by kchan23 on 8/2/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "HistoryCell.h"
#import "HistoryCollectionCell.h"

@implementation HistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HistoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryCollectionCell" forIndexPath:indexPath];
    if(cell) {
        cell.imageView.image = [UIImage imageNamed:@"photo1"];
        return cell;
    }
    return [[UICollectionViewCell alloc] init];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

@end

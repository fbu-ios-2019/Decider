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
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 3;
    
    CGFloat postersPerLine = 4;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth * 1;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HistoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryCollectionCell" forIndexPath:indexPath];
    if(cell) {
        long num = indexPath.row;
        NSString *urlstring = [[[[self.history objectAtIndex:num] objectForKey:@"restaurants"] objectAtIndex:num] objectForKey:@"coverUrl"];
        NSURL *url = [NSURL URLWithString:urlstring];
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        return cell;
    }
    return [[UICollectionViewCell alloc] init];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

@end

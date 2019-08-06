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
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 0;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth * 1;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Collection View Methods

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HistoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryCollectionCell" forIndexPath:indexPath];
//    HistoryCollectionCell *cell = [[HistoryCollectionCell alloc] initWithStyle];
    if(cell) {
        long num = indexPath.row;
        //NSString *urlstring = [[[[self.history objectAtIndex:num] objectForKey:@"restaurants"] objectAtIndex:num] objectForKey:@"coverUrl"];
        NSString *urlstring = [[self.restaurants objectAtIndex:num] objectForKey:@"coverUrl"];
        NSURL *url = [NSURL URLWithString:urlstring];
//        cell.imageView = nil;
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
//        cell.imageView = [[UIImageView alloc] initWithImage:image];
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        cell.imageLabel.text = [[self.restaurants objectAtIndex:num] objectForKey:@"name"];
        return cell;
    }
    return [[UICollectionViewCell alloc] init];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.restaurants count];
    //return 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.collectionView = nil;
}

@end

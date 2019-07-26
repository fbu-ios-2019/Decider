//
//  DetailsViewController.m
//  Decider
//
//  Created by kchan23 on 7/17/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "DetailsViewController.h"
#import "PhotoCollectionCell.h"
#import "Routes.h"

@interface DetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *images;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewCount;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //loading the details page information
    self.coverView.image = self.restaurant.coverImage;
    self.nameLabel.text = self.restaurant.name;
    self.priceLabel.text = self.restaurant.priceRating;
    self.categoryLabel.text = self.restaurant.categoryString;
    self.reviewCount.text = self.restaurant.reviewCount;
    self.addressLabel.text = self.restaurant.address;
    self.hoursLabel.text = [NSString stringWithFormat:@"%@-%@", self.restaurant.startTime, self.restaurant.endTime];
    self.images = self.restaurant.images;
    //[self.collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionCell" forIndexPath:indexPath];
    //cell.imageView.image = [UIImage imageNamed:@"photo1"];
    long num = indexPath.row;
    //cell.imageView.image = [self.photos objectAtIndex:num];
    cell.imageView.image = [self.images objectAtIndex:num];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return 4;
    return self.images.count;
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

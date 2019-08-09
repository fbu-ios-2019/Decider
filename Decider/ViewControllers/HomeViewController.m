//
//  HomeViewController.m
//  Decider
//
//  Created by kchan23 on 7/31/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "HomeViewController.h"
#import "LPCarouselView.h"
#import "CategoryCollectionCell.h"
#import "ChooseViewController.h"

@interface HomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *categoryList;
@property (strong, nonatomic) NSArray *categoryIconList;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    LPCarouselView *cv = [LPCarouselView carouselViewWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 250) placeholderImage:nil images:^NSArray *{
    
    // Make navigation bar transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    
    LPCarouselView *cv = [LPCarouselView carouselViewWithFrame:CGRectMake(0, 0, 375, 350) placeholderImage:nil images:^NSArray *{
        return @[
                 @"image1",
                 @"image2",
                 @"image3",
                 @"image4",
                 @"image5",
                 ];
    } titles:^NSArray *{
        //return @[@"NO. 1", @"NO. 2", @"NO. 3", @"NO. 4", @"NO. 5"];
        return nil;
    } selectedBlock:^(NSInteger index) {
        //NSLog(@"clicked2----%zi", index);
    }];
    cv.carouselImageViewContentMode = UIViewContentModeScaleAspectFill;
    cv.scrollDuration = 3.f;
    [self.view addSubview:cv];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.categoryList = [NSArray arrayWithObjects:@"All", @"Bakeries", @"Chinese", @"Coffee & Tea", @"Ice Cream & Frozen Yogurt", @"Indian", @"Italian", @"Mexican", @"Seafood", @"Thai", nil];
    self.categoryIconList = [NSArray arrayWithObjects:@"all", @"bakery", @"chinese", @"coffee", @"icecream", @"indian", @"italian", @"mexican", @"seafood", @"thai", nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"categorySegue"]) {
        CategoryCollectionCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        ChooseViewController *chooseViewController = [segue destinationViewController];
        chooseViewController.category = self.categoryList[indexPath.row];
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CategoryCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionCell" forIndexPath:indexPath];
    cell.categoryLabel.text = [self.categoryList objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[self.categoryIconList objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

@end

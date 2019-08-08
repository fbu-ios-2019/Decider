//
//  HistoryCollectionViewController.m
//  Decider
//
//  Created by kchan23 on 8/5/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "HistoryCollectionViewController.h"
#import "HistoryCollectionCell.h"
#import "CollectionHeaderView.h"
#import "Routes.h"
#import "Parse/Parse.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "DetailsViewController.h"

@interface HistoryCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *history;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation HistoryCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchHistory];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth * 1;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchHistory) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshControl atIndex:0];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HistoryCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryCollectionCell" forIndexPath:indexPath];
    NSString *urlString = [[[self.history objectAtIndex:indexPath.section] objectForKey:@"images"] objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:urlString];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    return cell;
}

- (void)fetchHistory {
    PFUser *user = [PFUser currentUser];
    UIView *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    [hud showAnimated:YES];
    NSURLSessionDataTask *locationTask = [Routes getHistoryofUser:user.objectId completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.history = [[results objectForKey:@"userHistory"] objectAtIndex:0];
            self.collectionView.delegate = self;
            self.collectionView.dataSource = self;
            [self.collectionView reloadData];
            [hud hideAnimated:YES];
        }
        [self.refreshControl endRefreshing];
    }];
    if (!locationTask) {
        NSLog(@"There was a network error");
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
    //return [[[self.history objectAtIndex:section] objectForKey:@"images"] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.history count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderView" forIndexPath:indexPath];
        NSString *title = [self.history[indexPath.section] objectForKey:@"name"];
        headerView.titleLabel.text = title;
        reusableview = headerView;
    }
    return reusableview;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"collectionSegue"]) {
        HistoryCollectionCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        DetailsViewController *detailsViewController =  [segue destinationViewController];
        Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:[self.history objectAtIndex:indexPath.section]];
        detailsViewController.restaurant = restaurant;
    }
}

@end

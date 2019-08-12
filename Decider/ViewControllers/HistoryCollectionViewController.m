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
#import "ImageViewController.h"
#import "UIImageView+AFNetworking.h"

@interface HistoryCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *history;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredHistory;

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

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(addImageViewWithImage:)];
    NSString *position = [[NSString stringWithFormat:@"%ld", (long)indexPath.section] stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    cell.tag = [position integerValue];
    [cell addGestureRecognizer:tap];
    
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
            
            self.searchBar.delegate = self;
            self.filteredHistory = self.history;
            
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
    return [self.filteredHistory count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderView" forIndexPath:indexPath];
        NSString *title = [self.filteredHistory[indexPath.section] objectForKey:@"name"];
        headerView.titleLabel.text = title;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handleTapGuesture:)];
        headerView.tag = indexPath.section;
        [headerView addGestureRecognizer:tap];
        
        reusableview = headerView;
    }
    return reusableview;
}

- (void)handleTapGuesture:(UITapGestureRecognizer *)gesture {
    int section = (int)gesture.view.tag;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailsViewController *detailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailsVC"];
    Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:[self.filteredHistory objectAtIndex:section]];
    detailsViewController.restaurant = restaurant;
    [self presentViewController:detailsViewController animated:YES completion:nil];
}

- (void)removeImage:(UITapGestureRecognizer *)gesture {
    UIImageView *imgView = (UIImageView*)[self.view viewWithTag:100];
    [imgView removeFromSuperview];
    [self.collectionView setUserInteractionEnabled:YES];
}

- (void)addImageViewWithImage:(UITapGestureRecognizer *)gesture {
    NSString *str = [NSString stringWithFormat:@"%d", (int)gesture.view.tag];
    long num = [str length] - 1;
    long section = [[str substringWithRange:NSMakeRange(0, num)] longLongValue];
    long row = [[str substringWithRange:NSMakeRange(num, 1)] longLongValue];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.backgroundColor = [UIColor whiteColor];
    NSString *urlString = [[[self.history objectAtIndex:section]objectForKey:@"images"] objectAtIndex:row];
    NSURL *url = [NSURL URLWithString:urlString];
    imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    imgView.tag = 100;
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                          action:@selector(removeImage:)];
    dismissTap.numberOfTapsRequired = 1;
    [imgView addGestureRecognizer:dismissTap];
    [UIView animateWithDuration:1 animations:^{
        [self.view addSubview:imgView];
    } completion:^(BOOL finished) {
        NSLog(@"error");
    }];
    [self.collectionView setUserInteractionEnabled:NO];
}

//search bar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSString *substring = [NSString stringWithString:searchText];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name contains[c] %@)", substring];
        self.filteredHistory = [self.history filteredArrayUsingPredicate:predicate];
        NSLog(@"%@", self.filteredHistory);
    }
    else {
        self.filteredHistory = self.history;
        [self.searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
    }
    [self.collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

@end

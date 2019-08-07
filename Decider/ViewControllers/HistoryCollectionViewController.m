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
    NSString *urlString = [[[self.history[indexPath.section] objectForKey:@"restaurants"] objectAtIndex:indexPath.row] objectForKey:@"coverUrl"];
    NSURL *url = [NSURL URLWithString:urlString];
    //NSString *urlString = [[self.history[indexPath.section]] objectForKey:@"coverUrl"];
    //NSURL *url = [NSURL URLWithString:urlString];
    
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    //cell.imageView.image = [UIImage imageNamed:[self.dogImages[indexPath.section] objectAtIndex:indexPath.row]];
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
            //self.tableView.rowHeight = 125;
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
    //return [[self.dogImages objectAtIndex:section] count];
    //return [[[self.history objectAtIndex:section] objectForKey:@"restaurants"] count];
    return 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.history count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderView" forIndexPath:indexPath];
        //NSString *date = [self.history[indexPath.section] objectForKey:@"date"];
        //NSString *formattedDate = [[[date substringWithRange:NSMakeRange(5, 5)] stringByAppendingString:@"-"] stringByAppendingString:[date substringWithRange:NSMakeRange(0, 4)]];
        //NSString *title = [[NSString alloc] initWithFormat:@"%@", formattedDate];
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
        //CGPoint row = [sender convertPoint:CGPointZero toView:self.tableView];
        //NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:row];
        //NSDictionary *dictionary = self.history[indexPath.section];
        //NSArray *restaurants = [dictionary objectForKey:@"restaurants"];
        //CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        //Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:[restaurants objectAtIndex:(int)(touchPoint.x / 125)]];
        DetailsViewController *detailsViewController =  [segue destinationViewController];
        Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:[[self.history[indexPath.section] objectForKey:@"restaurants"] objectAtIndex:indexPath.row]];
        detailsViewController.restaurant = restaurant;
    }
}

@end

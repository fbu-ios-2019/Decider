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

@property (strong, nonatomic) NSArray *food;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewCount;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) NSDictionary *details;
//test array
@property (strong, nonatomic) NSArray *photos;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    NSMutableArray *pictures = [[NSMutableArray alloc] init];
    [pictures addObject:[UIImage imageNamed:@"photo1"]];
    [pictures addObject:[UIImage imageNamed:@"photo2"]];
    [pictures addObject:[UIImage imageNamed:@"photo3"]];
    [pictures addObject:[UIImage imageNamed:@"photo4"]];
    self.photos = pictures;
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // Fetch restaurant details from database
    NSURLSessionDataTask *task = [Routes fetchRestaurantDetails:self.yelpid completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.details = results;
            NSLog(@"%@", results);
            
            //loading the details page information
            NSString *URL = [self.details valueForKey:@"coverUrl"];
            NSURL *url = [NSURL URLWithString:URL];
            NSData *data = [NSData dataWithContentsOfURL:url];
            self.coverView.image = [[UIImage alloc] initWithData:data];
            self.nameLabel.text = [self.details valueForKey:@"name"];
            
            long *num = [[self.details valueForKey:@"priceRating"] longValue];
            NSString *price = @"";
            for(long i = 0; i < num; i++) {
                price = [price stringByAppendingString:@"$"];
            }
            self.priceLabel.text = price;
            
            
            NSArray *categories = [self.details objectForKey:@"category"];
            self.categoryLabel.text = [categories componentsJoinedByString:@", "];
            self.reviewCount.text = [NSString stringWithFormat:@"%@", [self.details valueForKey:@"reviewCount"]];
        }
    }];
    if (!task) {
        NSLog(@"There was a network error");
    }
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
    NSInteger *num = indexPath.row;
    cell.imageView.image = [self.photos objectAtIndex:num];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
    //return self.food.count;
}

@end

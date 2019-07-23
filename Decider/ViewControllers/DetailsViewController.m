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
@property (nonatomic, copy) NSDictionary *details;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
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
            
            long num = [[self.details valueForKey:@"priceRating"] longValue];
            NSString *price = @"";
            for(long i = 0; i < num; i++) {
                price = [price stringByAppendingString:@"$"];
            }
            self.priceLabel.text = price;
            
            NSArray *categories = [self.details objectForKey:@"category"];
            self.categoryLabel.text = [categories componentsJoinedByString:@", "];
            self.reviewCount.text = [NSString stringWithFormat:@"%@", [self.details valueForKey:@"reviewCount"]];
            
            NSString *address = [self.details valueForKey:@"address"];
            NSString *city = [self.details valueForKey:@"city"];
            NSString *state = [self.details valueForKey:@"state"];
            NSString *zipcode = [self.details valueForKey:@"zipcode"];
            NSString *country = [self.details valueForKey:@"country"];
            self.addressLabel.text = [NSString stringWithFormat:@"%@\n%@ %@ %@\n%@",
                                      address,
                                      city, state,
                                      zipcode,
                                      country];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
            NSInteger weekday = [comps weekday] - 2;
            NSArray *hours = [[[self.details objectForKey:@"hours"] valueForKey:@"open"] objectAtIndex:0];
            NSDictionary *day = [hours objectAtIndex:weekday];
            NSString *start = [day objectForKey:@"start"];
            NSString *end = [day objectForKey:@"end"];
            self.hoursLabel.text = [NSString stringWithFormat:@"%@-%@", start, end];
            
            NSMutableArray *pictures = [[NSMutableArray alloc] init];
            NSArray *test = [self.details objectForKey:@"images"];
            for(int i = 0; i < [test count]; i++) {
                NSURL *url = [NSURL URLWithString:[test objectAtIndex:i]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                [pictures addObject:[[UIImage alloc] initWithData:data]];
            }
            self.images = pictures;
            NSLog(@"test");
            [self.collectionView reloadData];
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

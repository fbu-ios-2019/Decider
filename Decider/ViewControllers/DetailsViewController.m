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
#import "LocationViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "HCSStarRatingView.h"

@interface DetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, GMSMapViewDelegate>

@property (nonatomic, strong) NSArray *images;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewCount;
//@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView.alwaysBounceVertical = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //loading the details page information
    self.coverView.image = self.restaurant.coverImage;
    self.nameLabel.text = self.restaurant.name;
    self.priceLabel.text = self.restaurant.priceRating;
    self.categoryLabel.text = self.restaurant.categoryString;
    self.reviewCount.text = self.restaurant.reviewCount;
    [self.addressButton setTitle:self.restaurant.address forState:UIControlStateNormal];
    self.addressButton.titleLabel.numberOfLines = 0;
    self.hoursLabel.text = [NSString stringWithFormat:@"%@-%@", self.restaurant.startTime, self.restaurant.endTime];
    self.images = self.restaurant.images;
    
    self.mapView.myLocationEnabled = YES;
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.restaurant.latitude
                                                            longitude:self.restaurant.longitude
                                                                 zoom:15
                                                              bearing:30
                                                         viewingAngle:45];
    [self.mapView setCamera:camera];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(self.restaurant.latitude, self.restaurant.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = self.restaurant.name;
    marker.snippet = [[self.restaurant.city stringByAppendingString:@", "] stringByAppendingString:self.restaurant.state];
    marker.map = self.mapView;
    
    //star rating animation
    self.ratingLabel.text = self.restaurant.starRating;
    double starRating = [self.ratingLabel.text floatValue];
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(8, 165, 95, 20)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.allowsHalfStars = YES;
    starRatingView.value = starRating;
    starRatingView.tintColor = [UIColor redColor];
    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:starRatingView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"locationSegue"]) {
        LocationViewController *locationViewController = [segue destinationViewController];
        locationViewController.city = self.restaurant.city;
        locationViewController.state = self.restaurant.state;
        locationViewController.country = self.restaurant.country;
        locationViewController.name = self.restaurant.name;
        locationViewController.latitude = self.restaurant.latitude;
        locationViewController.longitude = self.restaurant.longitude;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionCell" forIndexPath:indexPath];
    long num = indexPath.row;
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

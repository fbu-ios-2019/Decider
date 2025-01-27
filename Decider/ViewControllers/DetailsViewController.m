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
#import "CategoryBubbleCell.h"
#import <CoreLocation/CoreLocation.h>

@interface DetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, GMSMapViewDelegate>

@property (nonatomic, strong) NSArray *images;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewCount;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
@property (strong,nonatomic) CLLocationManager *locationManager;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.scrollView.alwaysBounceVertical = YES;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.categoryCollectionView.dataSource = self;
    self.categoryCollectionView.delegate = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    UICollectionViewFlowLayout *categoryLayout = (UICollectionViewFlowLayout*)self.categoryCollectionView.collectionViewLayout;
    categoryLayout.minimumInteritemSpacing = 1;
    categoryLayout.minimumLineSpacing = 1;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth * 1;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    //loading the details page information
    self.nameLabel.text = self.restaurant.name;
    self.priceLabel.text = self.restaurant.priceRating;
    self.categoryLabel.text = self.restaurant.categoryString;
    self.reviewCount.text = self.restaurant.reviewCount;
    [self.phoneButton setTitle:self.restaurant.phoneNumber forState:UIControlStateNormal];
    [self.addressButton setTitle:self.restaurant.address forState:UIControlStateNormal];
    self.addressButton.titleLabel.numberOfLines = 0;
    if([self.restaurant.startTime isEqualToString:@""] || [self.restaurant.endTime isEqualToString:@""]) {
        self.hoursLabel.text = @"no hours";
    }
    else {
        self.hoursLabel.text = [NSString stringWithFormat:@"%@-%@", self.restaurant.startTime, self.restaurant.endTime];
    }
    self.images = self.restaurant.images;
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services are not enabled");
    }
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
    double starRating = [self.restaurant.starRating floatValue];
    // 8, 171
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(8, 210, 95, 20)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.allowsHalfStars = YES;
    starRatingView.value = starRating;
    starRatingView.userInteractionEnabled = NO;
    starRatingView.tintColor = [UIColor orangeColor];
    //[starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:starRatingView];
    //[self.mapView bringSubviewToFront:self.addressButton];
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
    
    if (collectionView == self.collectionView) {
        PhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionCell" forIndexPath:indexPath];
        long num = indexPath.row;
        cell.imageView.image = [self.images objectAtIndex:num];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = cell.imageView.frame.size.height/10;
        return cell;
    } else {
        
        CategoryBubbleCell *categoryCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryBubbleCell" forIndexPath:indexPath];
        categoryCell.categoryLabel.textColor = [UIColor whiteColor];
        categoryCell.categoryLabel.layer.masksToBounds = YES;
        categoryCell.categoryLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BACKGROUND"]];
        categoryCell.categoryLabel.layer.cornerRadius = 10;
        categoryCell.categoryLabel.adjustsFontSizeToFitWidth = YES;
        categoryCell.categoryLabel.text = self.restaurant.categories[indexPath.row];
        return categoryCell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return 4;
    if (collectionView == self.collectionView) {
        return self.images.count;
    } else {
        return self.restaurant.categories.count;
    }
    return self.images.count;
}
- (IBAction)callPhone:(id)sender {
    if([self.phoneButton.titleLabel.text isEqualToString:@"no phone number"]) {
        NSLog(@"RIP error");
    }
    else {
        NSString *phoneString = [NSString stringWithFormat:@"tel://%@", self.restaurant.unformattedPhoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString] options:@{} completionHandler:nil];
    }
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

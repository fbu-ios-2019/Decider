//
//  LocationViewController.m
//  Decider
//
//  Created by kchan23 on 7/26/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "LocationViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface LocationViewController () <GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.myLocationEnabled = YES;
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.latitude
                                                            longitude:self.longitude
                                                                 zoom:15
                                                              bearing:30
                                                         viewingAngle:45];
    [self.mapView setCamera:camera];
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = self.name;
    marker.snippet = [[self.city stringByAppendingString:@", "] stringByAppendingString:self.state];
    marker.map = self.mapView;
    
    [self.view bringSubviewToFront:self.backButton];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

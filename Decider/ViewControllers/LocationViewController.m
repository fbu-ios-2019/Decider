//
//  LocationViewController.m
//  Decider
//
//  Created by kchan23 on 7/26/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "LocationViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.latitude//-33.86
                                                            longitude:self.longitude//151.20
                                                                 zoom:12];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);//-33.86, 151.20);
    marker.title = self.name;//@"Sydney";
    marker.snippet = [[self.city stringByAppendingString:@", "] stringByAppendingString:self.state];//self.state;//@"Australia";
    marker.map = mapView;
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

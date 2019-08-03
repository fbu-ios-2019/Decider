//
//  HistoryViewController.m
//  Decider
//
//  Created by kchan23 on 7/31/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryCell.h"
#import "HistoryCollectionCell.h"
#import "Routes.h"
#import "Parse/Parse.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "DetailsViewController.h"

@interface HistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *history;
@property (strong, nonatomic) HistoryCell *currentCell;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
            self.history = [results objectForKey:@"userHistory"];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.tableView.rowHeight = 125;
            [self.tableView reloadData];
            [hud hideAnimated:YES];
        }
    }];
    if (!locationTask) {
        NSLog(@"There was a network error");
    }
}

#pragma mark - Table View Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    if(cell) {
        cell.history = self.history;
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.history count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    NSString *date = [[self.history objectAtIndex:section] objectForKey:@"date"];
    return [[[date substringWithRange:NSMakeRange(5, 5)] stringByAppendingString:@"-"] stringByAppendingString:[date substringWithRange:NSMakeRange(0, 4)]];
    //return [NSString stringWithFormat:@"%@", date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if([segue.identifier isEqualToString:@"collectionSegue"]) {
         HistoryCell *tappedCell = sender;
         NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
         NSDictionary *dictionary = self.history[indexPath.row];
         NSArray *restaurants = [dictionary objectForKey:@"restaurants"];
         CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.tableView];
         Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:[restaurants objectAtIndex:(int)(touchPoint.x / 125)]];
         DetailsViewController *detailsViewController =  [segue destinationViewController];
         detailsViewController.restaurant = restaurant;
     }
 }

@end

//
//  HistoryViewController.m
//  Decider
//
//  Created by kchan23 on 7/31/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryCell.h"
#import "Routes.h"
#import "Parse/Parse.h"

@interface HistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *history;
@property (strong, nonatomic) HistoryCell *currentCell;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *user = [PFUser currentUser];
    NSURLSessionDataTask *locationTask = [Routes getHistoryofUser:user.objectId completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.history = [results objectForKey:@"userHistory"];
            
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.tableView.rowHeight = 150;
            [self.tableView reloadData];
        }
    }];
    if (!locationTask) {
        NSLog(@"There was a network error");
    }
    
    //[self fetchHistory];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    self.currentCell = cell;
    if(cell) {
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
    return date;
    //return [NSString stringWithFormat:@"%@", date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

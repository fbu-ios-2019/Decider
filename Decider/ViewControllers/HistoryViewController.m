//
//  HistoryViewController.m
//  Decider
//
//  Created by kchan23 on 7/31/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryCell.h"

@interface HistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 150;
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
    if(cell) {
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Date %ld", (long)section + 1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

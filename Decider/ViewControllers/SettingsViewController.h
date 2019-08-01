//
//  SettingsViewController.h
//  Decider
//
//  Created by mudi on 8/1/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;
@property (strong, nonatomic) NSMutableArray *optionsArray;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priceControl;

@end

NS_ASSUME_NONNULL_END

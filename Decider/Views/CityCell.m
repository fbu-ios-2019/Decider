//
//  CityCell.m
//  Decider
//
//  Created by marialepestana on 7/22/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "CityCell.h"

@implementation CityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cityLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightThin];
    self.cityLabel.textColor = [UIColor darkGrayColor];
    self.cityLabel.layer.borderWidth = 0.25;
    self.cityLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

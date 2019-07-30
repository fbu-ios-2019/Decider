//
//  CategoryCell.m
//  Decider
//
//  Created by marialepestana on 7/29/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.categoryLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightThin];
    self.categoryLabel.textColor = [UIColor darkGrayColor];
    self.categoryLabel.layer.borderWidth = 0.25;
    self.categoryLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

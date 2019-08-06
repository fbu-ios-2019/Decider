//
//  ChooseCell.m
//  Decider
//
//  Created by kchan23 on 7/30/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "ChooseCell.h"

@implementation ChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.textLabel.text = @"";
    self.textLabel.textColor = [UIColor blackColor];
}

@end

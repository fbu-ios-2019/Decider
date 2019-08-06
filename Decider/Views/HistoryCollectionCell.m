//
//  HistoryCollectionCell.m
//  Decider
//
//  Created by kchan23 on 8/2/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "HistoryCollectionCell.h"

@implementation HistoryCollectionCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageLabel.text = @"";
    self.imageView.image = nil;
}

@end

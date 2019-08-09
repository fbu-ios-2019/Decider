//
//  CategoryView.m
//  Decider
//
//  Created by marialepestana on 8/8/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "CategoryView.h"

@implementation CategoryView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

-(void)customInit {
    [[NSBundle mainBundle] loadNibNamed:@"CategoryView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    [self.contentView addSubview:self.scrollView];
    self.scrollView.alwaysBounceHorizontal = YES;
    
    [self makeCategoryBubbles]; self.categoryLabel.layer.masksToBounds = YES; self.categoryLabel.layer.cornerRadius = 20;
    self.categoryLabel.text = @"HI";
}


-(void)makeCategoryBubbles {
    CGRect labelFrame = CGRectMake(0, 0, 200.0f, 25.0f);
    UILabel *categoryBubble = [[UILabel alloc] initWithFrame:labelFrame];
    
    categoryBubble.text = @"Category";
    
    [self.scrollView addSubview:categoryBubble];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  SwitchCell.m
//  Yelp
//
//  Created by Li-Erh å¼µåŠ›å…’ Chang on 9/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SwitchCell.h"

@implementation SwitchCell

- (void)awakeFromNib {
    self.filterSwitch.on = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onSwitchChange:(id)sender {
    [self.delegate switchCell:self didChangeValue:self.filterSwitch.on];
}

@end

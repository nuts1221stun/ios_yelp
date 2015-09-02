//
//  DropDownListOption.m
//  Yelp
//
//  Created by Li-Erh å¼µåŠ›å…’ Chang on 9/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "DropDownListOption.h"

@implementation DropDownListOption

- (void)awakeFromNib {
    }

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.optionLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 100, 25)];
        [self.contentView addSubview:self.optionLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)reuseIdentifier {
    return @"DropDownListOption";
}

@end

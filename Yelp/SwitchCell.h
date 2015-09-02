//
//  SwitchCell.h
//  Yelp
//
//  Created by Li-Erh å¼µåŠ›å…’ Chang on 9/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

- (void)switchCell:(SwitchCell *)cell didChangeValue:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISwitch *filterSwitch;
@property (weak, nonatomic) id<SwitchCellDelegate> delegate;

@end

//
//  FilterViewController.h
//  Yelp
//
//  Created by Li-Erh å¼µåŠ›å…’ Chang on 8/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownMenu.h"

@interface FilterViewController : UIViewController

@property (weak, nonatomic) IBOutlet DropDownMenu *distanceView;
@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (weak, nonatomic) IBOutlet UISwitch *dealsSwitch;

@end

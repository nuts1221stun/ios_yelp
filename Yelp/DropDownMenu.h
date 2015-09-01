//
//  DropDownMenu.h
//  Yelp
//
//  Created by Li-Erh å¼µåŠ›å…’ Chang on 9/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UITableView *menuTable;

@property (strong, nonatomic) NSArray *items;

@end

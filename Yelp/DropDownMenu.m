//
//  DropDownMenu.m
//  Yelp
//
//  Created by Li-Erh å¼µåŠ›å…’ Chang on 9/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "DropDownMenu.h"
#define COMPONENT_HEIGHT 40

@implementation DropDownMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    self.items = @[ @"a", @"b", @"c"];
    
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button.frame = CGRectMake(0, 0, self.layer.frame.size.width, self.layer.frame.size.height);
    self.button.backgroundColor = [UIColor grayColor];
    [self.button setTitle:@"test" forState:UIControlStateNormal];
    [self addSubview:self.button];
    [self.button addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.menuTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.menuTable.delegate = self;
    self.menuTable.dataSource = self;
    self.menuTable.frame = CGRectMake(0, 50, self.menuTable.frame.size.width, self.items.count*COMPONENT_HEIGHT);
    self.menuTable.hidden = true;
    [self addSubview:self.menuTable];
}

- (void)onClick {
    NSLog(@"click!!");
    
    if (self.menuTable.hidden) {
        self.menuTable.hidden = false;
    } else {
        self.menuTable.hidden = true;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return COMPONENT_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testCell"];
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}



@end

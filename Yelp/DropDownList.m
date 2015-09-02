//
//  DropDownList.m
//  Yelp
//
//  Created by Li-Erh å¼µåŠ›å…’ Chang on 9/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "DropDownList.h"
#import "DropDownListOption.h"

#define COMPONENT_HEIGHT 40
#define CELL_IDENTIFIER @"DropDownListOption"

@implementation DropDownList

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)awakeFromNib {
    self.options = @[ @"a", @"b", @"c"];
    
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button.frame = CGRectMake(0, 0, self.layer.frame.size.width, self.layer.frame.size.height);
    self.button.backgroundColor = [UIColor grayColor];
    [self.button setTitle:@"test" forState:UIControlStateNormal];
    [self addSubview:self.button];
    [self.button addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.optionTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.optionTable.delegate = self;
    self.optionTable.dataSource = self;
    [self.optionTable registerClass:[DropDownListOption class] forCellReuseIdentifier:CELL_IDENTIFIER];
    
    self.optionTable.frame = CGRectMake(0, 50, self.optionTable.frame.size.width, self.options.count*COMPONENT_HEIGHT);
    self.optionTable.hidden = true;
    [self addSubview:self.optionTable];
    
    
}

- (void)onClick {
    if (self.optionTable.hidden) {
        self.optionTable.hidden = false;
    } else {
        self.optionTable.hidden = true;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return COMPONENT_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DropDownListOption *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    if (!cell) {
        NSLog(@"cell is empty");
        cell = [[DropDownListOption alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CELL_IDENTIFIER];
    }
    cell.optionLabel.text = self.options[indexPath.row];
    return cell;
}

@end

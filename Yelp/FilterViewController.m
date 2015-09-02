//
//  FilterViewController.m
//  Yelp
//
//  Created by Li-Erh å¼µåŠ›å…’ Chang on 8/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "DropDownList.h"
#import "LabelCell.h"
#import "OptionCell.h"

@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sectionTitles = @[ @"Distance", @"Sort", @"Category", @"Deals" ];
    
    NSMutableDictionary *distanceDict = [[NSMutableDictionary alloc] initWithDictionary:
        @{
            @"active": @(NO),
            @"value": @"radius_filter",
            @"selected": @(0),
            @"options":
                @[
                    @"Best matched",
                    @"0.5 km",
                    @"1.0 km"
                ],
            @"optionValues":
                @[
                    @(-1),
                    @(500),
                    @(1000)
                ]
        }
    ];
    NSMutableDictionary *sortDict = [[NSMutableDictionary alloc] initWithDictionary:
        @{
            @"active": @(NO),
            @"value": @"sort",
            @"selected": @(0),
            @"options":
                @[
                    @"Best matched",
                    @"Distance",
                    @"Highest Rated"
                ],
            @"optionValues":
                @[
                    @(0),
                    @(1),
                    @(2)
                ]
        }
    ];
    NSMutableDictionary *categoryDict = [[NSMutableDictionary alloc] initWithDictionary:
        @{
            @"active": @(NO),
            @"value": @"category_filter",
            @"selected": @"",
            @"selectedValue": @"",
            @"options":
               @[
                   @"Hotels & Travel",
                   @"Food",
                   @"Transport"
                ],
            @"optionValues":
               @[
                   @"hotelstravel",
                   @"food",
                   @"transport"
                ],
            @"optionStatus":
                @[
                    @(NO),
                    @(NO),
                    @(NO)
                ]
        }
    ];
    NSMutableDictionary *dealsDict = [[NSMutableDictionary alloc] initWithDictionary:
        @{
            @"active": @(NO),
            @"value": @"deals_filter",
            @"selected": @(NO)
        }
    ];
    
    self.sectionInfos = @[ distanceDict, sortDict, categoryDict, dealsDict ];
    
    self.filterTable.delegate = self;
    self.filterTable.dataSource = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
    [self.delegate uiViewController:self didUpdateFilters:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSearch:(id)sender {
    NSMutableDictionary *filterDict = [[NSMutableDictionary alloc] init];
    int i = 0;
    for (NSDictionary *info in self.sectionInfos) {
        NSString *sectionTitle = self.sectionTitles[i];
        if (![sectionTitle isEqualToString:@"Deals"]) {
            if ([sectionTitle isEqualToString:@"Category"]) {
                [filterDict setValue:info[@"selectedValue"] forKey:info[@"value"]];
            } else {
                long idx = [info[@"selected"] integerValue];
                NSObject *selectedValue = ((NSArray *)info[@"optionValues"])[idx];
                [filterDict setValue:selectedValue forKey:info[@"value"]];
            }
        } else {
        
        }
        i++;
    }

    [self.delegate uiViewController:self didUpdateFilters:filterDict];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionDictionary = self.sectionInfos[section];
    NSString *sectionTitle = self.sectionTitles[section];
    if (![sectionTitle isEqualToString:@"Deals"]) {
        NSArray *options = (NSArray *)sectionDictionary[@"options"];
        BOOL isSectionActive = [sectionDictionary[@"active"] boolValue];
        if (isSectionActive) {
            return options.count;
        }
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionDictionary = self.sectionInfos[indexPath.section];
    NSString *sectionTitle = self.sectionTitles[indexPath.section];
    
    if (![sectionTitle isEqualToString:@"Deals"]) {
        NSArray *options = (NSArray *)sectionDictionary[@"options"];
        BOOL isSectionActive = [sectionDictionary[@"active"] boolValue];
        if (isSectionActive) {
            OptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionCell" forIndexPath:indexPath];
            cell.optionLabel.text = options[indexPath.row];
            return cell;
        }
        LabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];
        if ([sectionTitle isEqualToString:@"Category"]) {
            cell.label.text = sectionDictionary[@"selected"];
        } else {
            cell.label.text = (NSString *)options[[sectionDictionary[@"selected"] integerValue]];
        }
        return cell;
    } else {
        return [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *sectionDictionary = self.sectionInfos[indexPath.section];
    NSString *sectionTitle = self.sectionTitles[indexPath.section];
    BOOL isSectionActive = [sectionDictionary[@"active"] boolValue];

    if ([sectionTitle isEqualToString:@"Deals"]) {
        return;
    }

    if (isSectionActive) {
        [sectionDictionary setValue:@(NO) forKeyPath:@"active"];
        if ([sectionTitle isEqualToString:@"Category"]) {
            NSMutableArray *optionStatus = [[NSMutableArray alloc] initWithArray:(NSArray *)sectionDictionary[@"optionStatus"]];
            NSArray *optionValues = (NSArray *)sectionDictionary[@"optionValues"];
            NSArray *options = (NSArray *)sectionDictionary[@"options"];
            BOOL selectedBool = [optionStatus[indexPath.row] boolValue];
            NSString *selectedString = @"";
            NSString *selectedValueString = @"";
            
            [optionStatus replaceObjectAtIndex:(NSUInteger)indexPath.row withObject:@(!selectedBool)];
            
            int idx = 0;
            for (NSString *option in options) {
                NSString *separator;
                if ([selectedString isEqualToString:@""]) {
                    separator = @"";
                } else {
                    separator = @", ";
                }
                if ([optionStatus[idx] boolValue]) {
                    selectedString = [NSString stringWithFormat:@"%@%@%@", selectedString, separator, option];
                    selectedValueString = [NSString stringWithFormat:@"%@%@%@", selectedValueString, separator, (NSString *)optionValues[idx]];
                }
                idx++;
            }
            [sectionDictionary setValue:optionStatus forKey:@"optionStatus"];
            [sectionDictionary setValue:selectedString forKey:@"selected"];
            [sectionDictionary setValue:selectedValueString forKey:@"selectedValue"];
        } else {
            [sectionDictionary setValue:@(indexPath.row) forKeyPath:@"selected"];
        }
    } else {
        [sectionDictionary setValue:@(YES) forKeyPath:@"active"];
    }

    [self.filterTable reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end

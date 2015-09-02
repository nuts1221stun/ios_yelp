//
//  FilterViewController.h
//  Yelp
//
//  Created by Li-Erh å¼µåŠ›å…’ Chang on 8/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownList.h"

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

- (void)uiViewController:(UIViewController *)viewController didUpdateFilters:(NSDictionary *)filters;

@end


@interface FilterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *filterTable;
@property (weak, nonatomic) id<FilterViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *sectionTitles;
@property (strong, nonatomic) NSArray *sectionInfos;

@end

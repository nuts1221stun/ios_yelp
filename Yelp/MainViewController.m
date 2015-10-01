//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "RestaurantCell.h"
#import "FilterViewController.h"
#import <UIImageView+AFNetworking.h>

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FilterViewControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *restaurants;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSDictionary *filters;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self) {
        self.searchResultsTable.dataSource = self;
        self.searchResultsTable.delegate = self;
        self.searchResultsTable.rowHeight = UITableViewAutomaticDimension;
        self.searchResultsTable.estimatedRowHeight = 120.0;
        
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        //[self searchAndReloadWithTermAndFilters:@"Thai" filters:nil];
        
        // search bar
        self.searchText = @"";
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        self.navigationItem.titleView = self.searchBar;
        self.searchBar.delegate = self;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchText = searchBar.text;
    [searchBar resignFirstResponder];
    [self searchAndReloadWithTermAndFilters:self.searchText filters:nil];
}

- (void)searchAndReloadWithTermAndFilters:(NSString *)term filters:(NSDictionary *)filters {
    [self.client searchWithTermAndFilters:term filters:filters success:^(AFHTTPRequestOperation *operation, id response) {
        NSDictionary *dict = (NSDictionary *)response;
        self.restaurants = dict[@"businesses"];
        [self.searchResultsTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // error handling
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.restaurants.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantCell" forIndexPath:indexPath];
    NSDictionary *restaurant = self.restaurants[indexPath.row];
    
    // thumbnail
    cell.thumbnailImage.alpha = 0.0;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:restaurant[@"image_url"]]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [cell.thumbnailImage setImageWithURLRequest:request placeholderImage:nil
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
            [cell.thumbnailImage setImage:image];
            [UIView animateWithDuration:0.3 animations:^{
                cell.thumbnailImage.alpha = 1.0;
            }];
        } failure:nil];
    
    // thumbnail
    cell.ratingImage.alpha = 0.0;
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:restaurant[@"rating_img_url"]]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [cell.ratingImage setImageWithURLRequest:request placeholderImage:nil
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
            [cell.ratingImage setImage:image];
            [UIView animateWithDuration:0.3 animations:^{
                cell.ratingImage.alpha = 1.0;
            }];
        } failure:nil];
    
    cell.nameLabel.text = restaurant[@"name"];
    float dist = [restaurant[@"distance"] floatValue];
    dist = dist / 1000;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.01fkm", dist];
    cell.reviewCountLabel.text = [NSString stringWithFormat:@"%ld", (long)[restaurant[@"review_count"] integerValue]];
    // location.address
    NSDictionary *location = restaurant[@"location"];
    NSArray *addresses = location[@"address"];
    NSString *addressString = [[addresses valueForKey:@"description"] componentsJoinedByString:@" "];
    cell.addressLabel.text = addressString;
    // category
    NSArray *categories = restaurant[@"categories"];
    NSString *categoryString = @"";

    for (NSArray *category in categories) {
        if ([categoryString compare:@""] == NSOrderedSame) {
            categoryString = category[0];
        } else {
            categoryString = [NSString stringWithFormat:@"%@, %@", categoryString, category[0]];
        }
    }
    cell.categoryLabel.text = categoryString;

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FilterViewController *filterVC = segue.destinationViewController;
    filterVC.delegate = self;
    if (self.filters) {
        filterVC.filters = self.filters;
    }
}

- (void)uiViewController:(UIViewController *)viewController didUpdateFilters:(NSDictionary *)filters {
    self.filters = filters;
    [self searchAndReloadWithTermAndFilters:self.searchText filters:filters];
}

@end

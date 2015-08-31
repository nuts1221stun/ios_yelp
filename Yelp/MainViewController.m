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
#import <UIImageView+AFNetworking.h>

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *restaurants;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self) {
        self.searchResultsTable.dataSource = self;
        self.searchResultsTable.delegate = self;
        
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self searchAndReloadWithTerm:@"Thai"];
    }
}

- (void)searchAndReloadWithTerm:(NSString *)term {
    [self.client searchWithTermAndFilters:term filters:nil success:^(AFHTTPRequestOperation *operation, id response) {
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
    cell.distanceLabel.text = [NSString stringWithFormat:@"%ld", (long)[restaurant[@"distance"] integerValue]];
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

@end

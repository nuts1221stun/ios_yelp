//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSDictionary *parameters = @{@"term": term, @"ll" : @"37.774866,-122.394556"};
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)searchWithTermAndFilters:(NSString *)term filters:(NSDictionary *)filters success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addEntriesFromDictionary:@{@"term": term, @"ll" : @"37.774866,-122.394556"}];
    
    if (filters[@"category_filter"]) {
        NSString *categoryString = (NSString *)filters[@"category_filter"];
        if (![categoryString isEqualToString:@""]) {
            [parameters addEntriesFromDictionary:@{@"category_filter": filters[@"category_filter"]}];
        }
    }
    
    if (filters[@"sort"]) {
        long sort = [filters[@"sort"] integerValue];
        [parameters addEntriesFromDictionary:@{@"sort": @(sort)}];
    }
    
    if ([filters[@"radius_filter"] integerValue] >= 0) {
        float radius = [filters[@"radius_filter"] floatValue];
        [parameters addEntriesFromDictionary:@{@"radius_filter": @(radius)}];
    }
    
    if (filters[@"deals_filter"]) {
        BOOL deals = [filters[@"deals_filter"] boolValue];
        [parameters addEntriesFromDictionary:@{@"deals_filter": @(deals)}];
    }
    
    NSLog(@"%@", parameters);
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}

@end

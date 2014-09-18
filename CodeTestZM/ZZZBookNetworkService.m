//
//  ZZZBookNetworkService.m
//  CodeTestZM
//
//  Created by _Zach on 9/17/14.
//  Copyright (c) 2014 ZachM. All rights reserved.
//

#import "ZZZBookNetworkService.h"

@interface ZZZBookNetworkService ()
    @property (nonatomic, strong) NSURL *serverURL;
    @property (nonatomic, strong) NSURLSessionConfiguration *defaultConfiguration;
    @property (nonatomic, strong) NSURLSessionTask *activeTask;
@end

@implementation ZZZBookNetworkService

+ (instancetype)sharedInstance {
    static ZZZBookNetworkService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
        NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"bookURL"];
        instance.serverURL = [NSURL URLWithString:urlString];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfig setHTTPAdditionalHeaders:@{@"Accept" : @"application/json"} ];
        instance.defaultConfiguration = sessionConfig;
    });
    return instance;
}

- (void)fetchBookListings:(bookListingCallback)callback {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:self.defaultConfiguration];
    self.activeTask = [session dataTaskWithURL:self.serverURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if (httpResp.statusCode != 200) {
            callback(nil, error);
        }
        
        NSError *jsonError;
        NSArray *bookJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&jsonError];
        if (jsonError) {
            [NSException raise:@"failed to decode JSON" format:@"JSON decode error"];
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (callback) {
                callback(bookJSON, nil);
            }
        });
    }];
    
    [self.activeTask resume];
}
@end

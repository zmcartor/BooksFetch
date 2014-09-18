//
//  ZZZBookNetworkService.h
//  CodeTestZM
//
//  Created by _Zach on 9/17/14.
//  Copyright (c) 2014 ZachM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^bookListingCallback)(NSArray* books, NSError* err);

@interface ZZZBookNetworkService : NSObject

+ (instancetype)sharedInstance;
- (void)fetchBookListings:(bookListingCallback)callback;

@end

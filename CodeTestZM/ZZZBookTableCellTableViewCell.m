//
//  ZZZBookTableCellTableViewCell.m
//  CodeTestZM
//
//  Created by _Zach on 9/17/14.
//  Copyright (c) 2014 ZachM. All rights reserved.
//

#import "ZZZBookTableCellTableViewCell.h"

@interface ZZZBookTableCellTableViewCell ()
    @property (strong, nonatomic) NSURLSessionDataTask *iconTask;
@end

@implementation ZZZBookTableCellTableViewCell


- (void)loadIconURL:(NSString *)urlString {
    
    if (!urlString) { return; }
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    // TODO ensure URLstring can be parsed into URL
    
    // Async load the image from URL. Then update the UI on main thread
    __block typeof(self) blockSelf = self;
    void (^updateUIWithImage)(UIImage *) = ^(UIImage* image){
        dispatch_async(dispatch_get_main_queue(), ^{
            blockSelf.iconImageView.image = image;
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // TODO use NSURLSesssionTask and keep handle to cancel DL when leave screen
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        updateUIWithImage(img);
    });
}

- (void)cancelIconDownloadTask {
    // TODO cancel self.iconTask
}

- (void)prepareForReuse {
    self.titleLabel.text = nil;
    self.iconImageView.image = nil;
}

@end

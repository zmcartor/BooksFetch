//
//  ZZZBookTableCellTableViewCell.h
//  CodeTestZM
//
//  Created by _Zach on 9/17/14.
//  Copyright (c) 2014 ZachM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZZBookTableCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

- (void)loadIconURL:(NSString *)urlString;
- (void)cancelIconDownloadTask;
@end

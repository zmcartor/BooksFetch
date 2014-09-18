//
//  ZZZBookTableViewTableViewController.m
//  CodeTestZM
//
//  Created by _Zach on 9/17/14.
//  Copyright (c) 2014 ZachM. All rights reserved.
//

#import "ZZZBookTableViewTableViewController.h"
#import "ZZZBookNetworkService.h"
#import "ZZZBookTableCellTableViewCell.h"

@interface ZZZBookTableViewTableViewController ()

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation ZZZBookTableViewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"BookCell" bundle:nil] forCellReuseIdentifier:@"book"];
  
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.hidesWhenStopped = YES;
    self.spinner.center = CGPointMake(self.view.center.x, self.view.center.y-90.0);
    [self.view addSubview:self.spinner];
    
    [self.spinner startAnimating];
    
    __block typeof(self) blockSelf = self;
    [[ZZZBookNetworkService sharedInstance] fetchBookListings:^(NSArray *books, NSError *err) {
        blockSelf.dataSource = books;
        [blockSelf.tableView reloadData];
        [blockSelf.spinner stopAnimating];
    }];
}


// TODO abstract out datasource into separate class which can populate via own network calls.
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZZBookTableCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"book" forIndexPath:indexPath];
    
    NSDictionary *modelObject = self.dataSource[indexPath.row];
    cell.titleLabel.text = [modelObject objectForKey:@"title"];
    cell.authorLabel.text = [modelObject objectForKey:@"author"];
    [cell loadIconURL:[modelObject objectForKey:@"imageURL"]];
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 111;
}

@end

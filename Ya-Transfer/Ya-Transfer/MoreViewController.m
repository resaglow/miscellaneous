//
//  MoreViewController.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 04/10/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "MoreViewController.h"
#import "YTHistoryDataManager.h"
#import "YTOperation.h"

@interface MoreViewController () <UITableViewDataSource>

@property (nonatomic) UITableView *historyTable;

@property (nonatomic) YTHistoryDataManager *historyDataManager;
@property (nonatomic) NSArray *history;

@end

@implementation MoreViewController

- (void)viewDidLoad
{
    [self setupLayout];
    
    self.historyTable.dataSource = self;
    
    self.historyDataManager = [YTHistoryDataManager sharedInstance];
    self.history = [self.historyDataManager getHistory];
}

- (void)setupLayout
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Log out"
                                     style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.historyTable = [[UITableView alloc] init];
    self.historyTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.historyTable];
    
    NSDictionary *uiElements =
    NSDictionaryOfVariableBindings(_historyTable);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_historyTable]-|"
                                                                      options:0 metrics:nil views:uiElements]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_historyTable]|"
                                                                      options:0 metrics:nil views:uiElements]];
}

- (void)logOut
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Operations history";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.history.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"HistoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    
    YTOperation *operation = (YTOperation *)(self.history[indexPath.row]);
    
    cell.textLabel.text = operation.comment;
    cell.detailTextLabel.text = operation.recipientId;
    
    return cell;
}

@end

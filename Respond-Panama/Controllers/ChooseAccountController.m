//
//  ChooseAccountController.m
//  GeoReporter
//
//  Created by RSTDeveloper01 on 6/18/13.
//  Copyright (c) 2013 City of Bloomington. All rights reserved.
//

#import "ChooseAccountController.h"
#import "ChooseServiceController.h"
#import "Preferences.h"
#import "Open311.h"
#import "Strings.h"
#import "ReportController.h"

@interface ChooseAccountController ()

@end

@implementation ChooseAccountController{
    Open311 *open311;
    NSString *currentServerName;
    NSArray *accounts;
    UIActivityIndicatorView *busyIcon;
}
static NSString * const kCellIdentifier = @"account_cell";
static NSString * const kSegueToChooseService = @"SegueToChooseServiceFromAccount";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(kUI_Cities,nil);

}

- (void)viewWillAppear:(BOOL)animated
{
    open311 = [Open311 sharedInstance];
    currentServerName = [[Preferences sharedInstance] getCurrentServer][kOpen311_Name];
    accounts = [open311 accounts];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [accounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    NSDictionary *account = accounts[indexPath.row];
    
    cell.textLabel      .text = account[kRst_AccountName];
    //cell.detailTextLabel.text = account[kRst_AccountURL];
    
    return cell;
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ChooseServiceController *chooseService = [segue destinationViewController];
    chooseService.account = [accounts objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
}
@end
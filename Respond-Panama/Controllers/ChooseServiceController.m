/**
 * @copyright 2013 City of Bloomington, Indiana. All Rights Reserved
 * @author Cliff Ingham <inghamn@bloomington.in.gov>
 * @license http://www.gnu.org/licenses/gpl.txt GNU/GPLv3, see LICENSE.txt
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

#import "ChooseServiceController.h"
#import "Preferences.h"
#import "Open311.h"
#import "Strings.h"
#import "ReportController.h"

@interface ChooseServiceController ()

@end

@implementation ChooseServiceController {
    Open311 *open311;
    NSString *currentServerName;
    NSMutableArray *services;
    UIActivityIndicatorView *busyIcon;
}
static NSString * const kCellIdentifier = @"service_cell";
static NSString * const kSegueToReport  = @"SegueToReport";

- (void)viewDidLoad
{
    [super viewDidLoad];
    open311 = [Open311 sharedInstance];
    
    currentServerName = [[Preferences sharedInstance] getCurrentServer][kOpen311_Name];
    self.navigationItem.title = [self.account objectForKey:kRst_AccountName];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    

    /*if (![currentServerName isEqualToString:[[Preferences sharedInstance] getCurrentServer][kOpen311_Name]]) {
        currentServerName = nil;
        [self.navigationController popViewControllerAnimated:NO];
    }*/
    //[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    [self startBusyIcon];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(serviceListReady)
                                                 name:kNotification_ServiceListReady
                                               object:open311];
    [self loadServices];
}

- (void) loadServices{

    [open311 getServicesForAccount:_account];

}

- (void)startBusyIcon
{
    busyIcon = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    busyIcon.center = self.view.superview.center;
    [busyIcon setFrame:self.view.superview.frame];
    [busyIcon setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [busyIcon startAnimating];
    [self.view.superview addSubview:busyIcon];
    
}

- (void)serviceListReady
{
    
    if([[open311 groups]count]==0)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [busyIcon stopAnimating];
    [busyIcon removeFromSuperview];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [open311.groups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    
    for (NSDictionary *service in [open311 services]) {
        if ([[service objectForKey:@"group"] isEqualToString:[open311.groups objectAtIndex:section]]) {
            count= count+1;
        }
    }
    return count;
}

-(NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section{
    return [open311.groups objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *group= [open311.groups objectAtIndex:[indexPath section]];
    NSMutableArray *services=[[NSMutableArray alloc]init];
    
    if (group) {
        for (NSDictionary *service in [[Open311 sharedInstance] services]) {
            if ([[service objectForKey:@"group"] isEqualToString:group]) {
                [services addObject:service];
            }
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    //    cell.textLabel.text = [self.groups objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    cell.textLabel.text=[[services objectAtIndex:[indexPath row]]objectForKey:@"service_name"];
    cell.detailTextLabel.text=[[services objectAtIndex:[indexPath row]]objectForKey:@"description"];
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ReportController *report = [segue destinationViewController];
    NSString *group= [open311.groups objectAtIndex:[[self.tableView indexPathForSelectedRow] section]];
    NSMutableArray *services=[[NSMutableArray alloc]init];
    if (group) {
        for (NSDictionary *service in [open311 services]) {
            if ([[service objectForKey:@"group"] isEqualToString:group]) {
                [services addObject:service];
            }
        }
    }
    report.service = services[[[self.tableView indexPathForSelectedRow] row]];
}

@end

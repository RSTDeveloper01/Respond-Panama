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

#import "ViewRequestController.h"
#import "Strings.h"
#import "Preferences.h"
#import "Media.h"

@interface ViewRequestController ()

@end

@implementation ViewRequestController {
    NSDateFormatter *dateFormatterDisplay;
    NSDateFormatter *dateFormatterISO;
    NSURL *mediaUrl;
    UIImage *media;
}
static NSString * const kCellIdentifier  = @"request_cell";
static NSString * const kMediaCell       = @"media_cell";
static NSInteger  const kImageViewTag    = 100;
static CGFloat    const kMediaCellHeight = 122;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.report.service[kOpen311_ServiceName];
    
    dateFormatterDisplay = [[NSDateFormatter alloc] init];
    [dateFormatterDisplay setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatterDisplay setTimeStyle:NSDateFormatterShortStyle];
    
    dateFormatterISO = [[NSDateFormatter alloc] init];
    [dateFormatterISO setDateFormat:kDate_ISO8601];
    
    [self startRefreshingServiceRequest];
    
    mediaUrl = _report.postData[kOpen311_Media];
    if (mediaUrl) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:mediaUrl
                 resultBlock:^(ALAsset *asset) {
                     ALAssetRepresentation *rep = [asset defaultRepresentation];
                     UIImage *original = [UIImage imageWithCGImage:[rep fullScreenImage]];
                     media = [Media resizeImage:original toBoundingBox:100];
                 }
                failureBlock:^(NSError *error) {
                    DLog(@"Failed to load media from library");
                }];
    }
}

#pragma mark Service Request Refreshing
- (void)startRefreshingServiceRequest
{
    NSDictionary *sr = _report.serviceRequest;
    NSString *serviceRequestId = sr[kOpen311_ServiceRequestId];
    if (serviceRequestId) {
        [_report startLoadingServiceRequest:serviceRequestId delegate:self];
    }
    else {
        NSString *token = sr[kOpen311_Token];
        [_report startLoadingServiceRequestIdFromToken:token delegate:self];
    }
}

- (void)didReceiveServiceRequest:(NSDictionary *)serviceRequest
{
    for (NSString *key in [serviceRequest allKeys]) {
        _report.serviceRequest[key] = serviceRequest[key];
    }
    [[Preferences sharedInstance] saveReport:_report forIndex:_reportIndex];
    [self.tableView reloadData];
}

- (void)didReceiveServiceRequestId:(NSString *)serviceRequestId
{
    _report.serviceRequest[kOpen311_ServiceRequestId] = serviceRequestId;
    [[Preferences sharedInstance] saveReport:_report forIndex:_reportIndex];
    [_report startLoadingServiceRequest:serviceRequestId delegate:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (mediaUrl) {
            return 2;
        }
        return 1;
    }
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        NSDictionary *sr = _report.serviceRequest;
        NSDictionary *post = _report.postData;
        
        NSString *titleForHeader = nil;
        
        if ( sr ) {
            id srDescription = sr[kOpen311_Description];
            if ( srDescription != [NSNull null] ) {
                titleForHeader = srDescription;
            }
        }
        
        if ( titleForHeader == nil ) {
            id postDescription = post[kOpen311_Description];
            if ( postDescription != [NSNull null] ) {
                titleForHeader = postDescription;
            }
        }
        
        if ( titleForHeader )
            return titleForHeader;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    
    NSDictionary *sr   = _report.serviceRequest;
    NSDictionary *post = _report.postData;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:kCFDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    if (indexPath.section == 0) {
        if (mediaUrl && indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:kMediaCell forIndexPath:indexPath];
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:kImageViewTag];
            [imageView setImage:media];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = NSLocalizedString(kUI_Location, nil);
            
            NSString *text = nil;
            if (sr          &&   sr[kOpen311_Address]       != [NSNull null]) { text =   sr[kOpen311_Address];       }
            if (text == nil && post[kOpen311_AddressString] != [NSNull null]) {
                text = post[kOpen311_AddressString];
            }
            if (text != nil) { cell.detailTextLabel.text = text; }
        }
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];

        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = NSLocalizedString(kOpen311_CaseNumber, nil);
                cell.detailTextLabel.text = (sr && sr[kOpen311_CaseNumber]!=[NSNull null]) ? sr[kOpen311_CaseNumber] : @"";
                break;
            case 1:
                cell.textLabel.text = NSLocalizedString(kUI_ReportDate, nil);
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                             [dateFormatter stringFromDate:_report.requestedDate]];
                break;

            case 2:
                cell.textLabel.text = NSLocalizedString(kUI_ReportStatus, nil);
                cell.detailTextLabel.text = (sr && sr[kOpen311_Status]!=[NSNull null]) ? sr[kOpen311_Status] : kUI_Pending;
                break;
                
            case 3:
                cell.textLabel.text = NSLocalizedString(kOpen311_AgencyResponsible, nil);
                cell.detailTextLabel.text = (sr && sr[kOpen311_AgencyResponsible]!=[NSNull null]) ? sr[kOpen311_AgencyResponsible] : @"";
                break;
                           
            default:
                break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (mediaUrl && indexPath.section==0 && indexPath.row==0) {
        return 122;
    }
    return UITableViewAutomaticDimension;
}



@end

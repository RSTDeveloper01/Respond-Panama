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

#import "HomeController.h"
#import "Strings.h"
#import "Preferences.h"
#import "Open311.h"

#import "ChooseServiceController.h"
#import "Preferences.h"

@interface HomeController ()

@end

static NSString * const kSegueToSettings = @"SegueToSettings";
static NSString * const kSegueToServices = @"SegueToChooseServiceFromAccount";
@implementation HomeController {
    Open311 *open311;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    UIActivityIndicatorView *busyIcon;
    NSDictionary *selectedAccount;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.reportLabel     .text = NSLocalizedString(kUI_Report,  nil);
    self.archiveLabel    .text = NSLocalizedString(kUI_Archive, nil);
    self.reportingAsLabel.text = NSLocalizedString(kUI_ReportingAs, nil);
    self.currentLocationLabel.text = NSLocalizedString(kUI_CurrentLocation, nil);
    self.locationLabel.text = NSLocalizedString(kUI_LocationNotAvailable, nil);
    
    self.navigationItem.title = NSLocalizedString(kUI_AppTitle,nil);
    [self.navigationItem.leftBarButtonItem setTitle:NSLocalizedString(kUI_HelpTitle, nil)];
    [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(kUI_Settings, nil)];
    
    [[self.tabBarController.tabBar.items objectAtIndex:kTab_Home]  setTitle:NSLocalizedString(kUI_TitleHome,  nil)];
    [[self.tabBarController.tabBar.items objectAtIndex:kTab_Report]  setTitle:NSLocalizedString(kUI_Report,  nil)];
    [[self.tabBarController.tabBar.items objectAtIndex:kTab_Archive] setTitle:NSLocalizedString(kUI_Archive, nil)];
   
    
    self.tabBarController.delegate = self;
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self.tabBarController.tabBar.items objectAtIndex:kTab_Report]setEnabled:YES];
    open311 = [Open311 sharedInstance];
    
    if(open311.accounts == nil || (open311.accounts!=nil && open311.accounts.count == 0)){
        Preferences *preferences = [Preferences sharedInstance];
        NSDictionary *currentServer = [preferences getCurrentServer];
        NSString *filename = currentServer[kOpen311_SplashImage];
        if (!filename) { filename = @"respond"; }
        [self.splashImage setImage:[UIImage imageNamed:filename]];

        if(currentServer == nil)
        {
            NSDictionary* server= [[NSDictionary alloc]initWithObjectsAndKeys:
                               [NSNumber numberWithBool:TRUE],kOpen311_SupportsMedia,
                               @"json",kOpen311_Format,
                               @"http://10.252.70.27:500/Open311API.svc/",kOpen311_Url,
                               @"00000000-0000-0000-0000-000000000000",kOpen311_ApiKey,
                               @"Panama",kOpen311_Name,
                               @"RespondPanamaDev",kOpen311_Jurisdiction,nil];
            currentServer = server;
            [preferences setCurrentServer:server];
            self.navigationItem.title = @"Panama";
        }
    

        [self startBusyIcon];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(provincesListReady)
                                                 name:kNotification_ProvincesListReady
                                               object:open311];
        
        [open311 loadAllMetadataForServer:currentServer];
        [open311 loadProvinces];
    }
    [self refreshPersonalInfo];
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
    [busyIcon stopAnimating];
    [busyIcon removeFromSuperview];
}

-(void)accountListReady
{
    [busyIcon stopAnimating];
    [busyIcon removeFromSuperview];
}

-(void)provincesListReady
{
    [busyIcon stopAnimating];
    [busyIcon removeFromSuperview];
}


- (void)refreshPersonalInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *text = @"";
    NSString *firstname = [defaults stringForKey:kOpen311_FirstName];
    NSString *lastname  = [defaults stringForKey:kOpen311_LastName];
    NSString *email     = [defaults stringForKey:kOpen311_Email];
    NSString *phone     = [defaults stringForKey:kOpen311_Phone];
    NSString *city      = [defaults stringForKey:kOpen311_Province];
//    NSString *city      = [defaults stringForKey:kOpen311_City];
    NSString *cedula    = [defaults stringForKey:kOpen311_Cedula];
    if ([firstname length] > 0 || [lastname length] > 0) {
        text = [text stringByAppendingFormat:@"%@ %@", firstname, lastname];
    }
    
    if([cedula length] > 0){
        text = [text stringByAppendingFormat:@"\r%@", cedula];
    }
    
    if ([email length] > 0) {
        text = [text stringByAppendingFormat:@"\r%@", email];
    }
    if ([phone length] > 0) {
        text = [text stringByAppendingFormat:@"\r%@", phone];
    }
    
    if ([city length] > 0) {
        text = [text stringByAppendingFormat:@"\r%@", city];
    }
    
    if ([text length] == 0) {
        text = NSLocalizedString(kUI_Anonymous,  nil);
    }
    self.personalInfoLabel.text = text;
    [self.tableView reloadData];
}


-(void) personalInfoUpdated:(bool)value{
    if(value){
        [self refreshPersonalInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Table Handler Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        CGSize size = [self.personalInfoLabel.text sizeWithFont:self.personalInfoLabel.font
                                              constrainedToSize:CGSizeMake(300, 140)
                                                  lineBreakMode:self.personalInfoLabel.lineBreakMode];
        NSInteger height = size.height + 28;
        return (CGFloat)height;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            selectedAccount = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Panama",@"account_name",
                               @"",@"url"
                               , nil];
            
            [[self.tabBarController.tabBar.items objectAtIndex:kTab_Report]setEnabled:NO];
            [self performSegueWithIdentifier:kSegueToServices sender:self];
            [self.tabBarController setSelectedIndex:kTab_Home];
        }
        else if (indexPath.row == 1) {
            [self.tabBarController setSelectedIndex:kTab_Archive];
        }
    }
    if (indexPath.section == 1 && indexPath.row==0) {
        [self performSegueWithIdentifier:kSegueToSettings sender:self];
    }
}


#pragma mark Action Sheet Delegate Methods
-(void) showActionSheet{
    UIActionSheet *popupQuery= [[UIActionSheet alloc]initWithTitle:NSLocalizedString(kUI_SelectCityTitle,nil)delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *userCity = @"";
    NSString *gpsCity  = @"";
    
    if([preferences objectForKey:kOpen311_City]!=nil)
    {
       userCity= [preferences objectForKey:kOpen311_City];
    }
    if(open311.gpsCity != nil)
    {
        gpsCity = open311.gpsCity;
    }
    
    if(![userCity isEqualToString:@""] && ![gpsCity isEqualToString:@""])
    {
            
            if([userCity isEqualToString:gpsCity])
            {
                [popupQuery addButtonWithTitle:[NSString stringWithFormat:@"%@ - %@",NSLocalizedString(kUI_GPSCity,  nil),gpsCity]];
            }
            else
            {
                
                [popupQuery addButtonWithTitle:[NSString stringWithFormat:@"%@ - %@",NSLocalizedString(kUI_UserCity,  nil),userCity]];
                [popupQuery addButtonWithTitle:[NSString stringWithFormat:@"%@ - %@",NSLocalizedString(kUI_GPSCity,  nil),gpsCity]];
            }
                
    }
    else if(![gpsCity isEqualToString:@""]){
                [popupQuery addButtonWithTitle:[NSString stringWithFormat:@"%@ - %@",NSLocalizedString(kUI_GPSCity,  nil),gpsCity]];
    }
    
    else if(![userCity isEqualToString:@""])
    {
                [popupQuery addButtonWithTitle:[NSString stringWithFormat:@"%@ - %@",NSLocalizedString(kUI_UserCity,  nil),userCity]];
    }
    
      
    [popupQuery addButtonWithTitle:NSLocalizedString(kUI_Other,nil)];
    [popupQuery addButtonWithTitle:NSLocalizedString(kUI_Cancel,nil)];
    
    [popupQuery setCancelButtonIndex:(popupQuery.numberOfButtons-1)];
    
    popupQuery.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if([actionSheet cancelButtonIndex] != buttonIndex){
        if(![[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:NSLocalizedString(kUI_Other,nil)])
        {
            
            NSString *city=[[[actionSheet buttonTitleAtIndex:buttonIndex]componentsSeparatedByString:@" - "]objectAtIndex:1];
                        
            int i = 0;
            for(NSDictionary *account in open311.accounts){
                if([[account objectForKey:@"account_name"]isEqualToString:city]){
                    selectedAccount = account;
                    break;
                }
                i++;
            }
            if(selectedAccount!=nil){
                [[self.tabBarController.tabBar.items objectAtIndex:kTab_Report]setEnabled:NO];
                [self performSegueWithIdentifier:kSegueToServices sender:self];
            }
        }
        else
        {
            [self.tabBarController setSelectedIndex:kTab_Report];
        }
    }
}

#pragma mark Tab Bar Controller Delegate Methods

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    
    if([tabBarController.tabBar.items objectAtIndex:kTab_Report] == viewController.tabBarItem){
        selectedAccount = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Panama",@"account_name",
                           @"",@"url"
                           , nil];
        
        [[self.tabBarController.tabBar.items objectAtIndex:kTab_Report]setEnabled:NO];
        [self performSegueWithIdentifier:kSegueToServices sender:self];
        [self.tabBarController setSelectedIndex:kTab_Home];
    }
}


- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if([identifier isEqualToString:kSegueToServices] && selectedAccount == nil){
        return NO;
    }
    else{
        return YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:kSegueToServices]){
        ChooseServiceController *chooseService = [segue destinationViewController];
        chooseService.account = selectedAccount;
        selectedAccount=nil;
    }else if([segue.identifier isEqualToString:kSegueToSettings]){
        [segue.destinationViewController setDelegate:self];
    }
}


@end

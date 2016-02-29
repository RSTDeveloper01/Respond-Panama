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

#import "PersonalInfoController.h"
#import "Strings.h"
#import "Open311.h"

@interface PersonalInfoController (){
    NSArray *provinces;
}

@end

@implementation PersonalInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(kUI_PersonalInfo, nil);
    
    self.labelFirstName.text = NSLocalizedString(kUI_FirstName, nil);
    self.labelLastName .text = NSLocalizedString(kUI_LastName,  nil);
    self.labelEmail    .text = NSLocalizedString(kUI_Email,     nil);
    self.labelPhone    .text = NSLocalizedString(kUI_Phone,     nil);
    self.labelProvince .text = NSLocalizedString(kUI_Province,  nil);
    self.labelCedula   .text = NSLocalizedString(kUI_Cedula, nil);
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    self.textFieldFirstName.text = [preferences stringForKey:kOpen311_FirstName];
    self.textFieldLastName .text = [preferences stringForKey:kOpen311_LastName];
    self.textFieldCedula   .text = [preferences stringForKey:kOpen311_Cedula];
    self.textFieldEmail    .text = [preferences stringForKey:kOpen311_Email];
    self.textFieldPhone    .text = [preferences stringForKey:kOpen311_Phone];
    self.textFieldProvince .text = [preferences stringForKey:kOpen311_Province];

    provinces = [[NSArray alloc]init];
    provinces = [[Open311 sharedInstance] provinces];
    [self.textFieldProvince setInputView: self.provincePickerView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(IBAction)done:(id)sender
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setValue:self.textFieldFirstName.text forKey:kOpen311_FirstName];
    [preferences setValue:self.textFieldLastName .text forKey:kOpen311_LastName];
    [preferences setValue:self.textFieldCedula   .text forKey:kOpen311_Cedula];
    [preferences setValue:self.textFieldEmail    .text forKey:kOpen311_Email];
    [preferences setValue:self.textFieldPhone    .text forKey:kOpen311_Phone];
    [preferences setValue:self.textFieldProvince .text forKey:kOpen311_Province];

    //[self.navigationController popViewControllerAnimated:YES];
    [self.delegate personalInfoUpdated:YES];
}

#pragma mark - Picker View handlers

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return provinces.count+1;
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    
    if(row == 0){
        return @"--Provincia--";
    }
    else{
        NSString *province = [[provinces objectAtIndex:row-1]objectForKey:@"province_name"];
        
        if([_textFieldProvince.text isEqualToString:province])
        {
            [pickerView selectRow:row inComponent:0 animated:YES];
            
        }
        return [[provinces objectAtIndex:row-1]objectForKey:@"province_name"];
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    
    if(row != 0){
        _textFieldProvince.text = [[provinces objectAtIndex:row-1]objectForKey:@"province_name"];
    }
    else{
        _textFieldProvince.text=@"";
    }
}



-(void) selectDefault{
    
    if(![_textFieldProvince.text isEqualToString:@""]){
        int i = 0;
        for(NSDictionary *province in provinces)
        {
            if([[province objectForKey:@"province_name"] isEqualToString:_textFieldProvince.text]){
                [_provincePickerView selectRow:i+1 inComponent:0 animated:NO];
                break;
            }
            i++;
        }
    }
    
}

#pragma mark - Table view handlers

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return NSLocalizedString(kUI_PersonalInfo, nil);
    return @"";
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if      (indexPath.row == 0) { [self.textFieldFirstName becomeFirstResponder]; }
    else if (indexPath.row == 1) { [self.textFieldLastName  becomeFirstResponder]; }
    else if (indexPath.row == 2) { [self.textFieldCedula becomeFirstResponder];    }
    else if (indexPath.row == 3) { [self.textFieldEmail     becomeFirstResponder]; }
    else if (indexPath.row == 4) {
        [self.textFieldPhone  becomeFirstResponder];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else if (indexPath.row == 5) {
        [self.provincePickerView setHidden:NO];
        [self selectDefault];
        [self.textFieldProvince  resignFirstResponder];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([textField.restorationIdentifier isEqualToString:@"provinceTextField"]){
        [self selectDefault];
        [self.provincePickerView setHidden:NO];
        return NO;
    }
    return YES;
}

@end

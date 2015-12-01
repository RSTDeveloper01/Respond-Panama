//
//  HelpController.m
//  GeoReporter
//
//  Created by RSTDeveloper01 on 6/19/13.
//  Copyright (c) 2013 City of Bloomington. All rights reserved.
//

#import "HelpController.h"
#import "Strings.h"
@interface HelpController ()

@end

@implementation HelpController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(kUI_HelpTitle,nil);
    self.helpTextView.text= NSLocalizedString(kUI_HelpText,nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

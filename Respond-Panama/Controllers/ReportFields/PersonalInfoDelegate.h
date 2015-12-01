//
//  PersonalInfoDelegate.h
//  Respond
//
//  Created by RSTDeveloper01 on 11/25/15.
//  Copyright (c) 2015 City of Bloomington. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PersonalInfoDelegate <NSObject>
@required
- (void)personalInfoUpdated:(bool)value;
@end

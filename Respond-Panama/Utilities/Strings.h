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

#import <Foundation/Foundation.h>
// Tab indexes
extern NSInteger const kTab_Home;
extern NSInteger const kTab_Report;
extern NSInteger const kTab_Archive;
extern NSInteger const kTab_Servers;

// Keys to the Localized String file
extern NSString * const kUI_AppTitle;
extern NSString * const kUI_HelpTitle;
extern NSString * const kUI_HelpText;
extern NSString * const kUI_Settings;
extern NSString * const kUI_Report;
extern NSString * const kUI_Archive;
extern NSString * const kUI_About;
extern NSString * const kUI_AboutText;
extern NSString * const kUI_TitleHome;
extern NSString * const kUI_Anonymous;
extern NSString * const kUI_PersonalInfo;
extern NSString * const kUI_Servers;
extern NSString * const kUI_ButtonAddServer;
extern NSString * const kUI_ButtonAcceptError;
extern NSString * const kUI_ReportingAs;
extern NSString * const kUI_CurrentLocation;
extern NSString * const kUI_LocationNotAvailable;
extern NSString * const kUI_FirstName;
extern NSString * const kUI_LastName;
extern NSString * const kUI_Email;
extern NSString * const kUI_Phone;
extern NSString * const kUI_City;
extern NSString * const kUI_Province;
extern NSString * const kUI_Cedula;
extern NSString * const kUI_Cities;
extern NSString * const kUI_Name;
extern NSString * const kUI_Url;
extern NSString * const kUI_JurisdictionId;
extern NSString * const kUI_ApiKey;
extern NSString * const kUI_Format;
extern NSString * const kUI_SupportsMedia;
extern NSString * const kUI_DialogLoadingServices;
extern NSString * const kUI_DialogPostingService;
extern NSString * const kUI_PhotosPermissionTitle;
extern NSString * const kUI_PhotosPermission;
extern NSString * const kUI_AddPhoto;
extern NSString * const kUI_ChooseMediaSource;
extern NSString * const kUI_Camera;
extern NSString * const kUI_Gallery;
extern NSString * const kUI_Location;
extern NSString * const kUI_Standard;
extern NSString * const kUI_Satellite;
extern NSString * const kUI_ReportStatus;
extern NSString * const kUI_ReportAttributes;
extern NSString * const kUI_ReportDescription;
extern NSString * const kUI_ReportDescriptionFull;
extern NSString * const kUI_ReportAdditionalAddress;
extern NSString * const kUI_ReportAdditionalAddressShort;
extern NSString * const kUI_ReportDate;
extern NSString * const kUI_Submit;
extern NSString * const kUI_Share;
extern NSString * const kUI_Cancel;
extern NSString * const kUI_Save;
extern NSString * const kUI_Pending;
extern NSString * const kUI_ServiceRequestRemovedTitle;
extern NSString * const kUI_ServiceRequestRemovedQuestion;
extern NSString * const kUI_OutOfPRTitle;
extern NSString * const kUI_OutOfPRMessage;
extern NSString * const kUI_OutOfPRNotice;
extern NSString * const kUI_PleaseProvideDetails;
extern NSString * const kUI_Yes;
extern NSString * const kUI_No;
extern NSString * const kUI_Accept;
extern NSString * const kUI_Uncategorized;
extern NSString * const kUI_FailureLoadingServices;
extern NSString * const kUI_ServiceRequestFailure;
extern NSString * const kUI_FailurePostingService;
extern NSString * const kUI_Error403;
extern NSString * const kUI_CommError;
extern NSString * const kUI_MinCharactersError;
extern NSString * const kUI_ReportDisclaimerTitle;
extern NSString * const kUI_ReportDisclaimerMsg;

// Open311 Key Strings
// Global required fields
extern NSString * const kOpen311_Jurisdiction;
extern NSString * const kOpen311_ApiKey;
extern NSString * const kOpen311_Format;
extern NSString * const kOpen311_ServiceCode;
extern NSString * const kOpen311_ServiceName;
extern NSString * const kOpen311_Group;
// RST Key Strings
// Account fields
extern NSString * const kRst_AccountName;
extern NSString * const kRst_AccountURL;
extern NSString * const kRst_InformationalTopicHeader;
// Global basic fields
extern NSString * const kOpen311_Media;
extern NSString * const kOpen311_MediaUrl;
extern NSString * const kOpen311_Latitude;
extern NSString * const kOpen311_Longitude;
extern NSString * const kOpen311_Address;
extern NSString * const kOpen311_UserInfo;
extern NSString * const kOpen311_SelectACity;
extern NSString * const kOpen311_AddressString;
extern NSString * const kOpen311_Description;
extern NSString * const kOpen311_AdditionalAddressInfo;
extern NSString * const kOpen311_ServiceNotice;
extern NSString * const kOpen311_AccountId;
extern NSString * const kOpen311_Status;
extern NSString * const kOpen311_Open;
extern NSString * const kOpen311_Closed;
extern NSString * const kOpen311_Cancelled;
extern NSString * const kOpen311_Pending;
extern NSString * const kOpen311_StatusNotes;
extern NSString * const kOpen311_AgencyResponsible;
extern NSString * const kOpen311_RequestedDatetime;
extern NSString * const kOpen311_UpdatedDatetime;
extern NSString * const kOpen311_ExpectedDatetime;
extern NSString * const kOpen311_ServiceRequestId;
extern NSString * const kOpen311_Token;
extern NSString * const kRst_Account;
extern NSString * const kRst_ReportedTo;
extern NSString * const kOpen311_CaseNumber;
// Personal Information fields
extern NSString * const kOpen311_FirstName;
extern NSString * const kOpen311_LastName;
extern NSString * const kOpen311_Email;
extern NSString * const kOpen311_Phone;
extern NSString * const kOpen311_DeviceId;
extern NSString * const kOpen311_City;
extern NSString * const kOpen311_Province;
extern NSString * const kOpen311_Cedula;
// Custom field definition in service_definition
extern NSString * const kOpen311_Metadata;
extern NSString * const kOpen311_Attributes;
extern NSString * const kOpen311_Attribute;
extern NSString * const kOpen311_Variable;
extern NSString * const kOpen311_Code;
extern NSString * const kOpen311_Order;
extern NSString * const kOpen311_Values;
extern NSString * const kOpen311_Value;
extern NSString * const kOpen311_Key;
extern NSString * const kOpen311_Name;
extern NSString * const kOpen311_Required;
extern NSString * const kOpen311_Datatype;
extern NSString * const kOpen311_DatatypeDescription;
extern NSString * const kOpen311_String;
extern NSString * const kOpen311_Number;
extern NSString * const kOpen311_Datetime;
extern NSString * const kOpen311_Text;
extern NSString * const kOpen311_True;
extern NSString * const kOpen311_SingleValueList;
extern NSString * const kOpen311_MultiValueList;
// Key names from AvailableServers.plist
extern NSString * const kOpen311_Url;
extern NSString * const kOpen311_SupportsMedia;
extern NSString * const kOpen311_SplashImage;
// Key names for formats
extern NSString * const kOpen311_JSON;
extern NSString * const kOpen311_XML;
//RST ActionSheet labels
extern NSString * const kUI_SelectCityTitle;
extern NSString * const kUI_GPSCity;
extern NSString * const kUI_UserCity;
extern NSString *  const kUI_Other;


//RST Constants
extern NSString * const krst_Service_Category;
extern NSString * const krst_ServiceId;
extern NSString * const krst_Service_CategoryName;
extern NSString * const krst_Service_DescriptionHTML;

extern NSString * const rst_Service_Category_Service;
extern NSString * const rst_Service_Category_Info;


extern NSString * const kUI_EnableLocationServicesTitle;
extern NSString * const kUI_EnableLocationServices;

extern NSString * const kDate_ISO8601;

@interface Strings : NSObject
@end

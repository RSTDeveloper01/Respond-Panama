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

#import "Strings.h"
// Tab indexes
NSInteger const kTab_Home    = 0;
NSInteger const kTab_Report  = 1;
NSInteger const kTab_Archive = 2;


// Keys to the Localized String file
NSString * const kUI_AppTitle               = @"app_title";
NSString * const kUI_HelpTitle              = @"help_title";
NSString * const kUI_HelpText               = @"help_text";
NSString * const kUI_Settings               = @"menu_settings";
NSString * const kUI_Report                 = @"menu_report";
NSString * const kUI_Archive                = @"menu_archive";
NSString * const kUI_About                  = @"menu_about";
NSString * const kUI_AboutText              = @"about_text";
NSString * const kUI_TitleHome              = @"title_home";
NSString * const kUI_PersonalInfo           = @"personal_info";
NSString * const kUI_Anonymous              = @"anonymous";
NSString * const kUI_CurrentLocation        = @"current_location";
NSString * const kUI_LocationNotAvailable   = @"location_not_available";
NSString * const kUI_Servers                = @"servers";
NSString * const kUI_ButtonAddServer        = @"button_add_server";
NSString * const kUI_ButtonAcceptError      = @"button_accept_error";
NSString * const kUI_ReportingAs            = @"reporting_as";
NSString * const kUI_FirstName              = @"first_name";
NSString * const kUI_LastName               = @"last_name";
NSString * const kUI_Email                  = @"email";
NSString * const kUI_Phone                  = @"phone";
NSString * const kUI_Province               = @"province";
NSString * const kUI_Provinces               = @"provinces";
NSString * const kUI_City                   = @"city";
NSString * const kUI_Cities                 = @"cities";
NSString * const kUI_Cedula                 = @"cedula";
NSString * const kUI_Name                   = @"name";
NSString * const kUI_Url                    = @"url";
NSString * const kUI_JurisdictionId         = @"jurisdiction_id";
NSString * const kUI_ApiKey                 = @"api_key";
NSString * const kUI_Format                 = @"format";
NSString * const kUI_SupportsMedia          = @"supports_media";
NSString * const kUI_DialogLoadingServices  = @"dialog_loading_services";
NSString * const kUI_DialogPostingService   = @"dialog_posting_service";
NSString * const kUI_PhotosPermissionTitle  = @"photos_permission_warning_title";
NSString * const kUI_PhotosPermission       = @"photos_permission_warning";
NSString * const kUI_AddPhoto               = @"add_photo";
NSString * const kUI_ChooseMediaSource      = @"choose_media_source";
NSString * const kUI_Camera                 = @"camera";
NSString * const kUI_Gallery                = @"gallery";
NSString * const kUI_Location               = @"location";
NSString * const kUI_Standard               = @"map_button_standard";
NSString * const kUI_Satellite              = @"map_button_satellite";
NSString * const kUI_ReportStatus           = @"report_status";
NSString * const kUI_ReportAttributes       = @"report_attributes";
NSString * const kUI_ReportDescription      = @"report_description";
NSString * const kUI_ReportDescriptionFull      = @"report_description_full";
NSString * const kUI_ReportAdditionalAddress      = @"report_additionaladdress";
NSString * const kUI_ReportAdditionalAddressShort      = @"report_additionaladdress_short";
NSString * const kUI_ReportDate             = @"report_date";
NSString * const kUI_Submit                 = @"submit";
NSString * const kUI_Share                  = @"share";
NSString * const kUI_Cancel                 = @"cancel";
NSString * const kUI_Save                   = @"save";
NSString * const kUI_Pending                = @"pending";
NSString * const kUI_OutOfPRTitle           = @"out_of_PR_title";
NSString * const kUI_OutOfPRMessage         = @"out_of_PR";
NSString * const kUI_OutOfPRNotice          = @"out_of_PR_notice";
NSString * const kUI_PleaseProvideDetails   = @"provide_details";
NSString * const kUI_Yes                    = @"yes";
NSString * const kUI_No                     = @"no";
NSString * const kUI_Accept                     = @"accept";
NSString * const kUI_Uncategorized          = @"uncategorized";
NSString * const kUI_ServiceRequestRemovedTitle = @"service_removed_title";
NSString * const kUI_ServiceRequestRemovedQuestion = @"service_removed_message";
NSString * const kUI_ServiceRequestFailure  = @"service_request_failure";
NSString * const kUI_FailureLoadingServices = @"failure_loading_services";
NSString * const kUI_FailurePostingService  = @"failure_posting_service";
NSString * const kUI_Error403               = @"error_403";
NSString * const kUI_CommError              = @"general_communication_error";
NSString * const kUI_MinCharactersError              = @"report_min_characters";
NSString * const kUI_ReportDisclaimerMsg              = @"report_disclaimer_msg";
NSString * const kUI_ReportDisclaimerTitle              = @"report_disclaimer_title";

// Open311 Key Strings
// Global required fields
NSString * const kOpen311_Jurisdiction = @"jurisdiction_id";
NSString * const kOpen311_ApiKey       = @"api_key";
NSString * const kOpen311_Format       = @"format";
NSString * const kOpen311_ServiceCode  = @"service_code";
NSString * const kOpen311_ServiceName  = @"service_name";
NSString * const kOpen311_Group        = @"group";
// RST Key Strings
// Account fields
NSString * const kRst_AccountName      = @"account_name";
NSString * const kRst_AccountURL       = @"url";
NSString * const kRst_InformationalTopicHeader = @"info_topic_header";
// Global basic fields
NSString * const kOpen311_Media              = @"media";
NSString * const kOpen311_MediaUrl           = @"media_url";
NSString * const kOpen311_Latitude           = @"lat";
NSString * const kOpen311_Longitude          = @"long";
NSString * const kOpen311_Address            = @"address";
NSString * const kOpen311_UserInfo           = @"user_info";
NSString * const kOpen311_SelectACity        = @"select_a_city";
NSString * const kOpen311_SelectAProvince    = @"select_a_province";
NSString * const kOpen311_AddressString      = @"address_string";
NSString * const kOpen311_Description        = @"description";
NSString * const kOpen311_AdditionalAddressInfo  = @"additional_address_info";
NSString * const kOpen311_ServiceNotice      = @"service_notice";
NSString * const kOpen311_AccountId 	     = @"account_id";
NSString * const kOpen311_Status 		     = @"status";
NSString * const kOpen311_Open               = @"report_open";
NSString * const kOpen311_Closed             = @"report_closed";
NSString * const kOpen311_Cancelled          = @"report_cancelled";
NSString * const kOpen311_Pending            = @"report_pending";
NSString * const kOpen311_StatusNotes        = @"status_notes";
NSString * const kOpen311_AgencyResponsible  = @"agency_responsible";
NSString * const kOpen311_RequestedDatetime  = @"requested_datetime";
NSString * const kOpen311_UpdatedDatetime    = @"updated_datetime";
NSString * const kOpen311_ExpectedDatetime   = @"expected_datetime";
NSString * const kOpen311_ServiceRequestId   = @"service_request_id";
NSString * const kOpen311_Token              = @"token";
NSString * const kRst_Account                = @"account";
NSString * const kRst_ReportedTo             = @"reported_to";
NSString * const kOpen311_CaseNumber         = @"case_number";
// Personal Information fields
NSString * const kOpen311_FirstName = @"first_name";
NSString * const kOpen311_LastName  = @"last_name";
NSString * const kOpen311_Email     = @"email";
NSString * const kOpen311_Phone     = @"phone";
NSString * const kOpen311_City     = @"city";
NSString * const kOpen311_Province     = @"province";
NSString * const kOpen311_Cedula     = @"cedula";
NSString * const kOpen311_DeviceId  = @"device_id";
// Custom field definition in service_definition
NSString * const kOpen311_Metadata     = @"metadata";
NSString * const kOpen311_Attributes   = @"attributes";
NSString * const kOpen311_Attribute    = @"attribute";
NSString * const kOpen311_Variable     = @"variable";
NSString * const kOpen311_Code         = @"code";
NSString * const kOpen311_Order        = @"order";
NSString * const kOpen311_Values       = @"values";
NSString * const kOpen311_Value        = @"value";
NSString * const kOpen311_Key          = @"key";
NSString * const kOpen311_Name         = @"name";
NSString * const kOpen311_Required     = @"required";
NSString * const kOpen311_Datatype     = @"datatype";
NSString * const kOpen311_DatatypeDescription = @"datatype_description";
NSString * const kOpen311_String       = @"string";
NSString * const kOpen311_Number       = @"number";
NSString * const kOpen311_Datetime     = @"datetime";
NSString * const kOpen311_Text         = @"text";
NSString * const kOpen311_True         = @"true";
NSString * const kOpen311_SingleValueList = @"singlevaluelist";
NSString * const kOpen311_MultiValueList  = @"multivaluelist";
// Key names from AvailableServers.plist
NSString * const kOpen311_Url           = @"url";
NSString * const kOpen311_SupportsMedia = @"supports_media";
NSString * const kOpen311_SplashImage   = @"splash_image";
// Key names for formats
NSString * const kOpen311_JSON = @"json";
NSString * const kOpen311_XML  = @"xml";


//RST Constants
NSString * const krst_Service_Category		= @"rst_category";
NSString * const krst_ServiceId             = @"rst_serviceid";
NSString * const krst_Service_CategoryName		= @"rst_categoryName";
NSString * const krst_Service_DescriptionHTML		= @"rst_descriptionHTML";

NSString * const rst_Service_Category_Service		= @"866570000";
NSString * const rst_Service_Category_Info		= @"866570001";


//City you want to Report To
NSString * const kUI_SelectCityTitle     =@"select_city_title";
NSString * const kUI_GPSCity             =@"gps_city";
NSString * const kUI_UserCity            =@"user_city";
NSString * const kUI_Other               =@"other";

NSString * const kUI_EnableLocationServicesTitle = @"enable_location_services_title";
NSString * const kUI_EnableLocationServices = @"enable_location_services";


//Date Format
NSString * const kDate_ISO8601 = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";

@implementation Strings

@end

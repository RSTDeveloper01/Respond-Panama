//
//  ServiceRequest.m
//  GeoReporter
//
//  Created by Cliff Ingham on 2/4/13.
//  Copyright (c) 2013 City of Bloomington. All rights reserved.
//
//  Modified by Samuel Rivera.
//  Copyright (c) 2016 Rock Solid Technologies, Inc.


#import "Report.h"
#import "Preferences.h"
#import "Strings.h"
#import "Open311.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"


@implementation Report {
    AFHTTPSessionManager *httpClient;
    NSMutableDictionary *parameters;
}
NSString * const kServer            = @"server";
NSString * const kRequestedDate     = @"date";
NSString * const kService           = @"service";
NSString * const kServiceDefinition = @"serviceDefinition";
NSString * const kServiceRequest    = @"serviceRequest";
NSString * const kPostData          = @"postData";

// Intialize a new, empty service request
//
// This does not load any user-submitted data and should only
// be used for initial startup.  Subsequent loads should be done
// using the String version
- (id)initWithService:(NSDictionary *)service
{
    self = [super init];
    if (self) {
        _service  = service;
        
        if ([_service[kOpen311_Metadata] boolValue]) {
            Open311 *open311 = [Open311 sharedInstance];
            _serviceDefinition = open311.serviceDefinitions[_service[kOpen311_ServiceCode]];
        }
        
        _postData = [[NSMutableDictionary alloc] init];
        _postData[kOpen311_ServiceCode] = _service[kOpen311_ServiceCode];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *firstname = [prefs stringForKey:kOpen311_FirstName];
        NSString *lastname  = [prefs stringForKey:kOpen311_LastName];
        NSString *email     = [prefs stringForKey:kOpen311_Email];
        NSString *phone     = [prefs stringForKey:kOpen311_Phone];
        NSString *cedula     = [prefs stringForKey:kOpen311_Cedula];
        NSString *province     = [prefs stringForKey:kOpen311_Province];
        
        if (firstname != nil) { _postData[kOpen311_FirstName] = firstname; }
        if (lastname  != nil) { _postData[kOpen311_LastName]  = lastname; }
        if (email     != nil) { _postData[kOpen311_Email]     = email; }
        if (phone     != nil) { _postData[kOpen311_Phone]     = phone; }
        if (cedula    != nil) { _postData[kOpen311_Cedula]    = cedula; }
        if (province    != nil) { _postData[kOpen311_Province]    = province; }
    }
    return self;
}

// Initialize a fully populated ServiceRequest from an unserialized dictionary
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _server            = dictionary[kServer];
        _service           = dictionary[kService];
        _serviceDefinition = dictionary[kServiceDefinition];
        _serviceRequest    = dictionary[kServiceRequest];
        _postData          = dictionary[kPostData];
        _requestedDate     = dictionary[kRequestedDate];
    }
    return self;
}

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
    if (_server)            { output[kServer]            = _server; }
    if (_service)           { output[kService]           = _service; }
    if (_serviceDefinition) { output[kServiceDefinition] = _serviceDefinition; }
    if (_serviceRequest)    { output[kServiceRequest]    = _serviceRequest; }
    if (_requestedDate)     { output[kRequestedDate]    = _requestedDate; }
    if (_postData)          { output[kPostData]          = _postData; }
    return [NSDictionary dictionaryWithDictionary:output];
}

// Looks up the attribute definition at the index and returns the key value
//
// This method only works for SingleValueList and MultiValueList attributes
// since they're the only attributes that have value lists
- (NSString *)attributeValueForKey:(NSString *)key atIndex:(NSInteger)index
{
    NSDictionary *attribute = _serviceDefinition[kOpen311_Attributes][index];
    if (   [attribute[kOpen311_Datatype] isEqualToString:kOpen311_SingleValueList]
        || [attribute[kOpen311_Datatype] isEqualToString:kOpen311_MultiValueList]) {
        for (NSDictionary *value in attribute[kOpen311_Values]) {
            // Some servers use non-string keys
            // We need to convert them to strings before checking them
            // If they were unique to begin with, they should still be unique
            // after string conversion
            NSObject *valueKey = value[kOpen311_Key];
            if ([valueKey isKindOfClass:[NSNumber class]]) {
                valueKey = [(NSNumber *)valueKey stringValue];
            }
            if ([(NSString *)valueKey isEqualToString:key]) {
                return value[kOpen311_Name];
            }
        }
    }
    return nil;
}

#pragma mark - Refresh Service Request data
- (AFHTTPSessionManager *)getHttpClient
{
    if ([httpClient baseURL] == NULL) {
        httpClient = [[[AFHTTPSessionManager alloc ] init ] initWithBaseURL:[NSURL URLWithString:[_server objectForKey:kOpen311_Url]]];
    }
    return httpClient;
}

- (NSMutableDictionary *)getEndpointParameters
{
    if (!parameters) {
        parameters = [[NSMutableDictionary alloc] init];
        NSString *jurisdictionId = _server[kOpen311_Jurisdiction];
        NSString *apiKey         = _server[kOpen311_ApiKey];
        if (jurisdictionId != nil) { parameters[kOpen311_Jurisdiction] = jurisdictionId; }
        if (apiKey         != nil) { parameters[kOpen311_ApiKey]       = apiKey; }
    }
    return parameters;
}

- (void)startLoadingServiceRequest:(NSString *)serviceRequestId delegate:(id<ServiceRequestDelegate>)delegate
{
    Open311 *open311 = [Open311 sharedInstance];
    
    AFHTTPSessionManager *client = [self getHttpClient];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [client GET:[NSString stringWithFormat:@"requests/%@.json", serviceRequestId]
         parameters:[self getEndpointParameters]
            success:^(NSURLSessionDataTask *operation, id responseObject) {
                NSError *error;
                NSArray *serviceRequests = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:&error];
                if (!error && serviceRequests.count > 0) {
                    [delegate didReceiveServiceRequest:serviceRequests[0]];
                }
                else {
                    [open311 loadFailedWithError:error];
                }
            }
            failure:^(NSURLSessionDataTask *operation, NSError *error) {
                [open311 loadFailedWithError:error];
            }];
}

- (void)startLoadingServiceRequestIdFromToken:(NSString *)token delegate:(id<ServiceRequestDelegate>)delegate
{
    Open311 *open311 = [Open311 sharedInstance];
    
    AFHTTPSessionManager *client = [self getHttpClient];
    
    [client GET:[NSString stringWithFormat:@"tokens/%@.json", token]
         parameters:[self getEndpointParameters]
            success:^(NSURLSessionDataTask *operation, id responseObject) {
                NSError *error;
                NSArray *serviceRequests = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:&error];
                NSString *serviceRequestId = serviceRequests[0][kOpen311_ServiceRequestId];
                if (!error) {
                    if (serviceRequestId) {
                        [delegate didReceiveServiceRequestId:serviceRequestId];
                    }
                    // It may take a while before a serviceRequestId is created on a server.
                    // In the meantime, they are not responding with an error.
                    // We just don't need to call our delegate, since we don't have an id yet.
                }
                else {
                    [open311 loadFailedWithError:error];
                }
            }
            failure:^(NSURLSessionDataTask *operation, NSError *error) {
                [open311 loadFailedWithError:error];
            }];
}

@end

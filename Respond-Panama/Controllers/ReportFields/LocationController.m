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

#import "LocationController.h"
#import "ReportController.h"
#import "Strings.h"
#import "Open311.h"

@interface LocationController ()

@end

static NSInteger const kMapTypeStandardIndex  = 0;
static NSInteger const kMapTypeSatelliteIndex = 1;
static CLLocationDegrees const kLatitudeDelta = 0.0025;
static CLLocationDegrees const kLongitudeDelta = 0.0025;

@implementation LocationController {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    ReportController *rc= (ReportController *) self.delegate;
    NSString *lat= [rc.report.postData objectForKey:kOpen311_Latitude];
    NSString *longitude= [rc.report.postData objectForKey:kOpen311_Longitude];
   
    
    
    if(!(lat==nil || [lat isEqualToString:@""]) && !(longitude==nil || [longitude isEqualToString:@""]))
    {
        MKCoordinateRegion region;
        region.center.latitude  = [lat doubleValue];
        region.center.longitude = [longitude doubleValue];
        MKCoordinateSpan span;
        span.latitudeDelta  = kLatitudeDelta;
        span.longitudeDelta = kLongitudeDelta;
        region.span = span;
        [self.map setRegion:region animated:YES];
    }
    
    else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorized)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.distanceFilter = 50;
        [locationManager startUpdatingLocation];
        
    }
    else{
        self.centerOnLocationButton.enabled=NO;
        [self goToSelectedCity];
    }
    
    MKUserTrackingBarButtonItem *button = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.map];
    [self.navigationController.toolbar setItems:@[button]];
    
    [self.segmentedControl setTitle:NSLocalizedString(kUI_Standard,  nil) forSegmentAtIndex:kMapTypeStandardIndex];
    [self.segmentedControl setTitle:NSLocalizedString(kUI_Satellite, nil) forSegmentAtIndex:kMapTypeSatelliteIndex];
}


- (void)zoomToLocation:(CLLocation *)location
{
    MKCoordinateRegion region;
    region.center.latitude  = location.coordinate.latitude;
    region.center.longitude = location.coordinate.longitude;
    MKCoordinateSpan span;
    span.latitudeDelta  = kLatitudeDelta;
    span.longitudeDelta = kLongitudeDelta;
    region.span = span;
    [self.map setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        [self zoomToLocation:location];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self goToSelectedCity];
}

- (void)goToSelectedCity{
    geocoder = [[CLGeocoder alloc] init];
    Open311 *open311= [Open311 sharedInstance];
    [geocoder geocodeAddressString:[NSString stringWithFormat:@"%@, Puerto Rico",open311.selectedCity] completionHandler:^(NSArray *placemarks, NSError *error) {
    CLPlacemark *placemark = [placemarks objectAtIndex:0];
    MKCoordinateRegion region;
    region.center.latitude = placemark.region.center.latitude;
    region.center.longitude= placemark.region.center.longitude;
    MKCoordinateSpan span;
    span.latitudeDelta  = kLatitudeDelta;
    span.longitudeDelta = kLatitudeDelta;
    region.span = span;
    [self.map setRegion:region animated:YES];
    }];
}


- (IBAction)done:(id)sender
{
    [self.delegate didChooseLocation:[self.map centerCoordinate]];
}

- (IBAction)centerOnLocation:(id)sender
{
    if(locationManager.location !=nil){
        [self zoomToLocation:locationManager.location];
    }
    else{
        [self goToSelectedCity];
    }
}

- (IBAction)mapTypeChanged:(id)sender
{
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case kMapTypeStandardIndex:
            [self.map setMapType:MKMapTypeStandard];
            break;
            
        case kMapTypeSatelliteIndex:
            [self.map setMapType:MKMapTypeSatellite];
            break;
    }
}
- (void)viewDidUnload {
    [self setSegmentedControl:nil];
    [super viewDidUnload];
}
@end

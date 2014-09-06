//
//  PSLocationManager.h
//  Ski Greece
//
//  Created by VimaTeamGr on 8/10/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class PSLocationManager;

typedef enum {
    PSLocationManagerGPSSignalStrengthInvalid = 0
    , PSLocationManagerGPSSignalStrengthWeak
    , PSLocationManagerGPSSignalStrengthStrong
} PSLocationManagerGPSSignalStrength;

@protocol PSLocationManagerDelegate <NSObject>

@optional
- (void)locationManager:(PSLocationManager *)locationManager signalStrengthChanged:(PSLocationManagerGPSSignalStrength)signalStrength;
- (void)locationManagerSignalConsistentlyWeak:(PSLocationManager *)locationManager;
- (void)locationManager:(PSLocationManager *)locationManager distanceUpdated:(CLLocationDistance)distance;
- (void)locationManager:(PSLocationManager *)locationManager waypoint:(CLLocation *)waypoint calculatedSpeed:(double)calculatedSpeed;
- (void)locationManager:(PSLocationManager *)locationManager error:(NSError *)error;
- (void)locationManager:(PSLocationManager *)locationManager debugText:(NSString *)text;
- (void)locationManager:(PSLocationManager *)locationManager setSpeedText:(double) speed;
- (void)locationManager:(PSLocationManager *)locationManager trackDone:(int) track;
- (void)locationManager:(PSLocationManager *)locationManager alertMessage:(NSString*)message;

@end

@interface PSLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) id<PSLocationManagerDelegate> delegate;
@property (nonatomic, readonly) PSLocationManagerGPSSignalStrength signalStrength;
@property (nonatomic, readonly) CLLocationDistance totalDistance;
@property (nonatomic, readonly) NSTimeInterval totalSeconds;
@property (nonatomic, readonly) double currentSpeed;
@property (nonatomic,copy) NSMutableArray *nextRegionsArray;

+ (PSLocationManager *)sharedLocationManager;

- (BOOL)prepLocationUpdates; // this must be called before startLocationUpdates (best to call it early so we can get an early lock on location)
- (BOOL)startLocationUpdates;
- (void)stopLocationUpdates;
- (void)resetLocationUpdates;
- (NSArray*) buildGeofenceData;
- (void) initializeRegionMonitoring:(NSArray*)geofences;
-(void) stopMonitoringForRegions;
-(void) currentMonitoringRegions;
-(void) addCustomRoutesForTracking; // this should be called when I want my custom tracking to work

@end

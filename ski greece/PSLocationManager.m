//
//  PSLocationManager.m
//  Ski Greece
//
//  Created by VimaTeamGr on 8/10/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

//
//  LocationManager.m
//  Faster
//
//  Created by Daniel Isenhower on 1/6/12.
//  daniel@perspecdev.com
//  Copyright (c) 2012 PerspecDev Solutions LLC. All rights reserved.
//
//  For more details, check out the blog post about this here:
//  http://perspecdev.com/blog/2012/02/22/using-corelocation-on-ios-to-track-a-users-distance-and-speed/
//
//  Want to use this code in your app?  Feel free!  I would love it if you would send me a quick email
//  about your project.
//
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge, publish, distribute,
//  sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
//  NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

static const NSUInteger kDistanceFilter = 5; // the minimum distance (meters) for which we want to receive location updates (see docs for CLLocationManager.distanceFilter)
static const NSUInteger kHeadingFilter = 30; // the minimum angular change (degrees) for which we want to receive heading updates (see docs for CLLocationManager.headingFilter)
static const NSUInteger kDistanceAndSpeedCalculationInterval = 3; // the interval (seconds) at which we calculate the user's distance and speed
static const NSUInteger kMinimumLocationUpdateInterval = 5; // the interval (seconds) at which we ping for a new location if we haven't received one yet
static const NSUInteger kNumLocationHistoriesToKeep = 4; // the number of locations to store in history so that we can look back at them and determine which is most accurate
static const NSUInteger kValidLocationHistoryDeltaInterval = 5; // the maximum valid age in seconds of a location stored in the location history
static const NSUInteger kNumSpeedHistoriesToAverage = 3; // the number of speeds to store in history so that we can average them to get the current speed
static const NSUInteger kPrioritizeFasterSpeeds = 1; // if > 0, the currentSpeed and complete speed history will automatically be set to to the new speed if the new speed is faster than the averaged speed
static const NSUInteger kMinLocationsNeededToUpdateDistanceAndSpeed = 3; // the number of locations needed in history before we will even update the current distance and speed
static const CGFloat kRequiredHorizontalAccuracy = 20.0; // the required accuracy in meters for a location.  if we receive anything above this number, the delegate will be informed that the signal is weak
static const CGFloat kMaximumAcceptableHorizontalAccuracy = 70.0; // the maximum acceptable accuracy in meters for a location.  anything above this number will be completely ignored
static const NSUInteger kGPSRefinementInterval = 15; // the number of seconds at which we will attempt to achieve kRequiredHorizontalAccuracy before giving up and accepting kMaximumAcceptableHorizontalAccuracy

static const CGFloat kSpeedNotSet = -1.0;

#import "PSLocationManager.h"

#import <Parse/Parse.h>


@interface PSLocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSTimer *locationPingTimer;
@property (nonatomic) PSLocationManagerGPSSignalStrength signalStrength;
@property (nonatomic, strong) CLLocation *lastRecordedLocation;
@property (nonatomic) CLLocationDistance totalDistance;
@property (nonatomic, strong) NSMutableArray *locationHistory;
@property (nonatomic, strong) NSDate *startTimestamp;
@property (nonatomic) double currentSpeed;
@property (nonatomic, strong) NSMutableArray *speedHistory;
@property (nonatomic) NSUInteger lastDistanceAndSpeedCalculation;
@property (nonatomic) BOOL forceDistanceAndSpeedCalculation;
@property (nonatomic) NSTimeInterval pauseDelta;
@property (nonatomic) NSTimeInterval pauseDeltaStart;
@property (nonatomic) BOOL readyToExposeDistanceAndSpeed;
@property (nonatomic) BOOL checkingSignalStrength;
@property (nonatomic) BOOL allowMaximumAcceptableAccuracy;

- (void)checkSustainedSignalStrength;
- (void)requestNewLocation;

@end


@implementation PSLocationManager


@synthesize delegate=_delegate;

@synthesize locationManager = _locationManager;
@synthesize locationPingTimer = _locationPingTimer;
@synthesize signalStrength = _signalStrength;
@synthesize lastRecordedLocation = _lastRecordedLocation;
@synthesize totalDistance = _totalDistance;
@synthesize locationHistory = _locationHistory;
@synthesize totalSeconds = _totalSeconds;
@synthesize startTimestamp = _startTimestamp;
@synthesize currentSpeed = _currentSpeed;
@synthesize speedHistory = _speedHistory;
@synthesize lastDistanceAndSpeedCalculation = _lastDistanceAndSpeedCalculation;
@synthesize forceDistanceAndSpeedCalculation = _forceDistanceAndSpeedCalculation;
@synthesize pauseDelta = _pauseDelta;
@synthesize pauseDeltaStart = _pauseDeltaStart;
@synthesize readyToExposeDistanceAndSpeed = _readyToExposeDistanceAndSpeed;
@synthesize allowMaximumAcceptableAccuracy = _allowMaximumAcceptableAccuracy;
@synthesize checkingSignalStrength = _checkingSignalStrength;

@synthesize nextRegionsArray=_nextRegionsArray;

NSArray *_regionArray;
NSArray *_geofences_starting_regions;
NSArray *_geofences_ending_regions;
NSArray *_hasMidPoints;
int currentState=0;
int _positionOfRoute=-1;
int _positionOfMidPoint=-1;
CLRegion *_nextRegion;

int _midRegionArray[6] = { 0,0,0,0,1,0 };
NSMutableArray *_midPointsArray;


+ (id)sharedLocationManager {
    static dispatch_once_t pred;
    static PSLocationManager *locationManagerSingleton = nil;
    
    dispatch_once(&pred, ^{
        locationManagerSingleton = [[self alloc] init];
    });
    return locationManagerSingleton;
}

- (id)init {
    NSLog(@"Location Manager is initiliated");
    if ((self = [super init])) {
        if ([CLLocationManager locationServicesEnabled]) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = kDistanceFilter;
            self.locationManager.headingFilter = kHeadingFilter;
            
            _nextRegionsArray=[NSMutableArray array];
            _midPointsArray=[NSMutableArray array];

        }
        
        self.locationHistory = [NSMutableArray arrayWithCapacity:kNumLocationHistoriesToKeep];
        self.speedHistory = [NSMutableArray arrayWithCapacity:kNumSpeedHistoriesToAverage];
        [self resetLocationUpdates];
        
        
    }
    
    return self;
}

-(void) addCustomRoutesForTracking
{
    _geofences_starting_regions = [self buildGeofenceStartingRoutesData];
    _geofences_ending_regions=[self buildGeofenceEndingRoutesData];
}

- (void)dealloc {
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
    self.locationManager.delegate = nil;
    
    
}

- (void)setSignalStrength:(PSLocationManagerGPSSignalStrength)signalStrength {
    BOOL needToUpdateDelegate = NO;
    if (_signalStrength != signalStrength) {
        needToUpdateDelegate = YES;
    }
    
    _signalStrength = signalStrength;
    
    if (self.signalStrength == PSLocationManagerGPSSignalStrengthStrong) {
        self.allowMaximumAcceptableAccuracy = NO;
    } else if (self.signalStrength == PSLocationManagerGPSSignalStrengthWeak) {
        [self checkSustainedSignalStrength];
    }
    
    if (needToUpdateDelegate) {
        if ([self.delegate respondsToSelector:@selector(locationManager:signalStrengthChanged:)]) {
            [self.delegate locationManager:self signalStrengthChanged:self.signalStrength];
        }
    }
}

- (void)setTotalDistance:(CLLocationDistance)totalDistance {
    _totalDistance = totalDistance;
    
    if (self.currentSpeed != kSpeedNotSet) {
        if ([self.delegate respondsToSelector:@selector(locationManager:distanceUpdated:)]) {
            [self.delegate locationManager:self distanceUpdated:self.totalDistance];
        }
    }
}

- (NSTimeInterval)totalSeconds {
    return ([self.startTimestamp timeIntervalSinceNow] * -1) - self.pauseDelta;
}

- (void)checkSustainedSignalStrength {
    if (!self.checkingSignalStrength) {
        self.checkingSignalStrength = YES;
        
        double delayInSeconds = kGPSRefinementInterval;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.checkingSignalStrength = NO;
            if (self.signalStrength == PSLocationManagerGPSSignalStrengthWeak) {
                self.allowMaximumAcceptableAccuracy = YES;
                if ([self.delegate respondsToSelector:@selector(locationManagerSignalConsistentlyWeak:)]) {
                    [self.delegate locationManagerSignalConsistentlyWeak:self];
                }
            } else if (self.signalStrength == PSLocationManagerGPSSignalStrengthInvalid) {
                self.allowMaximumAcceptableAccuracy = YES;
                self.signalStrength = PSLocationManagerGPSSignalStrengthWeak;
                if ([self.delegate respondsToSelector:@selector(locationManagerSignalConsistentlyWeak:)]) {
                    [self.delegate locationManagerSignalConsistentlyWeak:self];
                }
            }
        });
    }
}

- (void)requestNewLocation {
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
}

- (BOOL)prepLocationUpdates {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationHistory removeAllObjects];
        [self.speedHistory removeAllObjects];
        self.lastDistanceAndSpeedCalculation = 0;
        self.currentSpeed = kSpeedNotSet;
        self.readyToExposeDistanceAndSpeed = NO;
        self.signalStrength = PSLocationManagerGPSSignalStrengthInvalid;
        self.allowMaximumAcceptableAccuracy = NO;
        
        self.forceDistanceAndSpeedCalculation = YES;
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
        
        [self checkSustainedSignalStrength];
        
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)startLocationUpdates {
    if ([CLLocationManager locationServicesEnabled]) {
        self.readyToExposeDistanceAndSpeed = YES;
        
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
        
        if (self.pauseDeltaStart > 0) {
            self.pauseDelta += ([NSDate timeIntervalSinceReferenceDate] - self.pauseDeltaStart);
            self.pauseDeltaStart = 0;
        }
        
        return YES;
    } else {
        return NO;
    }
}

- (void)stopLocationUpdates {
    [self.locationPingTimer invalidate];
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
    self.pauseDeltaStart = [NSDate timeIntervalSinceReferenceDate];
    self.lastRecordedLocation = nil;
}

- (void)resetLocationUpdates {
    self.totalDistance = 0;
    self.startTimestamp = [NSDate dateWithTimeIntervalSinceNow:0];
    self.forceDistanceAndSpeedCalculation = NO;
    self.pauseDelta = 0;
    self.pauseDeltaStart = 0;
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // since the oldLocation might be from some previous use of core location, we need to make sure we're getting data from this run
    if (oldLocation == nil) {
        NSLog(@"OldLocation is nil. Returning. newLocation has lat:%f",newLocation.coordinate.latitude);
        return;
    }
    
    //NSLog(@"Location Update. Lat: %f Long:%f Horizontal accuracy:%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude,newLocation.horizontalAccuracy);
    BOOL isStaleLocation = ([oldLocation.timestamp compare:self.startTimestamp] == NSOrderedAscending);
    
    /*if([self.delegate conformsToProtocol:@protocol(PSLocationManagerDelegate)]) {
		[self.delegate locationManager:self locationUpdate:newLocation];
	}*/
    
    [self.locationPingTimer invalidate];
    
    if (newLocation.horizontalAccuracy <= kRequiredHorizontalAccuracy) {
        self.signalStrength = PSLocationManagerGPSSignalStrengthStrong;
    } else {
        self.signalStrength = PSLocationManagerGPSSignalStrengthWeak;
    }
    
    double horizontalAccuracy;
    if (self.allowMaximumAcceptableAccuracy) {
        horizontalAccuracy = kMaximumAcceptableHorizontalAccuracy;
    } else {
        horizontalAccuracy = kRequiredHorizontalAccuracy;
    }
    //NSLog(@"Variable Horizontal Accuracy:%f",horizontalAccuracy);
    if (!isStaleLocation && newLocation.horizontalAccuracy >= 0 && newLocation.horizontalAccuracy <= horizontalAccuracy) {
        NSLog(@"Enter main if loop");
        [self.locationHistory addObject:newLocation];
        if ([self.locationHistory count] > kNumLocationHistoriesToKeep) {
            [self.locationHistory removeObjectAtIndex:0];
        }
        
        BOOL canUpdateDistanceAndSpeed = NO;
        if ([self.locationHistory count] >= kMinLocationsNeededToUpdateDistanceAndSpeed) {
            canUpdateDistanceAndSpeed = YES && self.readyToExposeDistanceAndSpeed;
        }
        
        if (self.forceDistanceAndSpeedCalculation || [NSDate timeIntervalSinceReferenceDate] - self.lastDistanceAndSpeedCalculation > kDistanceAndSpeedCalculationInterval) {
            self.forceDistanceAndSpeedCalculation = NO;
            self.lastDistanceAndSpeedCalculation = [NSDate timeIntervalSinceReferenceDate];
            
            CLLocation *lastLocation = (self.lastRecordedLocation != nil) ? self.lastRecordedLocation : oldLocation;
            
            CLLocation *bestLocation = nil;
            CGFloat bestAccuracy = kRequiredHorizontalAccuracy;
            for (CLLocation *location in self.locationHistory) {
                if ([NSDate timeIntervalSinceReferenceDate] - [location.timestamp timeIntervalSinceReferenceDate] <= kValidLocationHistoryDeltaInterval) {
                    if (location.horizontalAccuracy < bestAccuracy && location != lastLocation) {
                        bestAccuracy = location.horizontalAccuracy;
                        bestLocation = location;
                    }
                }
            }
            if (bestLocation == nil) bestLocation = newLocation;
            
            CLLocationDistance distance = [bestLocation distanceFromLocation:lastLocation];
            if (canUpdateDistanceAndSpeed) self.totalDistance += distance;
            self.lastRecordedLocation = bestLocation;
            
            NSTimeInterval timeSinceLastLocation = [bestLocation.timestamp timeIntervalSinceDate:lastLocation.timestamp];
            if (timeSinceLastLocation > 0) {
                CGFloat speed = distance / timeSinceLastLocation;
                if (speed <= 0 && [self.speedHistory count] == 0) {
                    // don't add a speed of 0 as the first item, since it just means we're not moving yet
                } else {
                    [self.speedHistory addObject:[NSNumber numberWithDouble:speed]];
                }
                if ([self.speedHistory count] > kNumSpeedHistoriesToAverage) {
                    [self.speedHistory removeObjectAtIndex:0];
                }
                if ([self.speedHistory count] > 1) {
                    double totalSpeed = 0;
                    for (NSNumber *speedNumber in self.speedHistory) {
                        totalSpeed += [speedNumber doubleValue];
                    }
                    if (canUpdateDistanceAndSpeed) {
                        double newSpeed = totalSpeed / (double)[self.speedHistory count];
                        if (kPrioritizeFasterSpeeds > 0 && speed > newSpeed) {
                            newSpeed = speed;
                            [self.speedHistory removeAllObjects];
                            for (int i=0; i<kNumSpeedHistoriesToAverage; i++) {
                                [self.speedHistory addObject:[NSNumber numberWithDouble:newSpeed]];
                            }
                        }
                        self.currentSpeed = newSpeed;
                        /*add by VimaTeam*/
                        [self.delegate locationManager:self setSpeedText:self.currentSpeed];
                        /*end of addition*/
                        
                        
                    }
                }
            }
            
            //NSLog(@"Will update location and will check for region");
            
            if ([self.delegate respondsToSelector:@selector(locationManager:waypoint:calculatedSpeed:)]) {
                [self.delegate locationManager:self waypoint:self.lastRecordedLocation calculatedSpeed:self.currentSpeed];                
            }
            
            // WHEN SEARCHING FOR CUSTOM LOCATIONS THIS SHOULD BE UNCOMMENTED OUT
            //[self stateMachineForRegion:currentState];
            
        }
    }
    
    // this will be invalidated above if a new location is received before it fires
    self.locationPingTimer = [NSTimer timerWithTimeInterval:kMinimumLocationUpdateInterval target:self selector:@selector(requestNewLocation) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.locationPingTimer forMode:NSRunLoopCommonModes];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    // we don't really care about the new heading.  all we care about is calculating the current distance from the previous distance early if the user changed directions
    self.forceDistanceAndSpeedCalculation = YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        if ([self.delegate respondsToSelector:@selector(locationManager:error:)]) {
            [self.delegate locationManager:self error:error];
        }
        [self stopLocationUpdates];
    }
}

/*added Code for geofence*/
- (void) initializeRegionMonitoring:(NSArray*)geofences {
    
    
    if (_locationManager == nil) {
        [NSException raise:@"Location Manager Not Initialized" format:@"You must initialize location manager first."];
    }
    
    if(![CLLocationManager regionMonitoringAvailable]) {
        [self showAlertWithMessage:@"This app requires region monitoring features which are unavailable on this device."];
        return;
    }
    
    for(CLRegion *geofence in geofences) {
        [_locationManager startMonitoringForRegion:geofence];
    }
    
}

- (NSArray*) buildGeofenceData {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"regions" ofType:@"plist"];
    _regionArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSMutableArray *geofences = [NSMutableArray array];
    for(NSDictionary *regionDict in _regionArray) {
        CLRegion *region = [self mapDictionaryToRegion:regionDict];
        [geofences addObject:region];
    }
    
    NSLog(@"Will return array with number of regions:%d",[geofences count]);
    
    return [NSArray arrayWithArray:geofences];
}

-(void) stopMonitoringForRegions
{
    NSLog(@"Stop monitoring the %@ regions",[_locationManager monitoredRegions]);
    for (CLRegion *monitored in [_locationManager monitoredRegions])
        [_locationManager stopMonitoringForRegion:monitored];
}

-(void) currentMonitoringRegions
{
    NSLog(@"Current monitoring regions : %@",[_locationManager monitoredRegions]);
}

#pragma mark - Location Manager - Region Task Methods

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Entered Region - %@", region.identifier);
    //[self showRegionAlert:@"Entering Region" forRegion:region.identifier];
    
    // remove existing channels - there should not be any but just to be sure
    NSArray *subscribedChannels = [PFInstallation currentInstallation].channels;
    
    NSLog(@"Current channels: %@",subscribedChannels);
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    for (int i=0; i < [subscribedChannels count]; i++) {
        
        if ([subscribedChannels[i] rangeOfString:@"LocTarget"].location == NSNotFound) {
            
        } else {
            [currentInstallation removeObject:subscribedChannels[i] forKey:@"channels"];
            [currentInstallation saveInBackground];
        }
    }
    
    
    // subscribe to new channels
    NSLog(@"We should now subscribe to the channel :%@",[NSString stringWithFormat:@"%@LocTarget",region.identifier]);
    [currentInstallation addUniqueObject:[NSString stringWithFormat:@"%@LocTarget",region.identifier] forKey:@"channels"];
    
    [currentInstallation saveInBackground];
    
    // PFobject change current place to the value
    
    PFInstallation *installation = [PFInstallation currentInstallation];
    installation[@"currentPlace"]=[NSString stringWithFormat:@"%@LocTarget",region.identifier];
    [installation saveInBackground];
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Exited Region - %@", region.identifier);
    //[self showRegionAlert:@"Exiting Region" forRegion:region.identifier];
    
    // unsubsribe from the channel I am entering out - check to be sure that channel exists
    
    NSArray *subscribedChannels = [PFInstallation currentInstallation].channels;
    
    NSLog(@"Current channels: %@",subscribedChannels);
    NSLog(@"I will search for : %@", [NSString stringWithFormat:@"%@LocTarget",region.identifier]);
    
    BOOL removeCurrentChannel = [subscribedChannels containsObject: [NSString stringWithFormat:@"%@LocTarget",region.identifier]];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    if (removeCurrentChannel) {
        [currentInstallation removeObject:[NSString stringWithFormat:@"%@LocTarget",region.identifier] forKey:@"channels"];
    }
    
    [currentInstallation saveInBackground];
    
    
    // PFObject change current place to Unknown
    
    PFInstallation *installation = [PFInstallation currentInstallation];
    installation[@"currentPlace"]=@"Unknown";
    [installation saveEventually];

}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Started monitoring %@ region", region.identifier);

    if ([region containsCoordinate:manager.location.coordinate])
        [self locationManager: manager
               didEnterRegion: region];
}

#pragma  mark - Flags for my custom tracking

- (NSArray*) buildGeofenceStartingRoutesData {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"KalavrytaStartingRoutes" ofType:@"plist"];
    NSArray *_regiontempArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSMutableArray *geofences = [NSMutableArray array];
    for(NSDictionary *regionDict in _regiontempArray) {
        CLRegion *region = [self mapDictionaryToRegion:regionDict];
        NSLog(@"Added starting region with title:%@",region.identifier);
        [geofences addObject:region];
    }
    
    NSLog(@"Will return starting routes array with number of regions:%d",[geofences count]);
    
    return [NSArray arrayWithArray:geofences];
}

- (NSArray*) buildGeofenceEndingRoutesData {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"KalavrytaEndRoutes" ofType:@"plist"];
    NSArray *_regiontempArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSMutableArray *geofences = [NSMutableArray array];
    for(NSDictionary *regionDict in _regiontempArray) {
        CLRegion *region = [self mapDictionaryToRegion:regionDict];
        NSLog(@"Added ending region with title:%@",region.identifier);
        [geofences addObject:region];
    }
    
    NSLog(@"Will return ending routes array with number of regions:%d",[geofences count]);
    
    return [NSArray arrayWithArray:geofences];
}

- (NSMutableArray*) buildMidRoutesData : (int)number {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"KalavrytaMid%d",number] ofType:@"plist"];
    NSArray *_regiontempArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSMutableArray *geofences = [NSMutableArray array];
    for(NSDictionary *regionDict in _regiontempArray) {
        CLRegion *region = [self mapDictionaryToRegion:regionDict];
        NSLog(@"Added ending region with title:%@",region.identifier);
        [geofences addObject:region];
    }
    
    NSLog(@"Will return ending routes array with number of regions:%d",[geofences count]);
    
    return geofences;
}

- (CLRegion*)mapDictionaryToRegion:(NSDictionary*)dictionary {
    NSString *title = [dictionary valueForKey:@"title"];
    
    CLLocationDegrees latitude = [[dictionary valueForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude =[[dictionary valueForKey:@"longitude"] doubleValue];
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    CLLocationDistance regionRadius = [[dictionary valueForKey:@"radius"] doubleValue];
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    CLRegion * region =nil;
    
    if([version floatValue] >= 7.0f) //for iOS7
    {
        region =  [[CLCircularRegion alloc] initWithCenter:centerCoordinate
                                                    radius:regionRadius
                                                identifier:title];
    }
    else // iOS 7 below
    {
        region = [[CLRegion alloc] initCircularRegionWithCenter:centerCoordinate
                                                         radius:regionRadius
                                                     identifier:title];
    }
    return  region;
    
    
  
}

# pragma mark - custom state machine for  custom tracking

-(void) stateMachineForRegion:(int)state
{
    NSLog(@"Current state is: %d",state);
    CLLocationCoordinate2D coordinate = [self.lastRecordedLocation coordinate];

    switch (state) {
        case 0:
            NSLog(@"Searching for a starting region");
            
            /*check for region*/
             for (int i=0; i<[_geofences_starting_regions count]; i++) {
             
                 NSLog(@"%d: Checking between region %@ with center (%f,%f) and coordinate (%f,%f)",i,((CLRegion*) _geofences_starting_regions[i]).identifier,((CLRegion*)_geofences_starting_regions[i]).center.latitude,((CLRegion*)_geofences_starting_regions[i]).center.longitude,coordinate.latitude,coordinate.longitude);
             
                 if ([_geofences_starting_regions[i] containsCoordinate:coordinate]) {
                     NSLog(@"Found starting region %@ at position %d.",((CLRegion*)_geofences_starting_regions[i]).identifier,i);
                     
                     _positionOfRoute=i;
                     
                     [self.delegate locationManager:self alertMessage:[NSString stringWithFormat:@"Found Start:%@",((CLRegion*)_geofences_starting_regions[_positionOfRoute]).identifier]];
                     
                     
                     if (_midRegionArray[_positionOfRoute]==1){
                         //code for midPoint
                         currentState=currentState+1;
                     } else {
                         NSLog(@"Region does not have midPoints. Region will be the ending ones");
                         
                         //_nextRegionsArray=[NSMutableArray array];
                         
                         NSLog(@"Will add end route region %@ with center (%f,%f)",((CLRegion*) _geofences_ending_regions[_positionOfRoute]).identifier,((CLRegion*)_geofences_ending_regions[_positionOfRoute]).center.latitude,((CLRegion*)_geofences_ending_regions[_positionOfRoute]).center.longitude);
                         
                         [_nextRegionsArray addObject:_geofences_ending_regions[_positionOfRoute]];
                         
                         //add manual if any track has more than one ending points !!!!
                         
                         NSLog(@"Next Regions array has %d options",[_nextRegionsArray count]);
                                                  
                         currentState=currentState+2;
                     }
                     
                     break;
                     //[self.delegate locationManager:self regionEntered:_geofences_regions[i]];
                 }
             }
            /*end checking for region*/
            NSLog(@"--------------------------------------------");
            break;
            
        case 1:
            
            //code for midPoints
            if (_positionOfRoute==4) {
                _midPointsArray=[self buildMidRoutesData:_positionOfRoute];
            }
            NSLog(@"Having to search for %d mid points",[_midPointsArray count]);
            for (int i=0; i<[_midPointsArray count]; i++) {
                _positionOfMidPoint=i;
                NSLog(@"%d: Checking between region %@ with center (%f,%f) and coordinate (%f,%f)",i,((CLRegion*) _midPointsArray[i]).identifier,((CLRegion*)_midPointsArray[i]).center.latitude,((CLRegion*)_midPointsArray[i]).center.longitude,coordinate.latitude,coordinate.longitude);
                
                if ([_midPointsArray[i] containsCoordinate:coordinate]) {
                    NSLog(@"Found midPoint at position %d",i);
                    
                    [self.delegate locationManager:self alertMessage:[NSString stringWithFormat:@"Found Mid:%@",((CLRegion*)_midPointsArray[_positionOfMidPoint]).identifier]];
                    
                    NSLog(@"Will add end route region %@ with center (%f,%f)",((CLRegion*) _geofences_ending_regions[_positionOfRoute]).identifier,((CLRegion*)_geofences_ending_regions[_positionOfRoute]).center.latitude,((CLRegion*)_geofences_ending_regions[_positionOfRoute]).center.longitude);
                    
                    [_nextRegionsArray addObject:_geofences_ending_regions[_positionOfRoute]];
                    
                    //add manual if any track has more than one ending points !!!!
                    
                    NSLog(@"Ending Regions array has %d options",[_nextRegionsArray count]);
                    
                    
                    
                    currentState=currentState+1;
                    
                    break;
                }
            
            }
            NSLog(@"--------------------------------------------");
            break;
            
        case 2:
            NSLog(@"Start looking for endPoints");
            
            for (int i=0; i<[_nextRegionsArray count]; i++) {
                
                NSLog(@"%d: Checking between region %@ with center (%f,%f) and coordinate (%f,%f)",i,((CLRegion*) _nextRegionsArray[i]).identifier,((CLRegion*)_nextRegionsArray[i]).center.latitude,((CLRegion*)_nextRegionsArray[i]).center.longitude,coordinate.latitude,coordinate.longitude);
                
                  if ([_nextRegionsArray[i] containsCoordinate:coordinate]) {
                      int routeCode=-1;
                      NSLog(@"End of track identified - Send to delegate a code for what track has been identified");
                      
                      if(_positionOfRoute==0 && i==0) {
                          routeCode=0;
                      } else if (_positionOfRoute==1 && i==0){
                          routeCode=10; //this means the 1st starting route with its first end route is selected and so on.
                      } else if(_positionOfRoute==2 && i==0) {
                          routeCode=20;
                      } else if (_positionOfRoute==3 && i==0){
                          routeCode=30;
                      } else if (_positionOfRoute==4 && _positionOfMidPoint==0) {
                          routeCode=40;
                      } else if (_positionOfRoute==4 && _positionOfMidPoint==1) {
                          routeCode=41;
                      } else if (_positionOfRoute==5 && i==0) {
                          routeCode=50;
                      }
                      
                      NSLog(@"I will call the delegate method for letting know that a track has been made");
                      //remove items fromm nsmutable array
                      [self.delegate locationManager:self trackDone:routeCode];
                      
                      NSLog(@"Clearing array from all data");
                      [_nextRegionsArray removeAllObjects];
                      
                      currentState=currentState+1; // then go over the beginning afou ola exoun ginei reset
                  }
                
                
            }
            break;
            
        case 3:
            //default trap in here
            NSLog(@"Custom trap in here");
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Alert Methods

- (void) showRegionAlert:(NSString *)alertText forRegion:(NSString *)regionIdentifier {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:alertText
                                                      message:regionIdentifier
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (void)showAlertWithMessage:(NSString*)alertText {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Services Error"
                                                        message:alertText
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end

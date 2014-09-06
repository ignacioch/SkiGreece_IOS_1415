//
//  TrackDayViewController.m
//  Ski Greece
//
//  Created by VimaTeamGr on 8/9/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "TrackDayViewController.h"
#import "VTSkiCenterMapViewController.h"


@interface TrackDayViewController ()

@end

@implementation TrackDayViewController
{
    BOOL _trackingHasStarted;
    BOOL animating;
    int help_variable;
    NSTimeInterval startTime;
    NSMutableArray *_trackCrossed;
    NSMutableArray *_routesCompleted;
    CLLocationCoordinate2D lastLocation;
    double maxAltitude;
    double minAltitude;
    double currentDistance;
    BOOL firstLocation;
    
    NSTimeInterval currentTime;
    NSTimeInterval timeFromPause;
    NSTimeInterval elapsedTime;
    NSTimeInterval elapsedTime_temp;
    BOOL trackPaused;
    
    NSMutableArray *_pointsForPolyline;
    
    BOOL isRunning;
    float finalDistance;
    
    BOOL seenAd;
}

@synthesize speedLabel=_speedLabel;
@synthesize maxSpeedLabel=_maxSpeedLabel;
@synthesize minSpeedLabel=_minSpeedLabel;
@synthesize avgSpeedLabel=_avgSpeedLabel;
@synthesize latitudeLabel=_latitudeLabel;
@synthesize longitudeLabel=_longitudeLabel;
@synthesize durationLabel=_durationLabel;
@synthesize altitudeLabel=_altitudeLabel;
@synthesize maxAltitudeLabel=_maxAltitudeLabel;
@synthesize minAltitudelabel=_minAltitudelabel;
@synthesize maximumSpeed=_maximumSpeed;
@synthesize averageSpeed=_averageSpeed;

@synthesize totalDistanceCovered=_totalDistanceCovered;

@synthesize CLController;

@synthesize signal_one=_signal_one;
@synthesize signal_two=_signal_two;
@synthesize signal_three=_signal_three;
@synthesize imageToMove=_imageToMove;
@synthesize startButton=_startButton;
@synthesize pauseButton=_pauseButton;
@synthesize resetButton=_resetButton;
@synthesize gotoMapBtn=_gotoMapBtn;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _trackingHasStarted=NO;
    
    self.maximumSpeed=0;
    
    trackPaused = NO;
    
    finalDistance = 0;
    
    [PSLocationManager sharedLocationManager].delegate = self;
    
    /*init trackHasCrossed based on the Sk Center I am   */
    //[self initTrackHasCrossed:2];
    /*count should differ according to the Ski Center*/
    
    _routesCompleted=[NSMutableArray array];
    
    _pointsForPolyline = [NSMutableArray array];
    
    self.durationLabel.text=@"0:00.0";
    
    isRunning = NO;
    
    timeFromPause = 0.0f;
    
    [self.signalLabel setTextColor:[UIColor colorWithRed:(163/255.f) green:(163/255.f) blue:(163/255.f) alpha:1.0f]];
    
    [self.speedLabel setTextColor:[UIColor colorWithRed:(0/255.f) green:(160/255.f) blue:(203/255.f) alpha:1.0f]];
    [self.speedLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:16.0f]];
    
    [self.maxSpeedLabel setTextColor:[UIColor colorWithRed:(0/255.f) green:(160/255.f) blue:(203/255.f) alpha:1.0f]];
    [self.maxSpeedLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:16.0f]];
    
    [self.minSpeedLabel setTextColor:[UIColor colorWithRed:(0/255.f) green:(160/255.f) blue:(203/255.f) alpha:1.0f]];
    [self.minSpeedLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:16.0f]];
    
    [self.latitudeLabel setTextColor:[UIColor colorWithRed:(0/255.f) green:(160/255.f) blue:(203/255.f) alpha:1.0f]];
    [self.latitudeLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:16.0f]];
    
    [self.longitudeLabel setTextColor:[UIColor colorWithRed:(0/255.f) green:(160/255.f) blue:(203/255.f) alpha:1.0f]];
    [self.longitudeLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:16.0f]];
    
    [self.altitudeLabel setTextColor:[UIColor colorWithRed:(0/255.f) green:(160/255.f) blue:(203/255.f) alpha:1.0f]];
    [self.altitudeLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:16.0f]];
    
    [self.totalDistanceCovered setTextColor:[UIColor colorWithRed:(0/255.f) green:(160/255.f) blue:(203/255.f) alpha:1.0f]];
    [self.totalDistanceCovered setFont:[UIFont fontWithName:@"Myriad Pro" size:16.0f]];
    
    [self.maxAltitudeLabel setTextColor:[UIColor colorWithRed:(0/255.f) green:(160/255.f) blue:(203/255.f) alpha:1.0f]];
    [self.maxAltitudeLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:16.0f]];

    [self.minAltitudelabel setTextColor:[UIColor colorWithRed:(0/255.f) green:(160/255.f) blue:(203/255.f) alpha:1.0f]];
    [self.minAltitudelabel setFont:[UIFont fontWithName:@"Myriad Pro" size:16.0f]];

    
    
    animating = NO;
    
    self.pauseButton.hidden=YES;
    //self.resetButton.hidden=YES;
    
    maxAltitude = 0;
    firstLocation = NO;
    
    /*hide the gotoMap button*/
    self.gotoMapBtn.hidden=YES;
    self.gotoMapBtn.userInteractionEnabled = NO;
    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_with_back_5.png"]];
        
        self.backBtn.frame = CGRectMake(self.backBtn.frame.origin.x, self.backBtn.frame.origin.y + OFFSET_IOS_7 , self.backBtn.frame.size.width , self.backBtn.frame.size.height);
        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            if (subview.tag == 10) {                // 10 is the up stuff
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 , subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag == 20) {                // 20 is the middle
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 25.0f, subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag == 30) {                // 30 is the bottom
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + OFFSET_5, subview.frame.size.width, subview.frame.size.height );
            }
        }
        
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7, subview.frame.size.width, subview.frame.size.height);
        }
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        imgView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:imgView];
    }
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    [self.totalDisLabel sizeToFit];
    
    /*guide for location settings*/
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if(![defaults boolForKey:@"hasSeenLocGuides"]) {
        NSLog(@"User opens Track for first time");
        [defaults setBool:true forKey:@"hasSeenLocGuides"];
        [defaults synchronize];
    } else
    {
        NSLog(@"User is not Using that for first time");
        if([CLLocationManager locationServicesEnabled]){
            NSLog(@"Location Services Enabled");
        } else {
            [self seeGuidance];
        }
    }


}

-(void) seeGuidance
{
    NSLog(@"User should see tutorial");
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"hasSeenLocGuides"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.closeTutorial = [UIButton buttonWithType:UIButtonTypeCustom];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        self.Tutorial= [[UIImageView alloc] initWithFrame:CGRectMake(25, 20 + OFFSET_IOS_7, 290, 427)];
        self.closeTutorial.frame = CGRectMake(30, 20 + OFFSET_IOS_7, 285, 427);
    } else {
        self.Tutorial= [[UIImageView alloc] initWithFrame:CGRectMake(25, 20, 290, 427)];
        self.closeTutorial.frame = CGRectMake(30, 20, 285, 427);
    }
    
    
    self.Tutorial.image = [UIImage imageNamed:@"location_guider.png"];
    [self.view addSubview:self.Tutorial];
    
    [self.closeTutorial addTarget:self
               action:@selector(closeTut:)
     forControlEvents:UIControlEventTouchDown];
    [self.closeTutorial setTitle:@"" forState:UIControlStateNormal];
    [self.view addSubview:self.closeTutorial];
    
    seenAd = NO;

}

- (void)closeTut:(id)sender
{
    [self.closeTutorial removeFromSuperview];
    [self.Tutorial removeFromSuperview];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Do your resizing
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTrackHasCrossed:(int)count
{
     _trackCrossed= [[NSMutableArray alloc] initWithCapacity:count];
    for ( int i = 0 ; i <= count ; i ++ )
        [_trackCrossed addObject:[NSNumber numberWithInt:0]];
}


#pragma mark PSLocationManagerDelegate

- (void)locationManager:(PSLocationManager *)locationManager signalStrengthChanged:(PSLocationManagerGPSSignalStrength)signalStrength {
    //NSString *strengthText;
    if (signalStrength == PSLocationManagerGPSSignalStrengthWeak) {
        //strengthText = NSLocalizedString(@"Signal : Weak", @"");
        [self signalWeak];
    } else if (signalStrength == PSLocationManagerGPSSignalStrengthStrong) {
        //strengthText = NSLocalizedString(@"Signal : Strong", @"");
        [self signalStrong];
    } else {
        [self signalUnknown];
        //strengthText = NSLocalizedString(@"...", @"");
    }
    
    //self.signalLabel.text = strengthText;
}

- (void)locationManagerSignalConsistentlyWeak:(PSLocationManager *)locationManager {
    //self.strengthLabel.text = NSLocalizedString(@"Consistently Weak", @"");
}

- (void)locationManager:(PSLocationManager *)locationManager distanceUpdated:(CLLocationDistance)distance {
    NSString * distanceString;
    if (distance > 1000) {
        distanceString=[NSString stringWithFormat:@"%.1f %@", distance, NSLocalizedString(@"km", @"")];
    } else {
        distanceString=[NSString stringWithFormat:@"%.2f %@", distance, NSLocalizedString(@"m", @"")];
    }
    self.totalDistanceCovered.text= distanceString;
    finalDistance = distance;
    
    currentDistance=distance;
}

- (void)locationManager:(PSLocationManager *)locationManager error:(NSError *)error {
    // location services is probably not enabled for the app
    //self.strengthLabel.text = NSLocalizedString(@"Unable to determine location", @"");
}

- (void)locationManager:(PSLocationManager *)locationManager setSpeedText:(double) speed
{
    self.speedLabel.text=[NSString stringWithFormat:@"%.2f km/h", speed * 3.6];
    if (speed > _maximumSpeed){
        _maximumSpeed=speed;
        self.maxSpeedLabel.text=[NSString stringWithFormat:@"%.2f km/h",_maximumSpeed*3.6f];
    }
}

- (void)locationManager:(PSLocationManager *)locationManager waypoint:(CLLocation *)waypoint calculatedSpeed:(double)calculatedSpeed
{
    self.latitudeLabel.text = [self getLatDegreesFormat:waypoint.coordinate.latitude getType:0];
    self.longitudeLabel.text = [self getLatDegreesFormat:waypoint.coordinate.longitude getType:1];
	self.altitudeLabel.text = [NSString stringWithFormat:@"%.1f m", [waypoint altitude]];
    lastLocation=waypoint.coordinate;
    
    NSLog(@"added item on array");
    
    [_pointsForPolyline addObject:waypoint];
    
    if (!firstLocation) {
        firstLocation= YES;
        minAltitude= waypoint.altitude;
    }
    
    /*check for min,max altitude*/
    if (waypoint.altitude >= maxAltitude) {
        maxAltitude = waypoint.altitude;
        self.maxAltitudeLabel.text = [NSString stringWithFormat:@"%.1f m",maxAltitude];
    }
    if (waypoint.altitude <= minAltitude) {
        minAltitude = waypoint.altitude;
        self.minAltitudelabel.text = [NSString stringWithFormat:@"%.1f m",minAltitude];
    }
}

- (void)locationManager:(PSLocationManager *)locationManager trackDone:(int)track
{
    [self showAlert:[NSString stringWithFormat:@"Track Completed: %d",track]];
    [_routesCompleted addObject:[NSString stringWithFormat:@"%d",track]];
}


-(void)locationManager:(PSLocationManager *)locationManager alertMessage:(NSString *)message
{
    [self showAlert:message];
}


- (void)viewDidUnload {
    [self setStartScanningButton:nil];
    [self setSpeedLabel:nil];
    [self setMaxSpeedLabel:nil];
    [self setMinSpeedLabel:nil];
    [self setAvgSpeedLabel:nil];
    [self setLatitudeLabel:nil];
    [self setLongitudeLabel:nil];
    [self setAltitudeLabel:nil];
    [self setDurationLabel:nil];
    [self setTotalDistanceCovered:nil];
    [self setResetButton:nil];
    [super viewDidUnload];
}

-(void) signalWeak
{
    self.signal_one.hidden=NO;
    self.signal_two.hidden=NO;
    self.signal_three.hidden=YES;
}

-(void) signalStrong
{
    self.signal_one.hidden=NO;
    self.signal_two.hidden=NO;
    self.signal_three.hidden=NO;
}

-(void) signalUnknown
{
    self.signal_one.hidden=NO;
    self.signal_two.hidden=YES;
    self.signal_three.hidden=YES;
}


- (IBAction)startScanning:(id)sender
{

    if (_trackingHasStarted==NO) {
        _trackingHasStarted=YES;
        //[CLController.locMgr startUpdatingLocation];
        //self.startScanningButton.titleLabel.text=@"Stop Scanning";
        
        [[PSLocationManager sharedLocationManager] prepLocationUpdates];
        [[PSLocationManager sharedLocationManager] startLocationUpdates];
        
        
        startTime=[NSDate timeIntervalSinceReferenceDate];

        
        [sender setTitle:@"STOP" forState:UIControlStateNormal];
        [self updateTime];
        
        /*change image*/
        [self.imageToMove setImage:[UIImage imageNamed:@"track_main_orange_eclipse.png"]];
        [self.startButton setImage:[UIImage imageNamed:@"track_main_running_txt.png"] forState:UIControlStateNormal];

        /*start animation*/
        animating = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
        [self scaleButtonDown: UIViewAnimationOptionCurveEaseIn];
        /****************/
        
        self.pauseButton.hidden=NO;
        //self.resetButton.hidden=NO;
        
        trackPaused = NO;
        
        isRunning = YES;

        
    } else {
        NSLog(@"STOP WATCH AND LOCATION UPDATE");
        [sender setTitle:@"START" forState:UIControlStateNormal];
        //[CLController.locMgr stopUpdatingLocation];
        
        [[PSLocationManager sharedLocationManager] stopLocationUpdates];
        
        timeFromPause = 0.0f;
        
        [self.imageToMove setImage:[UIImage imageNamed:@"track_main_eclipse.png"]];
        [self.startButton setImage:[UIImage imageNamed:@"track_main_start_button_txt.png"] forState:UIControlStateNormal];

        
        _trackingHasStarted=NO;
        
        animating = NO;
        
        self.pauseButton.hidden=YES;
        //self.resetButton.hidden=YES;
        
        trackPaused = NO;
        
        isRunning = NO;

        
        /*when stop has been pressed, open the map directly*/
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        VTSkiCenterMapViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MapCovered"];
        NSLog(@"Routed added to property with number of items:%d",[_routesCompleted count]);
        vc.routesCovered=_routesCompleted;
        vc.centerLocation=lastLocation;
        vc.maxSpeed=self.maxSpeedLabel.text;
        vc.time=self.durationLabel.text;
        vc.distance=self.totalDistanceCovered.text;
        vc.distanceInt = finalDistance;
        vc.pointOnMap=_pointsForPolyline;
        vc.delegate=self;
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];
    }
}

- (IBAction)resetTracking:(id)sender
{
    [[PSLocationManager sharedLocationManager] resetLocationUpdates];
    
    [[PSLocationManager sharedLocationManager] stopLocationUpdates];
    
    [sender setTitle:@"START" forState:UIControlStateNormal];
    
    [self.imageToMove setImage:[UIImage imageNamed:@"track_main_eclipse.png"]];
    [self.startButton setImage:[UIImage imageNamed:@"track_main_start_button_txt.png"] forState:UIControlStateNormal];
    
    
    _trackingHasStarted=NO;
    
    animating = NO;
    
    timeFromPause = 0.0f;
    
    self.pauseButton.hidden=YES;
    
    isRunning = NO;
    //self.resetButton.hidden=YES;
    
    [self clearAllLabels];
}

- (IBAction)viewMap:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    VTSkiCenterMapViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MapCovered"];
    NSLog(@"Routed added to property with number of items:%d",[_routesCompleted count]);
    vc.routesCovered=_routesCompleted;
    vc.centerLocation=lastLocation;
    vc.maxSpeed=self.maxSpeedLabel.text;
    vc.time=self.durationLabel.text;
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)pauseTracking:(id)sender {
    
    trackPaused = YES;
    
    timeFromPause = elapsedTime_temp;

    
    NSLog(@"STOP WATCH AND LOCATION UPDATE");
    [sender setTitle:@"START" forState:UIControlStateNormal];
    
    [[PSLocationManager sharedLocationManager] stopLocationUpdates];
    
    [self.imageToMove setImage:[UIImage imageNamed:@"track_main_eclipse.png"]];
    [self.startButton setImage:[UIImage imageNamed:@"track_main_start_button_txt.png"] forState:UIControlStateNormal];
    
    
    _trackingHasStarted=NO;
    
    animating = NO;
    
    self.pauseButton.hidden=YES;
    //self.resetButton.hidden=YES;
}

-(void) clearAllLabels
{
    self.latitudeLabel.text = [NSString stringWithFormat:@"--.------"];
	self.longitudeLabel.text = [NSString stringWithFormat:@"--.------"];
	self.altitudeLabel.text = [NSString stringWithFormat:@"0 m"];
    
    self.speedLabel.text = @"-- km/h";
    self.maxSpeedLabel.text = @"-- km/h";
    self.minSpeedLabel.text = @"-- km/h";
    
    self.altitudeLabel.text =@"---- m";
    self.maxAltitudeLabel.text =@"---- m";
    self.minAltitudelabel.text =@"---- m";
    
    self.durationLabel.text=[NSString stringWithFormat:@"0:00.0"];
    
    [_pointsForPolyline removeAllObjects];

}

-(void) updateTime
{
    /*time updated*/
    if (_trackingHasStarted==NO) return;
    
    currentTime= [NSDate timeIntervalSinceReferenceDate];
    
    elapsedTime = currentTime -startTime + timeFromPause ;
    
    elapsedTime_temp = elapsedTime;
    
    
    int mins= (int) (elapsedTime/60.0);
    elapsedTime-=mins*60;
    int secs=(int) (elapsedTime);
    elapsedTime-=secs;
    int fraction=elapsedTime*10.0;
    
    self.durationLabel.text=[NSString stringWithFormat:@"%u:%02u.%u",mins,secs,fraction];
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
    
    //add calculation for average
    double avg = (currentDistance / (mins*60+secs)) * 3.6;
    self.minSpeedLabel.text = [NSString stringWithFormat:@"%.1f km/h",avg];
    
}

- (void)addRoute:(int)trackCode {
    NSString *thePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"KalavrytaRoute%d",trackCode] ofType:@"plist"];
    NSArray *pointsArray = [NSArray arrayWithContentsOfFile:thePath];
    
    NSInteger pointsCount = pointsArray.count;
    
    CLLocationCoordinate2D pointsToUse[pointsCount];
    
    for(int i = 0; i < pointsCount; i++) {
        CGPoint p = CGPointFromString(pointsArray[i]);
        pointsToUse[i] = CLLocationCoordinate2DMake(p.x,p.y);
    }
    
    NSLog(@"Points to be included in the polyline are %d",pointsCount);
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
    
    [_routesCompleted addObject:myPolyline];
    NSLog(@"Routes Covered so far:%d",[_routesCompleted count]);
   /* [self.mapView addOverlay:myPolyline];*/
    //follow tutorial on ray on how to make it visible
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

- (void) showAlert:(NSString *)alertText {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"track done"
                                                      message:alertText
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (IBAction)backButton:(id)sender {
    if (isRunning) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Προσοχή!"
                                                          message:@"Το Track Your Day βρίσκεται σε λειτουργία αυτή την στιγμή. Αν θέλετε να συνεχίσει να λειτουργεί στο παρασκήνιο, πατήστε το κεντρικο κουμπί Home στο κινητό σας αντί για το back. Ενδεχόμενη έξοδος σας από το Track Your Day θα σταματήσει την καταγραφή στοιχείων."
                                                         delegate:nil
                                                cancelButtonTitle:@"Ακύρωση"
                                                otherButtonTitles:@"Έξοδος",nil];
        message.delegate=self;
        [message show];

    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)//OK button pressed
    {
        NSLog(@"Cancel Button called");
    }
    else if(buttonIndex == 1)//make a call button pressed.
    {
        [[PSLocationManager sharedLocationManager] resetLocationUpdates];
        
        [[PSLocationManager sharedLocationManager] stopLocationUpdates];
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

    }
}


- (void) spinWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.5f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         self.imageToMove.transform = CGAffineTransformRotate(_imageToMove.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

- (void) scaleButtonDown : (UIViewAnimationOptions) options {
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        _startButton.imageView.transform = CGAffineTransformMakeScale(0.80, 0.80);
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
        if (finished) {
            if (animating) {
                // if flag still set, keep spinning with constant speed
                [self scaleButtonUp: UIViewAnimationOptionCurveLinear];
            } else if (options != UIViewAnimationOptionCurveEaseOut) {
                // one last spin, with deceleration
                [self scaleButtonUp: UIViewAnimationOptionCurveEaseOut];
            }
        }
    }];
}

- (void) scaleButtonUp : (UIViewAnimationOptions) options {
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        _startButton.imageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
        if (finished) {
            if (animating) {
                // if flag still set, keep spinning with constant speed
                [self scaleButtonDown: UIViewAnimationOptionCurveLinear];
            } else if (options != UIViewAnimationOptionCurveEaseOut) {
                // one last spin, with deceleration
                [self scaleButtonDown: UIViewAnimationOptionCurveEaseOut];
            }
        }
    }];
}

-(NSString *) getLatDegreesFormat:(double) coord getType:(int) type
{
    int degrees = coord;
    NSLog(@"Degrees is:%d",degrees);
    double decimal = fabs(coord - degrees);
    int minutes = decimal * 60;
    double seconds = decimal * 3600 - minutes * 60;
    char lonLetter;
    if (type ==1) {
        lonLetter = (coord > 0) ? 'E' : 'W';
    } else {
        lonLetter = (coord > 0) ? 'N' : 'S';
    }
    NSString *res = [NSString stringWithFormat:@"%d° %d' %1.0f\" %c",
                     degrees, minutes, seconds,lonLetter];
    return res;
}

#pragma mark - VTMapScreenDelegate

- (void) MapScreenCompleted:(VTSkiCenterMapViewController *)controller
{
    isRunning = NO;
    
	[self dismissViewControllerAnimated:NO completion:nil];
    
    NSLog(@"I should performas action like stopped");
    
    [[PSLocationManager sharedLocationManager] resetLocationUpdates];
    
    [[PSLocationManager sharedLocationManager] stopLocationUpdates];
    
    [self.imageToMove setImage:[UIImage imageNamed:@"track_main_eclipse.png"]];
    [self.startButton setImage:[UIImage imageNamed:@"track_main_start_button_txt.png"] forState:UIControlStateNormal];
    
    
    _trackingHasStarted=NO;
    
    animating = NO;
    
    timeFromPause = 0.0f;
    
    self.pauseButton.hidden=YES;
    //self.resetButton.hidden=YES;
    
    [self clearAllLabels];
    
}



@end

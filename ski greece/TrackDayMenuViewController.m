//
//  TrackDayMenuViewController.m
//  Ski Greece
//
//  Created by VimaTeamGr on 8/10/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "TrackDayMenuViewController.h"
#import "TrackDayViewController.h"
#import "StreamPhotoScreen.h"
#import "MainMap.h"
#import "NearbyPlaces.h"
#import "SpecialOffers.h"
#import "NotificationScreen.h"
#import "InfoScreen.h"
#import "Flurry.h"
#import "AppDelegate.h"
#import "DriveMeScreen.h"
#import "API.h"
#import "LocalAPI.h"


@interface TrackDayMenuViewController ()

@end

@implementation TrackDayMenuViewController
{
    /*FBLogin happens without salted password -use as password the facebook Id*/
    __block NSString * fbusername;
    __block NSString * fbpassword;
    NSArray *_regionArray;
    CLLocationManager *_locationManager;


}

@synthesize backgroundImg=_backgroundImg;
@synthesize liveNewsBtn=_liveNewsBtn;
@synthesize trackDayBtn=_trackDayBtn;
@synthesize communBtn=_communBtn;
@synthesize nearbyBtn=_nearbyBtn;
@synthesize notifBtn=_notifBtn;
@synthesize bookBtn=_bookBtn;
@synthesize offersBtn=_offersBtn;
@synthesize infoBtn=_infoBtn;
@synthesize fbBtn=_fbBtn;
@synthesize twitterBtn=_twitterBtn;
@synthesize rateBtn=_rateBtn;

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"ActiveUsername"] == nil) {
        NSLog(@"Username will be set for first time.");
        [defaults setObject:@"None" forKey:@"ActiveUsername"];
    } else {
        NSLog(@"Username is already set.");
    }
    
    if([defaults objectForKey:@"isLoggedIn"] == nil) {
        NSLog(@"isLoggedIn will be set for first time.");
        [defaults setBool:false forKey:@"isLoggedIn"];
    } else {
        NSLog(@"isLoggedIn is already set.");
    }
    
    if([defaults objectForKey:@"wantLocTarget"] == nil) {
        NSLog(@"wantLocTarget will be set for first time.");
        [defaults setBool:true forKey:@"wantLocTarget"];
    } else {
        NSLog(@"wantLocTarget is already set.");
    }
    
    

    [defaults synchronize];
    
    
    /*Initialite for iPhone5*/
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        NSLog(@"iPhone 5 screen.");
        
        //[UIApplication sharedApplication].statusBarFrame.size.height
        
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_no_back_5.png"]];
        
        self.offersBtn.frame = CGRectMake(self.offersBtn.frame.origin.x, self.offersBtn.frame.origin.y , self.offersBtn.frame.size.width, self.offersBtn.frame.size.height);
        
        self.liveNewsBtn.frame = CGRectMake(50, 81 + [UIApplication sharedApplication].statusBarFrame.size.height , 102, 102);
        self.trackDayBtn.frame = CGRectMake(181, 81 +[UIApplication sharedApplication].statusBarFrame.size.height, 102, 102);
        self.notifBtn.frame = CGRectMake(50, 219 + [UIApplication sharedApplication].statusBarFrame.size.height, 102, 102);
        self.nearbyBtn.frame = CGRectMake(181, 219 +[UIApplication sharedApplication].statusBarFrame.size.height, 102, 102);
        self.communBtn.frame = CGRectMake(50, 349 + [UIApplication sharedApplication].statusBarFrame.size.height, 102, 102);
        self.bookBtn.frame = CGRectMake(181, 349 + [UIApplication sharedApplication].statusBarFrame.size.height, 102, 102);
        
        self.infoBtn.frame = CGRectMake(0, 484 + [UIApplication sharedApplication].statusBarFrame.size.height, 53, 42);
        
        self.twitterBtn.frame = CGRectMake(79, 509, 45, 45);
        self.fbBtn.frame = CGRectMake(146, 509, 45, 45);
        self.rateBtn.frame = CGRectMake(210, 509, 45, 45);
        
       
        //[self.view sendSubviewToBack: imgView];


        
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
    
    
    if(![defaults boolForKey:@"hasSeenTutorial"]) {
        NSLog(@"User will see the tutorial");
        [defaults setBool:false forKey:@"hasSeenTutorial"];
        [self showIntroWithCrossDissolve];
        [defaults synchronize];
    } else {
        NSLog(@"User has seen tutorial");
    }
    /*log the user as early as possible*/
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        if (FBSession.activeSession.isOpen) {
            NSLog(@"FBSession is open. Will populate user details.");
            if (![API sharedInstance].isAuthorized) {
                [[FBRequest requestForMe] startWithCompletionHandler:
                 ^(FBRequestConnection *connection,
                   NSDictionary<FBGraphUser> *user,
                   NSError *error) {
                     if (!error) {
                         NSLog(@"Username: %@",user.name);
                         fbusername = user.name;
                         fbpassword = user.id;
                         [self FBloginUser:fbusername withPass:fbpassword];
                     }
                 }];
            }
        } else {
            NSLog(@"Session is not open");
            NSLog(@"There is token for session - I need to call OpenSession");
            [self openSession];
        }
    } else {
        NSLog(@"There isn't token for session - I need to call OpenSession");
    }
    
    if(![defaults boolForKey:@"wantLocTarget"]) {
        NSLog(@"User does not want to see Location targeting adverts");
        [[PSLocationManager sharedLocationManager] stopMonitoringForRegions];
    } else
    {
        if([CLLocationManager locationServicesEnabled]){
            
            NSLog(@"Location Services Enabled");
            
            if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
                /*UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                   message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
                [alert show];*/
                NSLog(@"Location settings denied for this app");
            } else {
                NSLog(@"User want to see Location targeting adverts");
                NSLog(@"Initialite regions for location targeting");
                //[[PSLocationManager sharedLocationManager] stopMonitoringForRegions];
                //[[PSLocationManager sharedLocationManager] initializeLocationManager];
                NSArray *geofences = [[PSLocationManager sharedLocationManager] buildGeofenceData];
                [[PSLocationManager sharedLocationManager] initializeRegionMonitoring:geofences];
                [[PSLocationManager sharedLocationManager] currentMonitoringRegions];
            }
        } else {
            NSLog(@"Location settings are not enabled");
        }
        
        
       
        
    }
    
    /*load data for spash screen offers*/
    
    [[LocalAPI sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  @"splash",@"command",
                                                  nil]
                                    onCompletion:^(NSDictionary *json) {
                                        //got stream
                                        NSLog(@"got stream with total number of data: %d",[[json objectForKey:@"result"] count]);
                                        NSLog(@"Printing result:%@",[[json objectForKey:@"result"] description]);
                                    }];
    
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToBook:(id)sender {
    
    [Flurry logEvent:@"DriveMeScreen"];

    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    DriveMeScreen *vc = [sb instantiateViewControllerWithIdentifier:@"DriveMeScreenID"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)goToTrackYourDay:(id)sender
{
    [Flurry logEvent:@"TrackDayOpened"];
    

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    TrackDayViewController *vc = [sb instantiateViewControllerWithIdentifier:@"TrackDay"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)goToCommunity:(id)sender {
    
    [Flurry logEvent:@"CommunityOpened"];

    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    StreamPhotoScreen *vc = [sb instantiateViewControllerWithIdentifier:@"CommunityMain"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)goToNotification:(id)sender
{
    [Flurry logEvent:@"NotificationsOpened"];
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    NotificationScreen *vc = [sb instantiateViewControllerWithIdentifier:@"NotificationScreen"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)gotoLiveNews:(id)sender {
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    MainMap *vc = [sb instantiateViewControllerWithIdentifier:@"MainSkiList"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)goToNearby:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    NearbyPlaces *vc = [sb instantiateViewControllerWithIdentifier:@"Nearby"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)goToOffers:(id)sender {
    [Flurry logEvent:@"OffersOpened"];
    

    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SpecialOffers *vc = [sb instantiateViewControllerWithIdentifier:@"SpecialOffersID"];
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vc.numberOfOffers=3;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)goToInfo:(id)sender {
    [Flurry logEvent:@"InfoOpened"];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    InfoScreen *vc = [sb instantiateViewControllerWithIdentifier:@"InfoScreenID"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)twitterPost:(id)sender {
    
    NSString *channelName = @"SkiSnowboardGreece";
    
    NSURL *linkToAppURL = [NSURL URLWithString:[NSString stringWithFormat:@"youtube://user/%@",channelName]];
    NSURL *linkToWebURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/user/%@",channelName]];
    
    if ([[UIApplication sharedApplication] canOpenURL:linkToAppURL]) {
        // Can open the youtube app URL so launch the youTube app with this URL
        [[UIApplication sharedApplication] openURL:linkToAppURL];
    }
    else{
        // Can't open the youtube app URL so launch Safari instead
        [[UIApplication sharedApplication] openURL:linkToWebURL];
    }
    
}

- (IBAction)fbPost:(id)sender {
    
    [Flurry logEvent:@"FBOpenPage"];
    
    NSURL *url = [NSURL URLWithString:@"fb://profile/310596042315395"];
    [[UIApplication sharedApplication] openURL:url];
    
}



- (IBAction)rateMePost:(id)sender {
    [Flurry logEvent:@"RateMeOpened"];

    
    static NSString *const iOSAppStoreURLFormat=@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%u";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:iOSAppStoreURLFormat, (unsigned int)565068622]]];
}


/*introduction screens*/


- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"tutorial_1"];
    
    //page1.title = @"Hello world";
    //page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    //page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"tutorial_2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"tut3"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"tut4"];

    EAIntroPage *page5 = [EAIntroPage page];
    page5.bgImage = [UIImage imageNamed:@"tut5"];
    
    EAIntroPage *page6 = [EAIntroPage page];
    page6.bgImage = [UIImage imageNamed:@"tut6"];
    
    EAIntroPage *page7 = [EAIntroPage page];
    page7.bgImage = [UIImage imageNamed:@"tut7"];
    
    EAIntroPage *page8 = [EAIntroPage page];
    page8.bgImage = [UIImage imageNamed:@"tut8"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4,page5,page6,page7,page8]];
    
    intro.delegate = self;
    
    //[intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}


#pragma mark - IntroView delegate
- (void)introDidFinish : (EAIntroView *)introView {
    NSLog(@"Intro callback");
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"hasSeenTutorial"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   

}


#pragma mark - facebook functions

- (void)openSession
{
    NSLog(@"Open Session Called");
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
         //onec session is completed
         
         [[FBRequest requestForMe] startWithCompletionHandler:
          ^(FBRequestConnection *connection,
            NSDictionary<FBGraphUser> *user,
            NSError *error) {
              if (!error) {
                  NSLog(@"Username: %@",user.name);
                  fbusername = user.name;
                  fbpassword = user.id;
                  [self FBloginUser:fbusername withPass:fbpassword];
              }
          }];
         
     }];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            NSLog(@"FBSessionStateOpen");
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            //[self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"Facebook callback - logic returned in main Screen");
    return [FBSession.activeSession handleOpenURL:url];
}


- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 NSLog(@"Username:%@",user.name);
             }
         }];
    }
}

#pragma mark - API functions

-(void) FBloginUser:(NSString*)user withPass:(NSString*)password
{
    NSLog(@"FB username: %@",user);
    NSLog(@"FB password: %@",password);
    
    NSLog(@"User already exists - log him in");
    
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"login", @"command",
                                  user, @"username",
                                  password, @"password",
                                  nil];
    //make the call to the web API
    [[API sharedInstance] commandWithParams:params
                               onCompletion:^(NSDictionary *json) {
                                   //handle the response
                                   //result returned
                                   NSDictionary* res = [[json objectForKey:@"result"] objectAtIndex:0];
                                   if ([json objectForKey:@"error"]==nil && [[res objectForKey:@"IdUser"] intValue]>0) {
                                       
                                       [[API sharedInstance] setUser: res];
                                       
                                       
                                       //show message to the user
                                       NSLog(@"User %@ is now logged in",[res objectForKey:@"username"]);
                                       
                                   } 
                               }];
}















@end

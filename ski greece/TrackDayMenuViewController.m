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
#import "PAPHomeViewController.h"
#import "PAPLogInViewController.h"
#import "VTHomeViewController.h"
#import "CBZSplashView.h"
#import "SMBInternetConnectionIndicator.h"


// IPHONE 6 : Distance between basic button X => 55  , Y => 50
// 

#define BASIC_BUTTON_WIDTH 102.0f
#define BASIC_BUTTON_HEIGHT 102.0f

#define LIVE_NEWS_BTN_X_IPHONE_5 50.0f
#define LIVE_NEWS_BTN_X_IPHONE_6 55.0f
#define LIVE_NEWS_BTN_Y_IPHONE_5 81.0f
#define LIVE_NEWS_BTN_Y_IPHONE_6 101.0f

#define TRACK_DAY_BTN_X_IPHONE_5 181.0f
#define TRACK_DAY_BTN_X_IPHONE_6 212.0f
#define TRACK_DAY_BTN_Y_IPHONE_5 LIVE_NEWS_BTN_Y_IPHONE_5
#define TRACK_DAY_BTN_Y_IPHONE_6 LIVE_NEWS_BTN_Y_IPHONE_6
                                
#define NOTIFY_BTN_X_IPHONE_5 LIVE_NEWS_BTN_X_IPHONE_5
#define NOTIFY_BTN_X_IPHONE_6 LIVE_NEWS_BTN_X_IPHONE_6
#define NOTIFY_BTN_Y_IPHONE_5 219.0f
#define NOTIFY_BTN_Y_IPHONE_6 253.0f
                                
#define NEARBY_BTN_X_IPHONE_5 TRACK_DAY_BTN_X_IPHONE_5
#define NEARBY_BTN_X_IPHONE_6 TRACK_DAY_BTN_X_IPHONE_6
#define NEARBY_BTN_Y_IPHONE_5 NOTIFY_BTN_Y_IPHONE_5
#define NEARBY_BTN_Y_IPHONE_6 NOTIFY_BTN_Y_IPHONE_6
                                
#define COMMUNITY_BTN_X_IPHONE_5 LIVE_NEWS_BTN_X_IPHONE_5
#define COMMUNITY_BTN_X_IPHONE_6 LIVE_NEWS_BTN_X_IPHONE_6
#define COMMUNITY_BTN_Y_IPHONE_5 349.0f
#define COMMUNITY_BTN_Y_IPHONE_6 405.0f
                                
#define BOOK_BTN_X_IPHONE_5 TRACK_DAY_BTN_X_IPHONE_5
#define BOOK_BTN_X_IPHONE_6 TRACK_DAY_BTN_X_IPHONE_6
#define BOOK_BTN_Y_IPHONE_5 COMMUNITY_BTN_Y_IPHONE_5
#define BOOK_BTN_Y_IPHONE_6 COMMUNITY_BTN_Y_IPHONE_6


//
//

#define SMALL_ICON_HEIGHT 45
#define SMALL_ICON_WIDTH  45

#define TWITTER_BTN_X_IPHONE_5  79
#define TWITTER_BTN_X_IPHONE_6  94
#define TWITTER_BTN_Y_IPHONE_5  509
#define TWITTER_BTN_Y_IPHONE_6  600

#define FB_BTN_X_IPHONE_5 146
#define FB_BTN_X_IPHONE_6 161
#define FB_BTN_Y_IPHONE_5 TWITTER_BTN_Y_IPHONE_5
#define FB_BTN_Y_IPHONE_6 TWITTER_BTN_Y_IPHONE_6

#define RATE_BTN_X_IPHONE_5 210
#define RATE_BTN_X_IPHONE_6 225
#define RATE_BTN_Y_IPHONE_5 TWITTER_BTN_Y_IPHONE_5
#define RATE_BTN_Y_IPHONE_6 TWITTER_BTN_Y_IPHONE_6

#define INFO_BTN_X_IPHONE_5 0
#define INFO_BTN_X_IPHONE_6 INFO_BTN_X_IPHONE_5
#define INFO_BTN_Y_IPHONE_5 484
#define INFO_BTN_Y_IPHONE_6 534

#define INFO_BTN_HEIGHT 42
#define INFO_BTN_WIDTH  53



@interface TrackDayMenuViewController ()

@property (nonatomic, strong) PAPHomeViewController *homeViewController;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) CBZSplashView *splashView;
@property () SMBInternetConnectionIndicator *internetConnectionIndicator;

@end

@implementation TrackDayMenuViewController
{
    /*FBLogin happens without salted password -use as password the facebook Id*/
    //__block NSString * fbusername;
    //__block NSString * fbpassword;
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
    
    if (IS_DEVELOPER) {
        NSLog(@"Device is : %@", (IS_IPHONE_4_OR_LESS) ? @"iPhone4" : (IS_IPHONE_5) ? @"iPhone5" : (IS_IPHONE_6) ? @"iPhone6" : (IS_IPHONE_6P) ? @ "iPhone6+" : @"Unknown device");
    }
    
    
    //?? see where they are used
    
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
    
    // Boolean for skipped button
    
    if([defaults objectForKey:@"loginCompleted"] == nil) {
        [defaults setBool:false forKey:@"isLoggedIn"];
    }
    
    [defaults synchronize];


    
    
    /*Initialite for iPhone5/6*/
    
    
    [self adjustLayoutForDevices];
    
    
    
//    if(![defaults boolForKey:@"hasSeenTutorial"]) {
//        NSLog(@"User will see the tutorial");
//        [defaults setBool:false forKey:@"hasSeenTutorial"];
//        [self showIntroWithCrossDissolve];
//        [defaults synchronize];
// } else {
//        NSLog(@"User has seen tutorial");
//    }
    
//    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
//        if (FBSession.activeSession.isOpen) {
//            NSLog(@"FBSession is open. Will populate user details.");
//            if (![API sharedInstance].isAuthorized) {
//                [[FBRequest requestForMe] startWithCompletionHandler:
//                 ^(FBRequestConnection *connection,
//                   NSDictionary<FBGraphUser> *user,
//                   NSError *error) {
//                     if (!error) {
//                         NSLog(@"Username: %@",user.name);
//                         fbusername = user.name;
//                         fbpassword = user.id;
//                         [self FBloginUser:fbusername withPass:fbpassword];
//                     }
//                 }];
//            }
//        } else {
//            NSLog(@"Session is not open");
//            NSLog(@"There is token for session - I need to call OpenSession");
//            [self openSession];
//        }
//    } else {
//        NSLog(@"There isn't token for session - I need to call OpenSession");
//    }
    
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
    //?? FIXME this should not load back anyting
    
//    [[LocalAPI sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                                  @"splash",@"command",
//                                                  nil]
//                                    onCompletion:^(NSDictionary *json) {
//                                        //got stream
//                                        NSLog(@"Command splash : got stream with total number of data: %lu",(unsigned long)[[json objectForKey:@"result"] count]);
//                                        NSLog(@"Printing result:%@",[[json objectForKey:@"result"] description]);
//                                    }];
    
    // subscribing to a developer channel used for debugging purposes
    if (IS_DEVELOPER) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObject:@"SkiGreeceAdmin_201415" forKey:@"channels"];
        [currentInstallation saveInBackground];
    }
    
    
    // adding splash screen for cosmote
    
    if (COSMOTE_AD) {
        __unused UIImage *icon = [UIImage imageNamed:@"splash_icon.png"];
        
        CBZSplashView *splashView = [CBZSplashView splashViewWithIcon:icon backgroundImage:[UIImage imageNamed:@"ski_greece_splash_screen_new"]];
        splashView.animationDuration = 3;
        //splashView.iconColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_launcher.png"]];
        
        [self.view addSubview:splashView];
        self.splashView = splashView;
    }
    
    //create frame for the indicator
    CGRect screenRect                   = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, SCREEN_WIDTH, 30);
    self.internetConnectionIndicator    = [[SMBInternetConnectionIndicator alloc] initWithFrame:screenRect];
    [self.view addSubview:_internetConnectionIndicator];
    
   

    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    // When user is not logged in
    // if login is not completed [aka first time] openLoginScreen
    
    /* wait a beat before animating in */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.splashView startAnimation];
        if ((![PFUser currentUser]) && (![defaults boolForKey:@"loginCompleted"])) {
            [self openLoginScreen];
            return;
        }
    });
    
    // If not logged in, present login view controller
    
    
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
    VTHomeViewController *vc=[sb instantiateViewControllerWithIdentifier:@"CommunityMainAnypicStoryboard"];
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

#pragma mark- Login View Controller

-(void) openLoginScreen
{
    if (IS_DEVELOPER) NSLog(@"Showing login screen");
    PAPLogInViewController *loginViewController = [[PAPLogInViewController alloc] init];
    [loginViewController setDelegate:self];
    loginViewController.fields = PFLogInFieldsFacebook;
    loginViewController.facebookPermissions = @[ @"user_about_me" ];
    [self presentViewController:loginViewController animated:YES completion:NULL];
}

#pragma mark - PFLoginViewController

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:true forKey:@"loginCompleted"];
    [defaults synchronize];
    
    if (IS_DEVELOPER) NSLog(@"User has logged in we need to fetch all of their Facebook data before we let them in");
    // user has logged in - we need to fetch all of their Facebook data before we let them in
    //if (![self shouldProceedToMainInterface:user]) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.labelText = NSLocalizedString(@"Loading", nil);
        self.hud.dimBackground = YES;
    //}
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            //[self facebookRequestDidLoad:result];
            if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(facebookRequestDidLoad:)]) {
                [[UIApplication sharedApplication].delegate performSelector:@selector(facebookRequestDidLoad:) withObject:result];
            }
        } else {
            if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(facebookRequestDidFailWithError:)]) {
                [[UIApplication sharedApplication].delegate performSelector:@selector(facebookRequestDidFailWithError:) withObject:error];
            }
        }
        [self.hud hide:YES];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
    
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:true forKey:@"loginCompleted"];
    [defaults synchronize];
    if (IS_DEVELOPER) NSLog(@"Login Cancelled");
    [self dismissViewControllerAnimated:NO completion:nil];
    

}



//#pragma mark - facebook functions
//
//- (void)openSession
//{
//    NSLog(@"Open Session Called");
//    [FBSession openActiveSessionWithReadPermissions:nil
//                                       allowLoginUI:YES
//                                  completionHandler:
//     ^(FBSession *session,
//       FBSessionState state, NSError *error) {
//         [self sessionStateChanged:session state:state error:error];
//         //onec session is completed
//         
//         [[FBRequest requestForMe] startWithCompletionHandler:
//          ^(FBRequestConnection *connection,
//            NSDictionary<FBGraphUser> *user,
//            NSError *error) {
//              if (!error) {
//                  NSLog(@"Username: %@",user.name);
//                  fbusername = user.name;
//                  fbpassword = user.id;
//                  [self FBloginUser:fbusername withPass:fbpassword];
//              }
//          }];
//         
//     }];
//}
//
//- (void)sessionStateChanged:(FBSession *)session
//                      state:(FBSessionState) state
//                      error:(NSError *)error
//{
//    switch (state) {
//        case FBSessionStateOpen: {
//            NSLog(@"FBSessionStateOpen");
//        }
//            break;
//        case FBSessionStateClosed:
//        case FBSessionStateClosedLoginFailed:
//            
//            [FBSession.activeSession closeAndClearTokenInformation];
//            
//            //[self showLoginView];
//            break;
//        default:
//            break;
//    }
//    
//    if (error) {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Error"
//                                  message:error.localizedDescription
//                                  delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alertView show];
//    }
//}
//
//
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation
//{
//    NSLog(@"Facebook callback - logic returned in main Screen");
//    return [FBSession.activeSession handleOpenURL:url];
//}
//
//
//- (void)populateUserDetails
//{
//    if (FBSession.activeSession.isOpen) {
//        [[FBRequest requestForMe] startWithCompletionHandler:
//         ^(FBRequestConnection *connection,
//           NSDictionary<FBGraphUser> *user,
//           NSError *error) {
//             if (!error) {
//                 NSLog(@"Username:%@",user.name);
//             }
//         }];
//    }
//}
//
//#pragma mark - API functions
//
//-(void) FBloginUser:(NSString*)user withPass:(NSString*)password
//{
//    NSLog(@"FB username: %@",user);
//    NSLog(@"FB password: %@",password);
//    
//    NSLog(@"User already exists - log him in");
//    
//    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                  @"login", @"command",
//                                  user, @"username",
//                                  password, @"password",
//                                  nil];
//    //make the call to the web API
//    [[API sharedInstance] commandWithParams:params
//                               onCompletion:^(NSDictionary *json) {
//                                   //handle the response
//                                   //result returned
//                                   NSDictionary* res = [[json objectForKey:@"result"] objectAtIndex:0];
//                                   if ([json objectForKey:@"error"]==nil && [[res objectForKey:@"IdUser"] intValue]>0) {
//                                       
//                                       [[API sharedInstance] setUser: res];
//                                       
//                                       
//                                       //show message to the user
//                                       NSLog(@"User %@ is now logged in",[res objectForKey:@"username"]);
//                                       
//                                   } 
//                               }];
//}

#pragma mark - adjusting layout for different devices

-(void)  adjustLayoutForDevices
{
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (IS_IPHONE_6) {
        if (IS_DEVELOPER) NSLog(@"iPhone 6 screen");
        
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 375, 647);
        //?? fixme image for iphone 6
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_no_back_5.png"]];
        
        self.offersBtn.frame = CGRectMake(self.offersBtn.frame.origin.x + 50.0f, self.offersBtn.frame.origin.y , self.offersBtn.frame.size.width, self.offersBtn.frame.size.height);
        
        self.liveNewsBtn.frame = CGRectMake(LIVE_NEWS_BTN_X_IPHONE_6, LIVE_NEWS_BTN_Y_IPHONE_6 + [UIApplication sharedApplication].statusBarFrame.size.height , BASIC_BUTTON_WIDTH, BASIC_BUTTON_HEIGHT);
        self.trackDayBtn.frame = CGRectMake(TRACK_DAY_BTN_X_IPHONE_6, TRACK_DAY_BTN_Y_IPHONE_6 +[UIApplication sharedApplication].statusBarFrame.size.height, BASIC_BUTTON_WIDTH, BASIC_BUTTON_HEIGHT);
        self.notifBtn.frame = CGRectMake(NOTIFY_BTN_X_IPHONE_6, NOTIFY_BTN_Y_IPHONE_6 + [UIApplication sharedApplication].statusBarFrame.size.height, BASIC_BUTTON_WIDTH, BASIC_BUTTON_HEIGHT);
        self.nearbyBtn.frame = CGRectMake(NEARBY_BTN_X_IPHONE_6, NEARBY_BTN_Y_IPHONE_6 +[UIApplication sharedApplication].statusBarFrame.size.height, BASIC_BUTTON_WIDTH, BASIC_BUTTON_HEIGHT);
        self.communBtn.frame = CGRectMake(COMMUNITY_BTN_X_IPHONE_6, COMMUNITY_BTN_Y_IPHONE_6 + [UIApplication sharedApplication].statusBarFrame.size.height, BASIC_BUTTON_WIDTH, BASIC_BUTTON_HEIGHT);
        self.bookBtn.frame = CGRectMake(BOOK_BTN_X_IPHONE_6, BOOK_BTN_Y_IPHONE_6 + [UIApplication sharedApplication].statusBarFrame.size.height, BASIC_BUTTON_WIDTH, BASIC_BUTTON_HEIGHT);
        
        self.infoBtn.frame = CGRectMake(INFO_BTN_X_IPHONE_6, INFO_BTN_Y_IPHONE_6 + [UIApplication sharedApplication].statusBarFrame.size.height, INFO_BTN_WIDTH, INFO_BTN_HEIGHT);
        
        self.twitterBtn.frame = CGRectMake(TWITTER_BTN_X_IPHONE_6, TWITTER_BTN_Y_IPHONE_6, SMALL_ICON_WIDTH, SMALL_ICON_HEIGHT);
        self.fbBtn.frame = CGRectMake(FB_BTN_X_IPHONE_6, FB_BTN_Y_IPHONE_6, SMALL_ICON_WIDTH, SMALL_ICON_HEIGHT);
        self.rateBtn.frame = CGRectMake(RATE_BTN_X_IPHONE_6, RATE_BTN_Y_IPHONE_6, SMALL_ICON_WIDTH, SMALL_ICON_HEIGHT);
        
        
    } else if (IS_IPHONE_5) {
        //if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        NSLog(@"iPhone 5 screen.");
        
        //[UIApplication sharedApplication].statusBarFrame.size.height
        
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_no_back_5.png"]];
        
        self.offersBtn.frame = CGRectMake(self.offersBtn.frame.origin.x, self.offersBtn.frame.origin.y , self.offersBtn.frame.size.width, self.offersBtn.frame.size.height);
        
        self.liveNewsBtn.frame = CGRectMake(LIVE_NEWS_BTN_X_IPHONE_5, LIVE_NEWS_BTN_Y_IPHONE_5 + [UIApplication sharedApplication].statusBarFrame.size.height , BASIC_BUTTON_WIDTH, BASIC_BUTTON_HEIGHT);
        self.trackDayBtn.frame = CGRectMake(TRACK_DAY_BTN_X_IPHONE_5, TRACK_DAY_BTN_Y_IPHONE_5 +[UIApplication sharedApplication].statusBarFrame.size.height, BASIC_BUTTON_WIDTH, BASIC_BUTTON_HEIGHT);
        self.notifBtn.frame = CGRectMake(NOTIFY_BTN_X_IPHONE_5, NOTIFY_BTN_Y_IPHONE_5 + [UIApplication sharedApplication].statusBarFrame.size.height, BASIC_BUTTON_WIDTH, BASIC_BUTTON_HEIGHT);
        self.nearbyBtn.frame = CGRectMake(NEARBY_BTN_X_IPHONE_5, NEARBY_BTN_Y_IPHONE_5 +[UIApplication sharedApplication].statusBarFrame.size.height, BASIC_BUTTON_WIDTH, BASIC_BUTTON_HEIGHT);
        self.communBtn.frame = CGRectMake(COMMUNITY_BTN_X_IPHONE_5, COMMUNITY_BTN_Y_IPHONE_5 + [UIApplication sharedApplication].statusBarFrame.size.height, BASIC_BUTTON_WIDTH, BASIC_BUTTON_HEIGHT);
        self.bookBtn.frame = CGRectMake(BOOK_BTN_X_IPHONE_5, BOOK_BTN_Y_IPHONE_5 + [UIApplication sharedApplication].statusBarFrame.size.height, BASIC_BUTTON_WIDTH, BASIC_BUTTON_HEIGHT);
        
        
        self.infoBtn.frame = CGRectMake(INFO_BTN_X_IPHONE_5, INFO_BTN_Y_IPHONE_5 + [UIApplication sharedApplication].statusBarFrame.size.height, INFO_BTN_WIDTH, INFO_BTN_HEIGHT);
        
        self.twitterBtn.frame = CGRectMake(TWITTER_BTN_X_IPHONE_5, TWITTER_BTN_Y_IPHONE_5, SMALL_ICON_WIDTH, SMALL_ICON_HEIGHT);
        self.fbBtn.frame = CGRectMake(FB_BTN_X_IPHONE_5, FB_BTN_Y_IPHONE_5, SMALL_ICON_WIDTH, SMALL_ICON_HEIGHT);
        self.rateBtn.frame = CGRectMake(RATE_BTN_X_IPHONE_5, RATE_BTN_Y_IPHONE_5, SMALL_ICON_WIDTH, SMALL_ICON_HEIGHT);
        
        
        //[self.view sendSubviewToBack: imgView];
        
    }
    
    
    // adding a black bar on top of the screen in order to look like old ios
    //?? FIXME this needs to changed into modenr graphics
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        if (IS_IPHONE_6) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 20)];
            imgView.backgroundColor=[UIColor blackColor];
            [self.view addSubview:imgView];
        } else if ((IS_IPHONE_5) || (IS_IPHONE_4_OR_LESS)){
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
            imgView.backgroundColor=[UIColor blackColor];
            [self.view addSubview:imgView];
        }
    }

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }

}


@end

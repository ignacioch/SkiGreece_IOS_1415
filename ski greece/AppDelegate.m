//
//  AppDelegate.m
//  Ski Greece
//
//  Created by VimaTeamGr on 9/5/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import "AppDelegate.h"
#import "Appirater.h"
#import "Flurry.h"
#import "API.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>


@implementation AppDelegate

@synthesize notif_text=_notif_text;
@synthesize notification_msg = _notification_msg;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Appirater setAppId:@"565068622"];
    [Appirater setDaysUntilPrompt:30];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:7];
    [Appirater setDebug:NO];
    
    // Override point for customization after application launch.
    [Parse setApplicationId:@"Q982ewBYSL47LhFVnPfn84btjrLOSiWmvbjetvI6"
                  clientKey:@"OBFZCzbJVUjAeX3LmKDJ7ylKshklNvWjUJKSjEvL"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    [Appirater appLaunched:YES];
    
    [Flurry setCrashReportingEnabled:YES];
    //note: iOS only allows one crash reporting tool per app; if using another, set to: NO
    [Flurry startSession:@"ZNM7QQCSYP4XC5JNR59J"];
    //your code
    [Flurry setCrashReportingEnabled:YES];
    
    
    // Extract the notification data
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    // Create a pointer to the Photo object
    _notif_text = [notificationPayload objectForKey:@"text"];
    
    NSLog(@"Notification message in didFinishLaunching:%@",notificationPayload);
    
    if (_notif_text == nil || [_notif_text isEqual:[NSNull null]]) {
        NSLog(@"Notification text is null.");
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Προσφορά!"
                                                          message:_notif_text
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
        message.delegate=self;
        [message show];
    }
    
    
    
    
    //Initialize facebook with Parse
    
    [PFFacebookUtils initializeFacebook];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[FBSettings publishInstall:@"220305831428010"];
    
    //[FBSettings publishInstall:[FBSession defaultAppID]];
    [FBAppEvents activateApp];
    
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PFFacebookUtils session] close];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

//Add For Parse SDK

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [PFPush handlePush:userInfo];
    
    _notif_text = [userInfo objectForKey:@"offer"];
    
    if ( application.applicationState == UIApplicationStateActive ){
        // app was already in the foreground
        NSLog(@"Notification message in didReceive. App is in foreground:%@",userInfo);
        
    }
    else {
        // app was just brought from background to foreground
        NSLog(@"Notification message in didReceive. App was in background:%@",userInfo);
        
        if (_notif_text == nil || [_notif_text isEqual:[NSNull null]]) {
            NSLog(@"Notification text is null.");
        } else {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Προσφορά!"
                                                              message:_notif_text
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
            message.delegate=self;
            [message show];
        }
    }
    
}

#pragma mark - AppDelegate


- (void)logOut {
    // clear cache
    [[PAPCache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Unsubscribe from push notifications by removing the user association from the current installation.
    [[PFInstallation currentInstallation] removeObjectForKey:kPAPInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];
    
    // Clear all caches
    [PFQuery clearAllCachedResults];
    
    // Log out
    [PFUser logOut];
    
    // clear out cached data, view controllers, etc
    //[self.navController popToRootViewControllerAnimated:NO];
    
    //[self presentLoginViewController];
    
    //self.homeViewController = nil;
    //self.activityViewController = nil;
}



@end

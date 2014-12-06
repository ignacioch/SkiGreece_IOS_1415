//
//  AppDelegate.h
//  Ski Greece
//
//  Created by VimaTeamGr on 9/5/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PAPHomeViewController.h"
#import "PAPPhotoDetailsViewController.h"
#import "PAPFindFriendsViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSString *center;
@property (assign) int cent_id;
@property (assign) int total_no_lifts;
@property (assign) int current_camera;
@property (assign) int myskigreece_mode;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong)  NSMutableArray *lifts_cond;
@property (nonatomic,strong)  NSMutableArray *tracks_cond;
@property (assign) int cond;
@property (nonatomic,strong) NSString *prosfora_url;
@property (nonatomic,strong) NSString *prosfora_full_url;
@property (nonatomic,strong) NSString *prosfora_code;
@property (nonatomic,strong) NSString *prosfora_table_name;
@property (nonatomic,strong) NSString *name_label;
@property (nonatomic,strong) NSString *email_label;
@property (nonatomic,strong) NSMutableArray *mylist_emails;
@property (nonatomic,strong) NSMutableArray *mylist_codes;
@property (nonatomic,strong) NSMutableArray *mylist_urls;
@property (nonatomic,strong) NSMutableArray *mylist_fulls;
@property (nonatomic,strong) NSMutableArray *cameras_urls;
@property (nonatomic,strong) NSString *weather_url;
@property (nonatomic,strong) NSString *diag_url;
@property (nonatomic,strong) NSString *diag_full_url;
@property (nonatomic,strong) NSString *diag_code;
@property (nonatomic,strong) NSString *diag_table_name;
@property (nonatomic,strong) NSString *notif_text;
@property (nonatomic,strong) NSDictionary *notification_msg;

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSTimer *autoFollowTimer;

@property (nonatomic, strong) PAPHomeViewController *homeViewController;
@property (nonatomic, strong) PAPPhotoDetailsViewController *photoDetailsViewController;
@property (nonatomic, strong) PAPFindFriendsViewController *findFriendViewController;


- (BOOL)shouldProceedToMainInterface:(PFUser *)user;
- (void)logOut;
- (void)facebookRequestDidLoad:(id)result;
- (void)facebookRequestDidFailWithError:(NSError *)error;
@property (nonatomic, readonly) int networkStatus;

- (BOOL)isParseReachable;




@end

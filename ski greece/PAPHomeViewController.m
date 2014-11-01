//
//  PAPHomeViewController.m
//  Anypic
//
//  Created by Héctor Ramos on 5/2/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PAPHomeViewController.h"
#import "PAPSettingsActionSheetDelegate.h"
#import "PAPSettingsButtonItem.h"
#import "PAPFindFriendsViewController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface PAPHomeViewController ()
    @property (nonatomic, strong) PAPSettingsActionSheetDelegate *settingsActionSheetDelegate;
    @property (nonatomic, strong) UIView *blankTimelineView;
@end

typedef enum {
    kPAPSettingsProfile = 0,
    kPAPSettingsTakePhoto ,
    kPAPSettingsActivity,
    kPAPSettingsFindFriends,
    kPAPSettingsLogout,
    kPAPSettingsNumberOfButtons
} kPAPSettingsActionSheetButtons;


@implementation PAPHomeViewController

@synthesize firstLaunch;
@synthesize settingsActionSheetDelegate;
@synthesize blankTimelineView;


#pragma mark - UIViewController

/*- (void)loadView {
    NSLog(@"LoadView is called");
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [backgroundImageView setImage:[UIImage imageNamed:@"DefaultAnypic.png"]];
    self.view = backgroundImageView;
 
    // Present Anypic UI
    [self presentUI];
}*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // If not logged in, present login view controller
    if (![PFUser currentUser]) {
        NSLog(@"User is not logged in");
        //[(AppDelegate*)[[UIApplication sharedApplication] delegate] presentLoginViewControllerAnimated:NO];
        return;
    }
    NSLog(@"User is logged in");
    
    
    
    // Refresh current user with server side data -- checks if user is still valid and so on
    [[PFUser currentUser] refreshInBackgroundWithTarget:self selector:@selector(refreshCurrentUserCallbackWithResult:error:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [backgroundImageView setImage:[UIImage imageNamed:@"DefaultAnypic.png"]];
    self.view = backgroundImageView;
    
    self.blankTimelineView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake( 33.0f, 96.0f, 253.0f, 173.0f);
    [button setBackgroundImage:[UIImage imageNamed:@"HomeTimelineBlank.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(inviteFriendsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.blankTimelineView addSubview:button];*/
    
    NSLog(@"LoadView is called");
    
    // Present Anypic UI
    [self presentUI];
    
}


#pragma mark - PFQueryTableViewController

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];

    if (IS_DEVELOPER) {
        NSLog(@"objectsDidLoad");
    }
    
    if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult] & !self.firstLaunch) {
        self.tableView.scrollEnabled = NO;
        
        if (!self.blankTimelineView.superview) {
            self.blankTimelineView.alpha = 0.0f;
            self.tableView.tableHeaderView = self.blankTimelineView;
            
            [UIView animateWithDuration:0.200f animations:^{
                self.blankTimelineView.alpha = 1.0f;
            }];
        }
    } else {
        self.tableView.tableHeaderView = nil;
        self.tableView.scrollEnabled = YES;
    }    
}


#pragma mark - ()

- (void)settingsButtonAction:(id)sender {
    if (IS_DEVELOPER) {
        NSLog(@"Settings button pressed");
    }

    self.settingsActionSheetDelegate = [[PAPSettingsActionSheetDelegate alloc] initWithNavigationController:self.navigationController];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                        destructiveButtonTitle:nil
                                                        otherButtonTitles:@"My Profile",@"Take Photo",@"My Activity",@"Find Friends",@"Log Out", nil];
    
    [actionSheet showInView:self.view];
    //[actionSheet showFromTabBar:self.tabBarController.tabBar];
}


- (void)inviteFriendsButtonAction:(id)sender {
    PAPFindFriendsViewController *detailViewController = [[PAPFindFriendsViewController alloc] init];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - ()

- (void)_presentLoginViewControllerAnimated:(BOOL)animated {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LoginViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FBLoginScreen"];
    [self presentViewController:vc animated:animated completion:nil];
    
}

#pragma mark - ()

- (void)refreshCurrentUserCallbackWithResult:(PFObject *)refreshedObject error:(NSError *)error {
    // A kPFErrorObjectNotFound error on currentUser refresh signals a deleted user
    if (error && error.code == kPFErrorObjectNotFound) {
        NSLog(@"User does not exist.");
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] logOut];
        return;
    }
    
    // Check if user is missing a Facebook ID
    if ([PAPUtility userHasValidFacebookData:[PFUser currentUser]]) {
        
        if (IS_DEVELOPER) {
            NSLog(@"User has valid facebook data");
        }
        // User has Facebook ID.
        
        // refresh Facebook friends on each launch
        [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(facebookRequestDidLoad:)]) {
                    [[UIApplication sharedApplication].delegate performSelector:@selector(facebookRequestDidLoad:) withObject:result];
                }
            } else {
                if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(facebookRequestDidFailWithError:)]) {
                    [[UIApplication sharedApplication].delegate performSelector:@selector(facebookRequestDidFailWithError:) withObject:error];
                }
            }
        }];
    } else {
        NSLog(@"Current user is missing their Facebook ID");
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(facebookRequestDidLoad:)]) {
                    [[UIApplication sharedApplication].delegate performSelector:@selector(facebookRequestDidLoad:) withObject:result];
                }
            } else {
                if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(facebookRequestDidFailWithError:)]) {
                    [[UIApplication sharedApplication].delegate performSelector:@selector(facebookRequestDidFailWithError:) withObject:error];
                }
            }
        }];
    }
}

-(void) presentUI {
    
    // Background
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [backgroundImageView setImage:[UIImage imageNamed:@"DefaultAnypic.png"]];
    [self.view addSubview:backgroundImageView];
    
    // emplty placeholder until I have data
    self.blankTimelineView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake( 33.0f, 96.0f, 253.0f, 173.0f);
    [button setBackgroundImage:[UIImage imageNamed:@"HomeTimelineBlank.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(inviteFriendsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.blankTimelineView addSubview:button];
    [self.view addSubview:self.blankTimelineView];
    
    // Settings button
    self.settingsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.settingsButton addTarget:self
               action:@selector(settingsButtonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
    self.settingsButton.frame = CGRectMake(200.0, 0.0, 100.0, 100.0);
    [self.view addSubview:self.settingsButton];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch ((kPAPSettingsActionSheetButtons)buttonIndex) {
        case kPAPSettingsProfile:
        {
            if (IS_DEVELOPER) NSLog(@"My profile");
            /*PAPAccountViewController *accountViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
            [accountViewController setUser:[PFUser currentUser]];
            [navController pushViewController:accountViewController animated:YES];*/
            break;
        }
        
        case kPAPSettingsTakePhoto :
        {
            if (IS_DEVELOPER) NSLog(@"Take Photo");
            break;
        }
            
        case kPAPSettingsActivity :
        {
            if (IS_DEVELOPER) NSLog(@"Activity");
            break;
        }
            
        case kPAPSettingsFindFriends:
        {
            if (IS_DEVELOPER) NSLog(@"Find Friends");
            /*PAPFindFriendsViewController *findFriendsVC = [[PAPFindFriendsViewController alloc] init];
            [navController pushViewController:findFriendsVC animated:YES];*/
            break;
        }
        case kPAPSettingsLogout:
            if (IS_DEVELOPER) NSLog(@"Logout");
            // Log out user and present the login view controller
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
            break;
        default:
            break;
    }
}

@end

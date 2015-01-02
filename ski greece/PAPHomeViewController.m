//
//  PAPHomeViewController.m
//  Anypic
//
//  Created by Héctor Ramos on 5/2/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PAPHomeViewController.h"
#import "PAPFindFriendsViewController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "PAPPhotoTimelineViewController.h"
#import "VTFindFriendsViewController.h"

@interface PAPHomeViewController ()
    @property (nonatomic, strong) UIView *blankTimelineView;

@end


@implementation PAPHomeViewController

@synthesize firstLaunch;
@synthesize blankTimelineView;


#pragma mark - UIViewController

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

- (void)inviteFriendsButtonAction:(id)sender {
    //PAPFindFriendsViewController *detailViewController = [[PAPFindFriendsViewController alloc] init];
    //[self.navigationController pushViewController:detailViewController animated:YES];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    VTFindFriendsViewController *vc=[sb instantiateViewControllerWithIdentifier:@"VTMyProfile"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
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
    
    // emplty placeholder until I have data
    self.blankTimelineView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake( 33.0f, 96.0f, 253.0f, 173.0f);
    [button setBackgroundImage:[UIImage imageNamed:@"HomeTimelineBlank.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(inviteFriendsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.blankTimelineView addSubview:button];
    //[self.view addSubview:self.blankTimelineView];
    
    //?? not fixed
}






@end

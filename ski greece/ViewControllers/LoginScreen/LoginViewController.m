//
//  LoginViewController.m
//  ski greece
//
//  Created by ignacio on 21/10/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "TrackDayMenuViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize loginFBButton=_loginFBButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([UIScreen mainScreen].bounds.size.height > 480.0f) {
        // for the iPhone 5
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLogin-568h.png"]];
    } else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLogin.png"]];
    }

    
    // Add the FB login Button
    _loginFBButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_loginFBButton addTarget:self
                       action:@selector(loginviaFB:)
             forControlEvents:UIControlEventTouchUpInside];
    [_loginFBButton setTitle:@"Login via FB" forState:UIControlStateNormal];
    _loginFBButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    //[self.view addSubview:_loginFBButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"MainScreen should open automatically");
        [self _presentMainScreenViewControllerAnimated:NO];
    }
}

#pragma mark -
#pragma mark Login

-(void) loginviaFB:(UIButton*)button
{
    NSLog(@"Login in via FB.");
    
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        //[_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                NSLog(@"User with facebook logged in!");
            }
            [self _presentMainScreenViewControllerAnimated:YES];
        }
    }];
    
    //[_activityIndicator startAnimating]; // Show loading indicator until login is finished
}



#pragma mark -
#pragma mark OpenMainScreen

- (void)_presentMainScreenViewControllerAnimated:(BOOL)animated {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    TrackDayMenuViewController *vc = [sb instantiateViewControllerWithIdentifier:@"OpenScreen"];
    [self presentViewController:vc animated:animated completion:nil];

}
@end

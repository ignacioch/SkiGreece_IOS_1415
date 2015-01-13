//
//  LoginScreen.m
//  Ski Greece
//
//  Created by VimaTeamGr on 8/15/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "LoginScreen.h"
#import "API.h"
#include <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"

#define kSalt @"adlfu3489tyh2jnkLIUGI&%EV(&0982cbgrykxjnk8855"

@interface LoginScreen ()

@end

@implementation LoginScreen
{
    MBProgressHUD *hud;
    /*FBLogin happens without salted password -use as password the facebook Id*/
    __block NSString * fbusername;
    __block NSString * fbpassword;

}

@synthesize fldPassword=_fldPassword;
@synthesize fldUsername=_fldUsername;
@synthesize delegate = _delegate;


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
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.fldPassword action:@selector(resignFirstResponder)];
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:gestureRecognizer];
    
    /*UITapGestureRecognizer *gestureRecognizer_usr = [[UITapGestureRecognizer alloc] initWithTarget:self.fldUsername action:@selector(resignFirstResponder)];
	gestureRecognizer_usr.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:gestureRecognizer_usr];*/
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud hide:YES];
    
    self.fldUsername.returnKeyType = UIReturnKeyNext;  // in viewDidLoad
    self.fldPassword.delegate=self;
    self.fldUsername.delegate=self;

    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        
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
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fbLogin:(id)sender {
   
    hud.labelText = @"Logging in";
    [hud show:YES];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // To-do, show logged in view
        if (FBSession.activeSession.isOpen) {
            NSLog(@"FBSession is open. Will populate user details.");
        } else {
            NSLog(@"Session is not open");
            NSLog(@"There is token for session - I need to call OpenSession");
            /*AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate openSession];*/
            [self openSession];
        }
    } else {
        // No, display the login page.
        NSLog(@"There isn't token for session - I need to call OpenSession");
        /*AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate openSession];*/
        [self openSession];
    }
    
 
    
    
}

-(void) FBloginUser:(NSString*)user withPass:(NSString*)password
{
    NSLog(@"FB username: %@",user);
    NSLog(@"FB password: %@",password);
    
    /*first check if the user is logged in*/
    
    /*if yes, log him in, else register him first*/
    
    
    
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"register", @"command",
                                  user, @"username",
                                  password, @"password",
                                  nil];
    
    //make the call to the web API
    [[API sharedInstance] commandWithParams:params
                               onCompletion:^(NSDictionary *json) {
                                   //handle the response
                                   //result returned
                                   NSDictionary* res = [[json objectForKey:@"result"] objectAtIndex:0];
                                   NSLog(@"result is:%@",res);
                                   if ([json objectForKey:@"error"]==nil && [[res objectForKey:@"IdUser"] intValue]>0) {
                                       [hud hide:YES];
                                       
                                       [[API sharedInstance] setUser: res];
                                       
                                       [self.delegate loginScreenCompleted:self];
                                       
                                       //show message to the user
                                       [[[UIAlertView alloc] initWithTitle:@"Logged in"
                                                                   message:[NSString stringWithFormat:@"Καλώς ήρθες %@ στο πρώτο social αποκλειστικά για ski/snowboard!",[res objectForKey:@"username"] ]
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Close"
                                                         otherButtonTitles: nil] show];
                                       
                                   } else {
                                       //error
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
                                                                      NSLog(@"result is:%@",res);
                                                                      if ([json objectForKey:@"error"]==nil && [[res objectForKey:@"IdUser"] intValue]>0) {
                                                                          [hud hide:YES];
                                                                          
                                                                          [[API sharedInstance] setUser: res];
                                                                          
                                                                          [self.delegate loginScreenCompleted:self];
                                                                          
                                                                          //show message to the user
                                                                          [[[UIAlertView alloc] initWithTitle:@"Logged in"
                                                                                                      message:[NSString stringWithFormat:@"Καλώς ήρθες %@ στο πρώτο social αποκλειστικά για ski/snowboard!",[res objectForKey:@"username"] ]
                                                                                                     delegate:nil
                                                                                            cancelButtonTitle:@"Close"
                                                                                            otherButtonTitles: nil] show];
                                                                          
                                                                      } else {
                                                                          [hud hide:YES];
                                                                          
                                                                          NSLog(@"Error message:%@",[json objectForKey:@"error"]);
                                                                          UIAlertView *message = [[UIAlertView alloc]
                                                                                                  initWithTitle:@"Error"
                                                                                                  message:@"Αδυναμία σύνδεσης! Παρακαλούμε ξαναδοκιμάστε!"
                                                                                                  delegate:nil
                                                                                                  cancelButtonTitle:@"OK"
                                                                                                  otherButtonTitles:nil];
                                                                          [message show];
                                                                      }
                                                                  }];
                                   }
                               }];
}
- (IBAction)btnLoginTapped:(id)sender {
    [self registerOrLogin:2];
    return;
}

- (IBAction)btnRegisterTapped:(id)sender {
    [self registerOrLogin:1];
    return;
}

-(void) registerOrLogin:(int)flag
{
    [hud show:YES];
    
    //form fields validation
    if (_fldUsername.text.length < 4 || _fldPassword.text.length < 4) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Ο κωδικός και το όνομα χρήστη πρέπει να είναι μεγαλύτερα από 4 χαρακτήρες!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        NSLog(@"I should return now");
        return;
    }
    
    //salt the password
    NSString* saltedPassword = [NSString stringWithFormat:@"%@%@", _fldPassword.text, kSalt];
    
    //prepare the hashed storage
    NSString* hashedPassword = nil;
    unsigned char hashedPasswordData[CC_SHA1_DIGEST_LENGTH];
    
    //hash the pass
    NSData *data = [saltedPassword dataUsingEncoding: NSUTF8StringEncoding];
    if (CC_SHA1([data bytes], [data length], hashedPasswordData)) {
        hashedPassword = [[NSString alloc] initWithBytes:hashedPasswordData length:sizeof(hashedPasswordData) encoding:NSASCIIStringEncoding];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Ο κωδικός δεν στάλθηκε επιτυχώς! Παρακαλούμε ξαναδοκιμάστε!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    
    NSLog(@"hashedPasswod:%@",hashedPassword);
    
    //check whether it's a login or register
    NSString* command = (flag==1)?@"register":@"login";
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  command, @"command",
                                  _fldUsername.text, @"username",
                                  hashedPassword, @"password",
                                  nil];
    //make the call to the web API
    [[API sharedInstance] commandWithParams:params
                               onCompletion:^(NSDictionary *json) {
                                   //handle the response
                                   //result returned
                                   NSDictionary* res = [[json objectForKey:@"result"] objectAtIndex:0];
                                   NSLog(@"result is:%@",res);
                                   if ([json objectForKey:@"error"]==nil && [[res objectForKey:@"IdUser"] intValue]>0) {
                                       [hud hide:YES];
                                       
                                       [[API sharedInstance] setUser: res];
                                       
                                       [self.delegate loginScreenCompleted:self];
                                       
                                       //show message to the user
                                       [[[UIAlertView alloc] initWithTitle:@"Logged in"
                                                                   message:[NSString stringWithFormat:@"Welcome %@",[res objectForKey:@"username"] ]
                                                                  delegate:nil 
                                                         cancelButtonTitle:@"Close" 
                                                         otherButtonTitles: nil] show];
                                       
                                   } else {
                                       //error
                                       [hud hide:YES];
                                       
                                       NSLog(@"Error message:%@",[json objectForKey:@"error"]);
                                       UIAlertView *message = [[UIAlertView alloc]
                                        initWithTitle:@"Error"
                                        message:@"Αδυναμία σύνδεσης! Παρακαλούμε ξαναδοκιμάστε!"
                                        delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
                                       [message show];
                                   }
                               }];
    
    
    
    
}
- (IBAction)goBack:(id)sender {
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.delegate loginScreenCompleted:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.fldUsername) {
		[self.fldUsername resignFirstResponder];
		[self.fldPassword becomeFirstResponder];
	}
	else if (textField == self.fldPassword) {
		[self.fldPassword resignFirstResponder];
	}
	return YES;
}

#pragma mark - facebook functions

- (void)openSession
{
    NSLog(@"Open Session Called");
/*    [FBSession openActiveSessionWithReadPermissions:nil
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
         
     }];*/
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


@end

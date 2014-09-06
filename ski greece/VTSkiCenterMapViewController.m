//
//  VTSkiCenterMapViewController.m
//  Ski Greece
//
//  Created by VimaTeamGr on 8/11/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "VTSkiCenterMapViewController.h"
#import "VTSkiCenter.h"
#import "VTSkiCenterMapOverlay.h"
#import "SkiCenterMapOverlayView.h"
#import "LoginScreen.h"
#import "API.h"
#import "UIAlertView+error.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "API.h"

#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define HAVE_CUSTOM_ROUTES  NO

@interface VTSkiCenterMapViewController ()



@end

@implementation VTSkiCenterMapViewController
{
    CGRect keyboardFrameBeginRect;
}

@synthesize skiCenterCustomMap=_skiCenterCustomMap;
@synthesize park=_park;
@synthesize mapTypeSegmentedControl=_mapTypeSegmentedControl;
@synthesize routesCovered=_routesCovered;
@synthesize postToCommunityText=_postToCommunityText;
@synthesize totalDistance=_totalDistance;
@synthesize totalSpeed=_totalSpeed;
@synthesize totalTime=_totalTime;

@synthesize centerLocation=_centerLocation;
@synthesize originalCenter=_originalCenter;

@synthesize maxSpeed=_maxSpeed;
@synthesize time=_time;

@synthesize topBar=_topBar;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"VT map controller instantiated");
        _routesCovered=[NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"MapView: Routes Completed:%d",[_routesCovered count]);
    NSLog(@"MapVuew : items to be on a map: %d",[self.pointOnMap count]);

    
    MKCoordinateRegion region;
    
    if ([self.pointOnMap count]==0) {
        CGPoint midCoordinate = CGPointFromString(@"{39.074208,21.824312}");
        CLLocationCoordinate2D _midCoordinate = CLLocationCoordinate2DMake(midCoordinate.x, midCoordinate.y);
        region = MKCoordinateRegionMakeWithDistance(_midCoordinate, 500000, 500000);
        region = [self.skiCenterCustomMap regionThatFits:region];
    } else {
        region = MKCoordinateRegionMakeWithDistance(_centerLocation, 500, 500);
        region = [self.skiCenterCustomMap regionThatFits:region];
    }
    [self.skiCenterCustomMap setRegion:region animated:YES];
    
    
    [self.skiCenterCustomMap removeAnnotations:self.skiCenterCustomMap.annotations];
    [self.skiCenterCustomMap removeOverlays:self.skiCenterCustomMap.overlays];
    
    /*placeholder*/
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.postToCommunityText action:@selector(resignFirstResponder)];
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:gestureRecognizer];

    //REMOVE FOR DEMO
    self.totalSpeed.text = [NSString stringWithFormat:@"%@",_maxSpeed];
    self.totalTime.text = [NSString stringWithFormat:@"%@",_time];
    self.totalDistance.text =self.distance;
    
    [self calculateDistanceCovered];
    
    
    //[self addOverlay]; //this one adds the custom image for the park
    
    //add the routes for the covered routes  -- UNCOMMENT THAT FOR THE PLACES THAT WE HAVE THE DATA
    if (HAVE_CUSTOM_ROUTES) {
        for (int i=0;i<[_routesCovered count];i++)
        {
            NSLog(@"Adding route with number:%@",(NSString*)_routesCovered[i]);
            [self addRoute:@"Kalavryta" routeNumber:(NSString*)_routesCovered[i]];
        }
    } else {
        NSLog(@"There are no custom routes enabled");
        
        NSInteger pointsCount = [self.pointOnMap count];
        
        
        CLLocationCoordinate2D pointsToUse[pointsCount];
        
        for(int i = 0; i < pointsCount; i++) {
            CLLocation *loc = (CLLocation*)[self.pointOnMap objectAtIndex:i];
            //CGPoint p = CGPointMake
            //CGPoint p = CGPointFromString(pointsArray[i]);
            //pointsToUse[i] = CLLocationCoordinate2DMake(p.x,p.y);
            pointsToUse[i] = loc.coordinate;
        }
        
        MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
        
        [self.skiCenterCustomMap addOverlay:myPolyline];
    }
    
    
    
    [self.totalDistance setTextColor:[UIColor colorWithRed:(0/255.f) green:(160/255.f) blue:(203/255.f) alpha:1.0f]];
    [self.totalDistance setFont:[UIFont fontWithName:@"Myriad Pro" size:16.0f]];
    
    [self.totalSpeed setTextColor:[UIColor colorWithRed:(0/255.f) green:(160/255.f) blue:(203/255.f) alpha:1.0f]];
    [self.totalSpeed setFont:[UIFont fontWithName:@"Myriad Pro" size:16.0f]];
    
    [self.totalTime setTextColor:[UIColor colorWithRed:(0/255.f) green:(160/255.f) blue:(203/255.f) alpha:1.0f]];
    [self.totalTime setFont:[UIFont fontWithName:@"Myriad Pro" size:16.0f]];
    
    self.postToCommunityText.delegate = self;
    
    self.originalCenter = self.view.center;

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationMethod:) name:UIKeyboardDidShowNotification object:nil];
    
    
    /*code for topBar*/
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.topBar.tintColor = [UIColor colorWithRed:(163/255.f) green:(163/255.f) blue:(163/255.f) alpha:1.0f];
    } else {
        self.topBar.barTintColor = [UIColor colorWithRed:(163/255.f) green:(163/255.f) blue:(163/255.f) alpha:1.0f];
        //TO DO ADD CODE FOR IOS 7.0
    }
    
    UINavigationItem *buttonCarrier = [[UINavigationItem alloc]initWithTitle:@""];
    
    buttonCarrier.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"skigreece_topbar_logo.png"]];
    
    //Creating some buttons:
    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    
    
    //Putting the Buttons on the Carrier
    [buttonCarrier setLeftBarButtonItem:barBackButton];
    
    //The NavigationBar accepts those "Carrier" (UINavigationItem) inside an Array
    NSArray *barItemArray = [[NSArray alloc]initWithObjects:buttonCarrier,nil];
    
    // Attaching the Array to the NavigationBar
    [self.topBar setItems:barItemArray];
    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        
        /*self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_with_back_5.png"]];*/
        

        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            if (subview.tag == 10) {                // 10 is the map
                subview.frame = CGRectMake(subview.frame.origin.x, 64.0f, subview.frame.size.width, 257.0f + OFFSET_5);
            } else  if (subview.tag != 99) {  // 99 is the topBar
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + OFFSET_5, subview.frame.size.width, subview.frame.size.height);
            } else {
                subview.frame = CGRectMake(subview.frame.origin.x, 20.0f, subview.frame.size.width, subview.frame.size.height);
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
    
    NSLog(@"Distance to be added - %d .",(int)self.distanceInt);
    
    if ([API sharedInstance].isAuthorized){
        NSLog(@"User is logged in - Will update data");
        [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 @"updateKm",@"command",
                                                 [NSString stringWithFormat:@"%d",[API sharedInstance].getUserid], @"IdUser",
                                                 [NSString stringWithFormat:@"%d",(int)self.distanceInt],@"value",
                                                 nil]
                                   onCompletion:^(NSDictionary *json) {
                                       
                                       //completion
                                       if (![json objectForKey:@"error"]) {
                                           NSLog(@"Km's updated");
                                       }
                                       
                                   }];
    }
    
    //make the map geophysical
    self.skiCenterCustomMap.mapType = MKMapTypeHybrid;

    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSkiCenterCustomMap:nil];
    [self setMapTypeSegmentedControl:nil];
    [super viewDidUnload];
}

- (IBAction)backButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) goBack
{
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.delegate MapScreenCompleted:self];
}

- (IBAction)mapTypeChanged:(id)sender {
    switch (self.mapTypeSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.skiCenterCustomMap.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.skiCenterCustomMap.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.skiCenterCustomMap.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}

-(void) calculateDistanceCovered
{
    // Calculate Covered Distance based on the routes
}

- (IBAction)shareWithEmail:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"MapScreenshot"];
        /*NSArray *toRecipients = [NSArray arrayWithObjects:@"ign_ch@hotmail.com", nil];
        [mailer setToRecipients:toRecipients];*/
        UIImage *myImage = [self createUIImagefromMapView:self.skiCenterCustomMap];
        NSData *imageData = UIImagePNGRepresentation(myImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"SkiGreeceTracking"];
        NSString *emailBody = @"Image taken from Map";
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Η συσκευή σας δεν είναι ρυθμισμένη ώστε να στέλνει μαιλ."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)postToCommunityAction:(id)sender
{
    if([self.postToCommunityText isEditing]) {
        NSLog(@"Focus is on textfield");
        [self.postToCommunityText resignFirstResponder];
    }
    
    if (![[API sharedInstance] isAuthorized]) {
        NSLog(@"I should Open login screen");
        
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LoginScreen *vc = [sb instantiateViewControllerWithIdentifier:@"CommunityLogin"];
        vc.delegate=self;
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];
    } else {
        UIImage *myImage = [self createUIImagefromMapView:self.skiCenterCustomMap];
        [self uploadPhoto:myImage];
    }

}

- (IBAction)postTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"Μόλις έκανα %@ στο βούνο. #Ski Greece IOs App",self.distance]];
        UIImage *myImage = [self createUIImagefromMapView:self.skiCenterCustomMap];
        [tweetSheet addImage:myImage];
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result){
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                case SLComposeViewControllerResultDone:
                default:
                    self.view.center = self.originalCenter;
                    [self.view endEditing:YES];
                    break;
            }
        }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"Δεν μπορείτε να ποστάρετε αυτή την στιγμή. Βεβαιωθείτε ότι είστε συνδεδεμένοι και ότι έχετε ένα λογαριασμό twitter στις ρυθμίσεις σας."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }

}

- (IBAction)postFB:(id)sender {
    //Ask for publish_actions permissions in context
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // Permission hasn't been granted, so ask for publish_actions
        NSLog(@"I should ask for permissions");
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceFriends
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             if (FBSession.activeSession.isOpen && !error) {
                                                 // Publish the story if permission was granted
                                                 [self publishStory];
                                             }
                                         }];
    } else {
        // If permissions present, publish the story
        if (!FBSession.activeSession.isOpen) {
            [FBSession openActiveSessionWithAllowLoginUI: YES];
        } else {
            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate openSession];
        }
        NSLog(@"I will just post to Facebook");
        [self publishStory];
    }
}

- (void)publishStory
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Posting photo...";
    [hud show:YES];
    
    UIImage *myImage = [self createUIImagefromMapView:self.skiCenterCustomMap];
    
    NSData *imageData= UIImagePNGRepresentation(myImage);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"Μόλις έγραψα %@ στο βουνο, σε %@ με την εφαρμογη Ski Greece για iOS. Μπορεις να κάνεις παραπάνω?",self.totalDistance.text, self.totalTime.text], @"name",@"Ski Greece Track Your Day",@"description", [NSString stringWithFormat:@"Μόλις έγραψα %@ στο βουνο, σε %@ με την εφαρμογη Ski Greece για iOS. Μπορεις να κάνεις παραπάνω?",self.totalDistance.text, self.totalTime.text],@"message", imageData, @"source", nil];
    
    [FBRequestConnection startWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         NSString *alertText;
         if (error) {
             NSLog(@"%@", error);
             alertText = [NSString stringWithFormat:
                          @"Operation could not be completed. Check your connection or contact vimateamgr@gmail.com if problem remains"];
             [[[UIAlertView alloc] initWithTitle:@"Error" message:alertText delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil]show];
         }
         [hud hide:YES];
     }];
}

- (void)addOverlay {
    VTSkiCenterMapOverlay *overlay = [[VTSkiCenterMapOverlay alloc] initWithPark:self.park];
    [self.skiCenterCustomMap addOverlay:overlay];
}

- (void)addRoute :(NSString*)skiCenter routeNumber:(NSString*)number {
    NSString *thePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@Route%@",skiCenter,number] ofType:@"plist"];
    NSArray *pointsArray = [NSArray arrayWithContentsOfFile:thePath];
    
    NSInteger pointsCount = pointsArray.count;
    
    CLLocationCoordinate2D pointsToUse[pointsCount];
    
    for(int i = 0; i < pointsCount; i++) {
        CGPoint p = CGPointFromString(pointsArray[i]);
        pointsToUse[i] = CLLocationCoordinate2DMake(p.x,p.y);
    }
    
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
    
    [self.skiCenterCustomMap addOverlay:myPolyline];
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:VTSkiCenterMapOverlay.class]) {
        NSLog(@"overlay played");
        UIImage *magicMountainImage = [UIImage imageNamed:@"overlay_image"];
        SkiCenterMapOverlayView *overlayView = [[SkiCenterMapOverlayView alloc] initWithOverlay:overlay overlayImage:magicMountainImage];        
        return overlayView;
    } else if ([overlay isKindOfClass:MKPolyline.class]) {
        NSLog(@"Polyline added");
        MKPolylineView *lineView = [[MKPolylineView alloc] initWithOverlay:overlay];
        lineView.strokeColor = [UIColor greenColor];
        return lineView;
    }
    
    return nil;
}


-(UIImage*)createUIImagefromMapView:(MKMapView*)mapView  //untested
{
    UIGraphicsBeginImageContext(mapView.frame.size);
    [mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *mapImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return mapImage;
}

#pragma mark - MFMailComposeDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -Login Screen Delegate
- (void)loginScreenCompleted:(LoginScreen *)controller
{
	[self dismissViewControllerAnimated:NO completion:nil];
}

//functions for upload phot
-(void) uploadPhoto:(UIImage*)photo
{
    //spinner startAnimating];
    
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"upload",@"command",
                                             UIImageJPEGRepresentation(photo,70),@"file",
                                             self.postToCommunityText.text, @"title",
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   
                                   //completion
                                   if (![json objectForKey:@"error"]) {
                                       
                                       //[spinner stopAnimating];
                                       
                                       //success
                                       [[[UIAlertView alloc]initWithTitle:@"Success!"
                                                                  message:@"Your photo is uploaded"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Yay!"
                                                        otherButtonTitles: nil] show];
                                       
                                       //add delegate for going back after the image is uploaded
                                       //[self.delegate photoScreenCompleted:self];
                                       
                                       
                                   } else {
                                       //error, check for expired session and if so - authorize the user
                                       NSString* errorMsg = [json objectForKey:@"error"];
                                       [UIAlertView error:errorMsg];
                                       
                                       if ([@"Authorization required" compare:errorMsg]==NSOrderedSame) {
                                           UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                                           LoginScreen *vc = [sb instantiateViewControllerWithIdentifier:@"CommunityLogin"];
                                           vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                                           [self presentViewController:vc animated:YES completion:NULL];
                                       }
                                   }
                                   
                               }];
}

- (void)myNotificationMethod:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    NSLog(@"Size is:%f",keyboardFrameBeginRect.size.height);
    
    self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y - keyboardFrameBeginRect.size.height);
}

#pragma mark - textField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    /* keyboard is visible, move views */
    //NSLog(@"textViewDidBeginEditing:");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /* resign first responder, hide keyboard, move views */
    //NSLog(@"textViewDidEndEditing:");
    self.view.center = self.originalCenter;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end

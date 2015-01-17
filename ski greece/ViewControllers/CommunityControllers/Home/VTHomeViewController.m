//
//  VTHomeViewController.m
//  ski greece
//
//  Created by ignacio on 10/11/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import "VTHomeViewController.h"
#import "AppDelegate.h"
#import "PAPEditPhotoViewController.h"
#import "PAPSettingsActionSheetDelegate.h"
#import "PAPSettingsButtonItem.h"
#import "MBProgressHUD.h"
#import "VTFindFriendsViewController.h"
#import "VTActivityViewController.h"
//#import "PAPAccountViewController.h
#import "VTEditPhotoViewController.h"
#import "VTMyProfileViewController.h"
#import "PAPLogInViewController.h"

#define CONTAINER_Y_IPHONE_4 60.0f
#define CONTAINER_Y_IPHONE_5 52.0f
#define CONTAINER_Y_IPHONE_6 64.0f

#define BOTTOM_BAR_HEIGHT    60.0f


@interface VTHomeViewController ()

@property (nonatomic, strong) UIView *blankTimelineView;
@property (nonatomic, strong) PAPSettingsActionSheetDelegate *settingsActionSheetDelegate;
@property (nonatomic, strong) MBProgressHUD *hud;


@end

typedef enum {
    kPAPSettingsProfile = 0,
    kPAPSettingsFindFriends,
    kPAPSettingsLogout,
    kPAPSettingsNumberOfButtons
} kPAPSettingsActionSheetButtons;


@implementation VTHomeViewController
{
    NSMutableData *_data;
}

@synthesize settingsActionSheetDelegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Do your resizing
    
    self.backgroundImg.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height);
    self.backgroundImg.image = [UIImage imageNamed:@"backgroundFromPSD@2x.png"];

    
    self.navigationBar.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height, SCREEN_WIDTH, self.navigationBar.frame.size.height);
    self.bottomBar.frame = CGRectMake(0.0f, SCREEN_HEIGHT - self.bottomBar.frame.size.height, SCREEN_WIDTH, self.bottomBar.frame.size.height);
    // container view is contained between the two bars
    self.containerView.frame = CGRectMake(0.0, self.navigationBar.frame.origin.y + self.navigationBar.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - self.navigationBar.frame.origin.y - self.navigationBar.frame.size.height - self.bottomBar.frame.size.height );
    self.backButton.frame = CGRectMake(0.0f, self.navigationBar.frame.origin.y, self.backButton.frame.size.width,self.navigationBar.frame.size.height);
    self.settingsButton.frame = CGRectMake(SCREEN_WIDTH - self.settingsButton.frame.size.width, self.navigationBar.frame.origin.y, self.settingsButton.frame.size.width,self.navigationBar.frame.size.height);
    self.takePhotoBtn.frame = CGRectMake(SCREEN_WIDTH * 1 / 3, self.bottomBar.frame.origin.y, SCREEN_WIDTH /3, self.bottomBar.frame.size.height);
    self.activityButton.frame = CGRectMake(SCREEN_WIDTH * 2 / 3, self.bottomBar.frame.origin.y, SCREEN_WIDTH /3, self.bottomBar.frame.size.height);
    self.homeButton.frame = CGRectMake(0.0f, self.bottomBar.frame.origin.y, SCREEN_WIDTH /3, self.bottomBar.frame.size.height);
    
    
    // Download user's profile picture
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:kPAPUserFacebookIDKey]]];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
    [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
    
    
    
    
    
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        imgView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:imgView];
    }
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // opening login screen
    if (![PFUser currentUser]) {
        //?? FIXME - we also need a toast message in here
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Facebook Login Required"
                                                         message:@"Για να χρησιμοποιήσετε το community, παρακαλούμε πολύ συνδεθείτε πρώτα."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
        [self openLoginScreen];
        return;
    }
    
    // after the layout is computed we init the child controller
    if ([PFUser currentUser]) {
        AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        PAPHomeViewController *vc = del.homeViewController;
        vc.view.frame = self.containerView.bounds;
        [self.containerView addSubview:vc.view];
        [self.containerView setBackgroundColor:[UIColor clearColor]];
        [self addChildViewController:vc];
    }

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)settingsButtonAction:(id)sender {
    self.settingsActionSheetDelegate = [[PAPSettingsActionSheetDelegate alloc] initWithNavigationController:self.navigationController];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"My Profile",@"Find Friends",@"Log Out", nil];
    actionSheet.tag = 0 ;
    [actionSheet showInView:self.view];
}

- (IBAction)takePhotoAction:(id)sender {
    [self takePhoto];
}

- (IBAction)activityAction:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    VTActivityViewController *vc=[sb instantiateViewControllerWithIdentifier:@"VTActivity"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}

-(void) openLoginScreen
{
    if (IS_DEVELOPER) NSLog(@"Showing login screen");
    PAPLogInViewController *loginViewController = [[PAPLogInViewController alloc] init];
    [loginViewController setDelegate:self];
    loginViewController.fields = PFLogInFieldsFacebook;
    loginViewController.facebookPermissions = @[ @"user_about_me" ];
    loginViewController.skippedButton = NO ;
    [self presentViewController:loginViewController animated:YES completion:NULL];
}

#pragma mark - takePhoto function

-(void) takePhoto
{
    BOOL cameraDeviceAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    if (cameraDeviceAvailable && photoLibraryAvailable) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
    } else {
        // if we don't have at least two options, we automatically show whichever is available (camera or roll)
        [self shouldPresentPhotoCaptureController];
    }
}

- (BOOL)shouldStartCameraController {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}


- (BOOL)shouldStartPhotoLibraryPickerController {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    VTEditPhotoViewController *vc=[sb instantiateViewControllerWithIdentifier:@"VTEditPhoto"];
    vc.image = image;
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
    
}




#pragma mark - PresentPhotoCapture

- (BOOL)shouldPresentPhotoCaptureController {
    BOOL presentedPhotoCaptureController = [self shouldStartCameraController];
    
    if (!presentedPhotoCaptureController) {
        presentedPhotoCaptureController = [self shouldStartPhotoLibraryPickerController];
    }
    
    return presentedPhotoCaptureController;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 0) {
        switch ((kPAPSettingsActionSheetButtons)buttonIndex) {
            case kPAPSettingsProfile:
            {
                if (IS_DEVELOPER) NSLog(@"My profile");
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                VTMyProfileViewController *vc=[sb instantiateViewControllerWithIdentifier:@"VTMyProfile"];
                vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:vc animated:YES completion:NULL];
                //PAPAccountViewController *accountViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
                //[accountViewController setUser:[PFUser currentUser]];
                //[self presentViewController:accountViewController animated:YES completion:NULL];
                break;
            }
                
            case kPAPSettingsFindFriends:
            {
                if (IS_DEVELOPER) NSLog(@"Find Friends");
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                VTFindFriendsViewController *vc=[sb instantiateViewControllerWithIdentifier:@"VTFindFriends"];
                vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:vc animated:YES completion:NULL];
                /*PAPFindFriendsViewController *findFriendsVC = [[PAPFindFriendsViewController alloc] init];
                 [navController pushViewController:findFriendsVC animated:YES];*/
                break;
            }
            case kPAPSettingsLogout:
                if (IS_DEVELOPER) NSLog(@"Logout");
                // Log out user and present the login view controller
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
            default:
                break;
        }
    } else if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            [self shouldStartCameraController];
        } else if (buttonIndex == 1) {
            [self shouldStartPhotoLibraryPickerController];
        }
    }
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [PAPUtility processFacebookProfilePictureData:_data];
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


@end

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
//#import "PAPAccountViewController.h"


@interface VTHomeViewController ()

@property (nonatomic, strong) UIView *blankTimelineView;
@property (nonatomic, strong) PAPSettingsActionSheetDelegate *settingsActionSheetDelegate;

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
    
    
    //(AppDelegate*)[[UIApplication sharedApplication].delegate].homeViewController;
    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    PAPHomeViewController *vc = del.homeViewController;
    vc.view.frame = self.containerView.bounds;
    [self.containerView addSubview:vc.view];
    [self.containerView setBackgroundColor:[UIColor clearColor]];
    [self addChildViewController:vc];
    
    if (IS_DEVELOPER){
        NSLog(@"Container is loaded");
        NSLog(@"ContainerView. X : %f Y:%f Height :%f Width : %f",self.containerView.frame.origin.x,self.containerView.frame.origin.y,self.containerView.frame.size.height,self.containerView.frame.size.width);
    }
    
    
    CGFloat startingPoint_iphone5   = 60.0f ;
    CGFloat bottomBar_iphone5       = 60.0f ;
    CGFloat startingPoint_iphone4   = 50.0f ;
    CGFloat bottomBar_iphone4       = 51.0f ;
    CGFloat startingPoint_iphone6   = 60.0f ;
    CGFloat bottomBar_iphone6       = 60.0f ;
    
    CGFloat startingPoint = startingPoint_iphone4;
    CGFloat bottomBar = bottomBar_iphone4;

    if (IS_IPHONE_4_OR_LESS) {
        NSLog(@"iPhone4");
        startingPoint = startingPoint_iphone4;
        bottomBar  = bottomBar_iphone4;
    } else if (IS_IPHONE_5) {
        NSLog(@"iPhone5");
        startingPoint = startingPoint_iphone5;
        bottomBar  = bottomBar_iphone5;
    } else if (IS_IPHONE_6) {
        NSLog(@"iPhone6");
        startingPoint = startingPoint_iphone6;
        bottomBar  = bottomBar_iphone6;
    }
    
    // get device height
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat containerHeight = screenHeight - startingPoint - bottomBar;
    
    // Do your resizing
    // adjust tableView frame
    self.containerView.frame = CGRectMake(0.0, startingPoint, self.containerView.frame.size.width,containerHeight);
    if (IS_DEVELOPER) {
        NSLog(@"containerView after changes");
        NSLog(@"containerView. X : %f Y:%f Height :%f Width : %f",self.containerView.frame.origin.x,self.containerView.frame.origin.y,self.containerView.frame.size.height,self.containerView.frame.size.width);
    }
    
    // Download user's profile picture
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:kPAPUserFacebookIDKey]]];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
    [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
    
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



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
    
    PAPEditPhotoViewController *viewController = [[PAPEditPhotoViewController alloc] initWithImage:image];
    [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    NSLog(@"Switching to the edit photo view controller");
    [self presentViewController:viewController animated:YES completion:NULL];
    
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
                VTFindFriendsViewController *vc=[sb instantiateViewControllerWithIdentifier:@"VTMyProfile"];
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

@end

//
//  UserProfile.m
//  Ski Greece
//
//  Created by VimaTeamGr on 8/31/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "UserProfile.h"
#import "API.h"
#import "UIAlertView+error.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"

@interface UserProfile ()

@end

@implementation UserProfile
{
    NSMutableData *imageData;
}

@synthesize delegate = _delegate;
@synthesize profilePicture=_profilePicture;
@synthesize fbLoginLabel=_fbLoginLabel;
@synthesize stat1label=_stat1label;
@synthesize stat2label=_stat2label;
@synthesize stat3label=_stat3label;
@synthesize stats1value=_stats1value;
@synthesize stat2value=_stat2value;
@synthesize stat3value=_stat3value;


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
    [self.profilePicture setImage:[self loadImage]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7, subview.frame.size.width, subview.frame.size.height);
        }
    }
    
    [self.fbLoginLabel sizeToFit];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        imgView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:imgView];
    }
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    /*hide the 3rd item*/
    self.stat3value.hidden = YES;
    self.stat3label.hidden = YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToStream:(id)sender {
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.delegate userReturns:self withImage:_profilePicture.image];
}

- (IBAction)logoutUser:(id)sender {
     [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                              @"logout",@"command",
                                              nil]
                                onCompletion:^(NSDictionary *json) {
                                    //logged out from server
                                    [API sharedInstance].user = nil;
                                    //call delegate for going back
                                    [self.delegate userLoggedOut:self];

     }];

}
- (IBAction)getitFromFB:(id)sender {
    
    __block MBProgressHUD *hud;

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading Image";
    [hud show:YES];
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    if (FBSession.activeSession.isOpen) {
        NSLog(@"Will request the profile image");
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 //[self setProfileFromFB:user.id];
                 NSString *imageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=120&height=160", user.id];
                 NSURL *url = [NSURL URLWithString:imageUrl];
                 
                 [self.profilePicture setImageWithURLRequest:[NSURLRequest requestWithURL:url]
                                   placeholderImage:[UIImage imageNamed:@"profile.jpg"]
                                            success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ){
                                                NSLog(@"Loaded successfully: %d", [response statusCode]);
                                                [hud hide:YES];
                                                [weakSelf.profilePicture setImage:image];
                                                [weakSelf saveImageIntoServer:image];
                                                
                                            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                NSLog(@"failed loading: %@", error);
                                                [hud hide:YES];
                                            }
                  ];
                 //[self.profilePicture setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"profile.jpg"]];
             }
         }];
    }

}


- (IBAction)setProfilePic:(id)sender {
    //show the app menu
    [[[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle:@"Close"
                   destructiveButtonTitle:nil
                        otherButtonTitles:@"Take photo", @"Choose from library", nil]
     showInView:self.view];
}

#pragma mark ActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self takePhoto]; break;
        case 1:
            [self choosePhoto];break;
    }
}


-(void) takePhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //imagePickerController.editing = YES;
    imagePickerController.allowsEditing=YES;
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

-(void) choosePhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.editing = YES;
    //imagePickerController.delegate = (id)self;
    imagePickerController.delegate = self;

    
    [self presentViewController:imagePickerController animated:YES completion:NULL];
    
}

#pragma mark - Image picker delegate methdos
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    [self saveImageIntoServer:[info objectForKey:UIImagePickerControllerOriginalImage]];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:NULL];
}


- (void)saveImageIntoServer: (UIImage*)image
{
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"uploadProfilePhoto",@"command",
                                             UIImageJPEGRepresentation(image,70),@"file",
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   
                                   //completion
                                   if (![json objectForKey:@"error"]) {
                                                                              
                                       //success
                                       /*[[[UIAlertView alloc]initWithTitle:@"Success!"
                                                                  message:@"Your photo is uploaded"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Yay!"
                                                        otherButtonTitles: nil] show];*/
                                       
                                       //update profile picture once it is uploaded
                                       [self.profilePicture setImage:image];
                                       
                                   } else {
                                       //error, check for expired session and if so - authorize the user
                                       NSString* errorMsg = [json objectForKey:@"error"];
                                       [UIAlertView error:errorMsg];
                                   }
                                   
                               }];
}



- (IBAction)backButton:(id)sender {
    [self.delegate userReturns:self withImage:_profilePicture.image];
}

- (UIImage*)loadImage
{
    NSLog(@"Trying to fetch:%@",[NSString stringWithFormat:@"http://www.vimateam.gr/projects/skigreece/community/profiles/%d.jpg",[API sharedInstance].getUserid]);
    UIImage* image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.vimateam.gr/projects/skigreece/community/profiles/%d.jpg",[API sharedInstance].getUserid]]]];
    return image;
}

#pragma mark - facebook functions



@end

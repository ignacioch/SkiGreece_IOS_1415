//
//  StreamScreen.h
//  Ski Greece
//
//  Created by VimaTeamGr on 8/15/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoScreen.h"
#import "LoginScreen.h"
#import "UserProfile.h"
#import "StreamPhotoScreen.h"
#import <Social/Social.h>
#import "Flurry.h"

@interface StreamScreen : UIViewController <UIImagePickerControllerDelegate,UIActionSheetDelegate,PhotoScreenDelegate,UITableViewDataSource, UITableViewDelegate,LoginScreenDelegate,UserProfileDelegate,StreamPhotoScreenDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *postDescription;
@property (strong, nonatomic) IBOutlet UITableView *streamTable;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UIButton *logButton;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) UIImage *profImage;
@property (strong, nonatomic) IBOutlet UILabel *loginBtnLabel;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UILabel *label1Sub;

- (IBAction)attachAPhoto:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)makePost:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)label1Info:(id)sender;
- (IBAction)label2Info:(id)sender;


@end

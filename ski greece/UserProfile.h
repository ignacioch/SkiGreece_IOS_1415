//
//  UserProfile.h
//  Ski Greece
//
//  Created by VimaTeamGr on 8/31/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UserProfile;

@protocol UserProfileDelegate <NSObject>

- (void)userLoggedOut:(UserProfile *)controller;
- (void)userReturns:(UserProfile *)controller withImage:(UIImage*)image;
@end

@interface UserProfile : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, weak) id <UserProfileDelegate> delegate;
- (IBAction)goToStream:(id)sender;
- (IBAction)logoutUser:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *getPicturefromFB;
- (IBAction)getitFromFB:(id)sender;
- (IBAction)setProfilePic:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
- (IBAction)backButton:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *stats1value;
@property (strong, nonatomic) IBOutlet UILabel *stat1label;
@property (strong, nonatomic) IBOutlet UILabel *stat2value;
@property (strong, nonatomic) IBOutlet UILabel *stat2label;
@property (strong, nonatomic) IBOutlet UILabel *stat3value;
@property (strong, nonatomic) IBOutlet UILabel *stat3label;

@property (strong, nonatomic) IBOutlet UILabel *fbLoginLabel;


@end

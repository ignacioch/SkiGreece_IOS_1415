//
//  VTHomeViewController.h
//  ski greece
//
//  Created by ignacio on 10/11/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTHomeViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PFLogInViewControllerDelegate>

- (BOOL)shouldPresentPhotoCaptureController;


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *activityButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UIImageView *navigationBar;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBar;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;



- (IBAction)backButtonAction:(id)sender;
- (IBAction)settingsButtonAction:(id)sender;
- (IBAction)takePhotoAction:(id)sender;
- (IBAction)activityAction:(id)sender;

@end

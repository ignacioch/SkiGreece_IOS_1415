//
//  VTHomeViewController.h
//  ski greece
//
//  Created by ignacio on 10/11/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTHomeViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

- (BOOL)shouldPresentPhotoCaptureController;


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *activityButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;



- (IBAction)backButtonAction:(id)sender;
- (IBAction)settingsButtonAction:(id)sender;
- (IBAction)takePhotoAction:(id)sender;
- (IBAction)activityAction:(id)sender;

@end

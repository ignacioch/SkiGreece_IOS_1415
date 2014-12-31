//
//  VTEditPhotoViewController.h
//  ski greece
//
//  Created by ignacio on 10/12/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTEditPhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *navBar;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, strong) UIImage * image;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

@end

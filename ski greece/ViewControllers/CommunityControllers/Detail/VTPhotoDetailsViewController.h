//
//  VTPhotoDetailsViewController.h
//  ski greece
//
//  Created by ignacio on 16/11/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTPhotoDetailsViewController : UIViewController<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) PFObject *photo;
@property (weak, nonatomic) IBOutlet UIImageView *topBar;
@property (weak, nonatomic) IBOutlet UIButton *activityBtn;

- (IBAction)activityButtonAction:(id)sender;
- (IBAction)actionButtonAction:(id)sender;


@end

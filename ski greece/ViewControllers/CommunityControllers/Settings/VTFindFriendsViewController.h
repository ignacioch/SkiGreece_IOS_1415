//
//  VTFindFriendsViewController.h
//  ski greece
//
//  Created by ignacio on 23/11/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface VTFindFriendsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *topBar;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)backButtonAction:(id)sender;

@end

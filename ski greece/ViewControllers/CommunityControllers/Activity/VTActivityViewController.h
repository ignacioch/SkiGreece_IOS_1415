//
//  VTActivityViewController.h
//  ski greece
//
//  Created by ignacio on 06/12/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTActivityViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *navBar_top;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;

- (IBAction)backButtonAction:(id)sender;

@end

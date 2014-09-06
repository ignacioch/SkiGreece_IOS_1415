//
//  CenterMoreInfoV2.h
//  Ski Greece
//
//  Created by VimaTeamGr on 12/28/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface CenterMoreInfoV2 : UIViewController <UIScrollViewDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
{
    IBOutlet UIImageView *more_info_condition_label;
    IBOutlet UIImageView *more_info_back;
    IBOutlet UIImageView *more_info_center_label;
    IBOutlet UIImageView *more_info_text;
    IBOutlet UIImageView *more_info_image;
    UIActivityIndicatorView *spinner;
}
@property (nonatomic,strong) IBOutlet UIImageView *more_info_condition_label;
@property (nonatomic,strong) IBOutlet UIImageView *more_info_back;
@property (nonatomic,strong) IBOutlet UIImageView *more_info_center_label;
@property (nonatomic,strong) IBOutlet UIImageView *more_info_image;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UILabel *more_info_label;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;



- (IBAction)make_a_call:(id)sender;
- (IBAction)open_google_map:(id)sender;
- (IBAction)open_gallery:(id)sender;
- (IBAction)backAction:(id)sender;

@end

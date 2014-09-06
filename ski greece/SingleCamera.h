//
//  SingleCamera.h
//  Ski Greece
//
//  Created by VimaTeamGr on 12/30/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleCamera : UIViewController
{
    
    IBOutlet UIWebView *camera_display;
}
@property (nonatomic,strong) IBOutlet UIWebView *camera_display;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;

- (IBAction)backAction:(id)sender;


@end

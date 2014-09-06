//
//  NotificationInfo.h
//  Ski Greece
//
//  Created by VimaTeamGr on 11/24/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationInfo : UIViewController


@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutlet UILabel *copyright;
@property (strong, nonatomic) IBOutlet UILabel *smallText;
@property (strong, nonatomic) IBOutlet UIButton *smallButton;
@property (strong, nonatomic) IBOutlet UIButton *closeTutorial;
@property (strong, nonatomic) IBOutlet UIImageView *tutorial;

- (IBAction)goBack:(id)sender;
- (IBAction)openImg:(id)sender;
- (IBAction)closeTut:(id)sender;

@end

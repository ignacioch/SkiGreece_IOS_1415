//
//  InfoScreen.h
//  Ski Greece
//
//  Created by VimaTeamGr on 10/27/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoScreen : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutlet UILabel *copyright;
@property (strong, nonatomic) IBOutlet UIButton *homeBtn;

@property (nonatomic, strong) UISwitch *locationSwitch;



- (IBAction)goBack:(id)sender;
@end

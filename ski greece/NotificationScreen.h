//
//  NotificationScreen.h
//  Ski Greece
//
//  Created by VimaTeamGr on 9/21/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFPickerView.h"

@interface NotificationScreen : UIViewController <AFPickerViewDataSource, AFPickerViewDelegate>
{
    AFPickerView *defaultPickerView;
}

@property (strong, nonatomic) IBOutlet UITextField *registeredCenterLabel;
- (IBAction)changeCenter:(id)sender;
@property (strong, nonatomic)          NSArray *skiCentersArray;
- (IBAction)skiCenterSelected:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *liftsSwitch;
- (IBAction)changeLiftsValue:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *liftsLabel;
@property (strong, nonatomic) IBOutlet UILabel *tracksLabel;
@property (strong, nonatomic) IBOutlet UILabel *weatherLabel;
@property (strong, nonatomic) IBOutlet UILabel *roadLabel;
@property (strong, nonatomic) IBOutlet UISwitch *tracksSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *weatherSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *roadSwitch;
- (IBAction)changeTracksValue:(id)sender;
- (IBAction)changeWeatherValue:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *changeRoadValue;
- (IBAction)saveButton:(id)sender;
- (IBAction)backButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *arrow;
@property (strong, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *saveButtonLabel;

@property (strong, nonatomic) UIColor *thumbTintColor;
@property (strong, nonatomic) UIColor *onTintColor;
@property (strong, nonatomic) UIColor *TintColor;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)goToInfo:(id)sender;






@end

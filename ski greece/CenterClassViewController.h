//
//  CenterClassViewController.h
//  Ski Greece
//
//  Created by VimaTeamGr on 12/26/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeUsPrompt.h"

@interface CenterClassViewController : UIViewController <LikeUsDelegate>
{
    NSMutableData *responseData;
    UIActivityIndicatorView *spinner;
}
@property (nonatomic,strong) IBOutlet UIImageView *main_screen_condition_label;

@property (nonatomic,strong) NSMutableData *responseData;
@property (strong, nonatomic) IBOutlet UILabel *mainCenterLabel;
@property (strong, nonatomic) IBOutlet UILabel *topHeader;

@property (nonatomic,assign) NSString * skiCenter;
@property (nonatomic,assign) NSString * skiCenterId;
@property (nonatomic,assign) NSString * skiCenterCondition;

@property (nonatomic,assign) NSDictionary *skiCenterDictionary;





@property (strong, nonatomic) IBOutlet UILabel *open_lifts_label;
@property (strong, nonatomic) IBOutlet UILabel *closed_lifts_label;
@property (strong, nonatomic) IBOutlet UILabel *open_tracks_label;
@property (strong, nonatomic) IBOutlet UILabel *closed_tracks_label;
@property (strong, nonatomic) IBOutlet UILabel *open_lifts_text;
@property (strong, nonatomic) IBOutlet UILabel *closed_lifts_text;
@property (strong, nonatomic) IBOutlet UILabel *open_tracks_text;
@property (strong, nonatomic) IBOutlet UILabel *closed_tracks_text;
@property (strong, nonatomic) IBOutlet UILabel *temperature_celcius;
@property (strong, nonatomic) IBOutlet UILabel *temperature_mid;
@property (strong, nonatomic) IBOutlet UILabel *temperature_fahreneit;
@property (strong, nonatomic) IBOutlet UILabel *temperature_end;
@property (strong, nonatomic) IBOutlet UILabel *snow_top;
@property (strong, nonatomic) IBOutlet UILabel *snow_top_cm;
@property (strong, nonatomic) IBOutlet UILabel *snow_base;
@property (strong, nonatomic) IBOutlet UILabel *snow_base_cm;
@property (strong, nonatomic) IBOutlet UILabel *snow_base_label;
@property (strong, nonatomic) IBOutlet UILabel *snow_top_label;

@property (strong, nonatomic) IBOutlet UIImageView *liftsImg;
@property (strong, nonatomic) IBOutlet UIImageView *tracksImg;
@property (strong, nonatomic) IBOutlet UIImageView *bottomHeader;
@property (strong, nonatomic) IBOutlet UIButton *weatherBottomBtn;
@property (strong, nonatomic) IBOutlet UIButton *camBottomBtn;
@property (strong, nonatomic) IBOutlet UIButton *trailBottomBtn;
@property (strong, nonatomic) IBOutlet UIImageView *temperatureImg;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;


- (IBAction)backAction:(id)sender;
- (IBAction)goToSkiCenterDetails:(id)sender;
- (IBAction)goToLifts:(id)sender;
- (IBAction)goToWeather:(id)sender;
- (IBAction)goToMap:(id)sender;
- (IBAction)goToCam:(id)sender;
- (IBAction)goToTrack:(id)sender;



@end

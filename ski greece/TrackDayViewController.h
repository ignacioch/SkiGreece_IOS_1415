//
//  TrackDayViewController.h
//  Ski Greece
//
//  Created by VimaTeamGr on 8/9/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocationController.h"
#import "PSLocationManager.h"
#import <MapKit/MapKit.h>
#import "VTSkiCenterMapViewController.h"
#import "LikeUsPrompt.h"

@interface TrackDayViewController : UIViewController <CoreLocationControllerDelegate,PSLocationManagerDelegate,VTMapScreenDelegate,UIAlertViewDelegate,LikeUsDelegate>
{
    CoreLocationController *CLController;
}
- (IBAction)backButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *startScanningButton;
@property (strong, nonatomic) IBOutlet UILabel *speedLabel;
@property (strong, nonatomic) IBOutlet UILabel *maxSpeedLabel;
@property (strong, nonatomic) IBOutlet UILabel *minSpeedLabel;
@property (strong, nonatomic) IBOutlet UILabel *avgSpeedLabel;
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *signalLabel;
@property (strong, nonatomic) IBOutlet UIImageView *signal_two;
@property (strong, nonatomic) IBOutlet UIImageView *signal_three;
@property (strong, nonatomic) IBOutlet UIImageView *imageToMove;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@property (strong, nonatomic) IBOutlet UILabel *minAltitudelabel;

@property (strong, nonatomic) IBOutlet UIImageView *signal_one;
@property (nonatomic, strong) CoreLocationController *CLController;
@property (strong, nonatomic) IBOutlet UILabel *maxAltitudeLabel;

@property (nonatomic) double maximumSpeed;
@property (nonatomic) double averageSpeed;
@property (weak, nonatomic) IBOutlet UIImageView *statsBar;

@property (strong, nonatomic) IBOutlet UILabel *totalDistanceCovered;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *gotoMapBtn;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UILabel *totalDisLabel;

@property (strong, nonatomic) IBOutlet UIImageView *Tutorial;
@property (strong, nonatomic) IBOutlet UIButton *closeTutorial;

- (IBAction)startScanning:(id)sender;
- (IBAction)resetTracking:(id)sender;
- (IBAction)viewMap:(id)sender;
- (IBAction)pauseTracking:(id)sender;

@end

//
//  VTSkiCenterMapViewController.h
//  Ski Greece
//
//  Created by VimaTeamGr on 8/11/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

#import "LoginScreen.h"
#import "VTSkiCenter.h"

@class VTSkiCenterMapViewController;

@protocol VTMapScreenDelegate <NSObject>

- (void)MapScreenCompleted:(VTSkiCenterMapViewController *)controller;

@end

@interface VTSkiCenterMapViewController : UIViewController <MKMapViewDelegate,MFMailComposeViewControllerDelegate,LoginScreenDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *skiCenterCustomMap;
@property (nonatomic,strong) VTSkiCenter *park;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;
@property (nonatomic,copy) NSMutableArray *routesCovered;
@property (strong, nonatomic) IBOutlet UITextField *postToCommunityText;
@property (nonatomic,copy) NSMutableArray *pointOnMap;

@property (nonatomic,assign) CLLocationCoordinate2D centerLocation; //for simulation only
@property (strong, nonatomic) IBOutlet UILabel *totalSpeed;
@property (strong, nonatomic) IBOutlet UILabel *totalDistance;
@property (strong, nonatomic) IBOutlet UILabel *totalTime;

@property (assign) CGPoint originalCenter;

@property (nonatomic,assign) NSString * maxSpeed;
@property (nonatomic,assign) NSString * time;
@property (nonatomic,assign) NSString * distance;
@property (nonatomic,assign) float distanceInt;

@property (strong, nonatomic) IBOutlet UINavigationBar *topBar;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;

@property (nonatomic, weak) id <VTMapScreenDelegate> delegate;




- (IBAction)backButton:(id)sender;

- (IBAction)mapTypeChanged:(id)sender;
- (IBAction)shareWithEmail:(id)sender;
- (IBAction)postToCommunityAction:(id)sender;
- (IBAction)postTwitter:(id)sender;
- (IBAction)postFB:(id)sender;


@end

//
//  TrackDayMenuViewController.h
//  Ski Greece
//
//  Created by VimaTeamGr on 8/10/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"
#import <Social/Social.h>
#import "PSLocationManager.h"



@interface TrackDayMenuViewController : UIViewController <EAIntroDelegate,PSLocationManagerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *liveNewsBtn;
@property (strong, nonatomic) IBOutlet UIButton *trackDayBtn;
@property (strong, nonatomic) IBOutlet UIButton *notifBtn;
@property (strong, nonatomic) IBOutlet UIButton *nearbyBtn;
@property (strong, nonatomic) IBOutlet UIButton *communBtn;
@property (strong, nonatomic) IBOutlet UIButton *bookBtn;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutlet UIButton *offersBtn;
@property (strong, nonatomic) IBOutlet UIButton *infoBtn;
@property (strong, nonatomic) IBOutlet UIButton *twitterBtn;
@property (strong, nonatomic) IBOutlet UIButton *fbBtn;
@property (strong, nonatomic) IBOutlet UIButton *rateBtn;


- (IBAction)goToBook:(id)sender;
- (IBAction)goToTrackYourDay:(id)sender;
- (IBAction)goToCommunity:(id)sender;
- (IBAction)goToNotification:(id)sender;
- (IBAction)gotoLiveNews:(id)sender;
- (IBAction)goToNearby:(id)sender;
- (IBAction)goToOffers:(id)sender;
- (IBAction)goToInfo:(id)sender;
- (IBAction)twitterPost:(id)sender;
- (IBAction)fbPost:(id)sender;
- (IBAction)rateMePost:(id)sender;

@end

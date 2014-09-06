//
//  CenterClassViewController.m
//  Ski Greece
//
//  Created by VimaTeamGr on 12/26/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import "CenterClassViewController.h"
#import "AppDelegate.h"
#import "LiftsView.h"
#import "TracksViewViewController.h"
#import "WeatherViewController.h"
#import "CenterMoreInfoV2.h"
#import "CameraList.h"
#import "TrailMap.h"
#import "MBProgressHUD.h"
#import "LikeUsPrompt.h"
#import "Flurry.h"

@interface CenterClassViewController ()
{
    NSInteger cnt_id;
    NSString *condit;
    NSArray *centersimages_closed;
    NSArray *centersimages_open;
    NSArray *labels;
    NSString *tmp_date;
    NSString *ski_center;
    NSString *total_cameras;
    NSMutableArray *cameras;
    int total_number_lifts;
    MBProgressHUD *hud;
        
    BOOL seenAd;
    
    NSArray * tracks;
    NSArray * lifts;
    NSDictionary *skiCenterDictionary;
}

@end

@implementation CenterClassViewController

@synthesize main_screen_condition_label=_main_screen_condition_label;


@synthesize responseData;
@synthesize skiCenter=_skiCenter;
@synthesize skiCenterId=_skiCenterId;
@synthesize skiCenterCondition=_skiCenterCondition;
@synthesize mainCenterLabel=_mainCenterLabel;
@synthesize topHeader=_topHeader;

@synthesize open_lifts_label=_open_lifts_label;
@synthesize closed_lifts_label=_closed_lifts_label;
@synthesize open_tracks_label=_open_tracks_label;
@synthesize closed_tracks_label=_closed_tracks_label;
@synthesize open_lifts_text=_open_lifts_text;
@synthesize closed_lifts_text=_closed_lifts_text;
@synthesize open_tracks_text=_open_tracks_text;
@synthesize closed_tracks_text=_closed_tracks_text;

@synthesize temperature_celcius=_temperature_celcius;
@synthesize temperature_end=_temperature_end;
@synthesize temperature_fahreneit=_temperature_fahreneit;
@synthesize temperature_mid=_temperature_mid;

@synthesize snow_base=_snow_base;
@synthesize snow_base_cm=_snow_base_cm;
@synthesize snow_top=_snow_top;
@synthesize snow_top_cm=_snow_top_cm;
@synthesize snow_base_label=_snow_base_label;
@synthesize snow_top_label=_snow_top_label;

@synthesize liftsImg=_liftsImg;
@synthesize tracksImg=_tracksImg;
@synthesize bottomHeader=_bottomHeader;
@synthesize weatherBottomBtn=_weatherBottomBtn;
@synthesize camBottomBtn=_camBottomBtn;
@synthesize trailBottomBtn=_trailBottomBtn;
@synthesize temperatureImg=_temperatureImg;

@synthesize backgroundImg=_backgroundImg;

@synthesize skiCenterDictionary=_skiCenterDictionary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    seenAd = NO;
    
    
    [self hideElements];
    
    // Do any additional setup after loading the view.
    /*ski_center=self.skiCenter;
    cnt_id=[self.skiCenterId integerValue];
    condit=self.skiCenterCondition;*/
    
    NSLog(@"Ski Center Dictionary: %@",self.skiCenterDictionary);
    int open = [[self.skiCenterDictionary objectForKey:@"open"] intValue];
    NSString *name = [self.skiCenterDictionary objectForKey:@"name"];
    int skiId= [[self.skiCenterDictionary objectForKey:@"id"] intValue];
    ski_center =[self.skiCenterDictionary objectForKey:@"englishName"];
    
    
    if (open == 0) {
        [self.main_screen_condition_label setImage:[UIImage imageNamed:@"main_screen_more_info_closed.png"]];
    } else {
        [self.main_screen_condition_label setImage:[UIImage imageNamed:@"main_screen_more_info_opened.png"]];
    }
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud show:YES];
    
    self.mainCenterLabel.text=name;
    self.topHeader.text= name;
    [self.topHeader sizeToFit];

    
    self.responseData = [NSMutableData data];
    NSMutableString* url = [NSMutableString stringWithFormat:@"http://%s/%d", BASE_URL, skiId];
    // does not need to be released. Needs to be retained if you need to keep use it after the current function.

    /*adjust for different screen sizes*/
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"main_screen_header_iphone5.png"]];
        
        NSArray *subviews = [self.view subviews];
        
        // Return if there are no subviews
        //if ([subviews count] == 0) return;
        
        for (UIView *subview in subviews) {
            if (subview.tag == 10) {                // 10 is the bottom header + the buttons in there
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + OFFSET_5, subview.frame.size.width, subview.frame.size.height);
                //NSLog(@"Subview:%@",subview);
            } else if (subview.tag == 20) {                // 20 is the ski center label and that group
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 20.0f, subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag == 30) {                // 30 is the group for lifts + tracks
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 20.0f + 25.0f, subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag == 40) {                // 30 is the group for temperature
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 20.0f + 25.0f + 25.0f, subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag != 99) {            // 99 is the subView of the backgroundImg
              
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7, subview.frame.size.width, subview.frame.size.height);
            }
        }
        
    } else { //iphone 3GS,4,4S
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , self.backgroundImg.frame.size.width, self.backgroundImg.frame.size.height);
            
            NSArray *subviews = [self.view subviews];
            
            // Return if there are no subviews
            //if ([subviews count] == 0) return;
            
            for (UIView *subview in subviews) {
                if (subview.tag != 99) {            // 99 is the subView of the backgroundImg
                    //NSLog(@"SubView : %@", subview);
                    // move every subview by 20 down
                    subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7, subview.frame.size.width, subview.frame.size.height);
                }
            }

        }
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        imgView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:imgView];
    }
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:url]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    
    NSDictionary *offerDic = [self.skiCenterDictionary objectForKey:@"offers"];
    NSString *offer = [offerDic objectForKey:@"url"];
    NSString *comment = [offerDic objectForKey:@"comments"];
    if (!seenAd){
        if (offer == (id)[NSNull null] || offer.length == 0 ) {
            NSLog(@"No advertisment for this offer");
        } else {
            NSLog(@"Open advertisment");
            [self openAdvertisment:offer withComment:comment];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
        
    [hud hide:YES];
    [self revealElements];
    

    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"Getting strings out of json :%@",res);
    
    skiCenterDictionary=res;
    
    lifts = [res objectForKey:@"lifts"];
    int open_lifts = 0;
    for (int i = 0;i<[lifts count];i++) {
        NSDictionary *currentData = [lifts objectAtIndex:i];
        int open = [[currentData objectForKey:@"open"] intValue];
        if (open == 1) open_lifts = open_lifts+1;
    }
    int closed_lifts = [lifts count] - open_lifts;
    self.open_lifts_label.text= [NSString stringWithFormat:@"%d", open_lifts];
    self.closed_lifts_label.text = [NSString stringWithFormat:@"%d",closed_lifts];
    
    tracks = [res objectForKey:@"tracks"];
    int open_tracks = 0;
    for (int i =0;i<[tracks count];i++){
        NSDictionary *currentData = [tracks objectAtIndex:i];
        int open = [[currentData objectForKey:@"open"] intValue];
        if (open == 1) open_tracks=open_tracks+1;
    }
    
    int closed_tracks = [tracks count] - open_tracks;
    self.open_tracks_label.text= [NSString stringWithFormat:@"%d", open_tracks];
    self.closed_tracks_label.text = [NSString stringWithFormat:@"%d",closed_tracks];
    
    
    NSString *tempor=[res objectForKey:@"temp"];
    NSLog(@"Temperature: %@",tempor);
    NSString *sn_up=[res objectForKey:@"snow_up"];
    NSLog(@"Snow up: %@",sn_up);
    NSString *sn_dow=[res objectForKey:@"snow_down"];
    NSLog(@"Snow down: %@",sn_dow);
    
    [self.temperature_celcius setTextColor:[UIColor colorWithRed:(0/255.f) green:(192/255.f) blue:(243/255.f) alpha:1.0f]];
    self.temperature_celcius.text=[NSString stringWithFormat:@"%@",tempor];
    
    int qq=[tempor intValue];
    qq= (qq*9/5)+32;
    
    [self.temperature_fahreneit setTextColor:[UIColor colorWithRed:(0/255.f) green:(192/255.f) blue:(243/255.f) alpha:1.0f]];
    self.temperature_fahreneit.text=[NSString stringWithFormat:@"%d",qq];
    
    [self.snow_base_label setTextColor:[UIColor colorWithRed:(183/255.f) green:(183/255.f) blue:(183/255.f) alpha:1.0f]];
    [self.snow_top_label setTextColor:[UIColor colorWithRed:(183/255.f) green:(183/255.f) blue:(183/255.f) alpha:1.0f]];
    
    [self.snow_top setTextColor:[UIColor colorWithRed:(0/255.f) green:(192/255.f) blue:(243/255.f) alpha:1.0f]];
    self.snow_top.text = [NSString stringWithFormat:@"%@",sn_up];
    
    [self.snow_base setTextColor:[UIColor colorWithRed:(0/255.f) green:(192/255.f) blue:(243/255.f) alpha:1.0f]];
    self.snow_base.text = [NSString stringWithFormat:@"%@",sn_dow];
    
    [self.snow_base_cm setTextColor:[UIColor colorWithRed:(183/255.f) green:(183/255.f) blue:(183/255.f) alpha:1.0f]];
    [self.snow_top_cm setTextColor:[UIColor colorWithRed:(183/255.f) green:(183/255.f) blue:(183/255.f) alpha:1.0f]];
    [self.temperature_mid setTextColor:[UIColor colorWithRed:(183/255.f) green:(183/255.f) blue:(183/255.f) alpha:1.0f]];
    [self.temperature_end setTextColor:[UIColor colorWithRed:(183/255.f) green:(183/255.f) blue:(183/255.f) alpha:1.0f]];
    
    /*set the delegates*/
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.weather_url = [res objectForKey:@"weatherurl"];
    delegate.center =[res objectForKey:@"englishName"];
    delegate.cond = [[res objectForKey:@"open"] intValue];
    delegate.cent_id =[[res objectForKey:@"id"] intValue] - 1;
    
    NSArray *camArray = [res objectForKey:@"cameras"];
    cameras = [NSMutableArray array];
    for (int i=0; i<[camArray count];i++){
        NSDictionary *cameraDict =[camArray objectAtIndex:i];
        NSLog(@"%d : %@" ,i,[cameraDict objectForKey:@"url"]);
        [cameras addObject:[cameraDict objectForKey:@"url"]];
    }
    
    delegate.cameras_urls = cameras;


}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(void) likeUsCompleted:(LikeUsPrompt *)controller
{
    NSLog(@"Delegate called");
    seenAd = YES;
	[self dismissViewControllerAnimated:NO completion:nil];
}

-(void) openAdvertisment:(NSString*)offer withComment:(NSString*)comment
{
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     ski_center, @"Ski_Center", // Ski Center Main
     comment ,@"Advertisment",
     nil];
    
    NSLog(@"Comment of the advertisment is:%@",comment);
    
    [Flurry logEvent:@"SkiCenter_Advertisment" withParameters:articleParams];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LikeUsPrompt *vc = [sb instantiateViewControllerWithIdentifier:@"LikeUsID"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.delegate=self;
    vc.offerUrl=offer;
    [self presentViewController:vc animated:YES completion:NULL];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


-(void) hideElements
{
    self.open_tracks_label.hidden= YES;
    self.closed_tracks_label.hidden = YES;
    self.open_lifts_label.hidden = YES;
    self.closed_lifts_label.hidden = YES;
    
    self.temperature_celcius.hidden = YES;
    self.temperature_fahreneit.hidden = YES;
    
    self.snow_top.hidden = YES;
    self.snow_base.hidden = YES;
}

-(void) revealElements
{
    self.open_tracks_label.hidden= NO;
    self.closed_tracks_label.hidden = NO;
    self.open_lifts_label.hidden = NO;
    self.closed_lifts_label.hidden = NO;
    
    self.temperature_celcius.hidden = NO;
    self.temperature_fahreneit.hidden = NO;
    
    self.snow_top.hidden = NO;
    self.snow_base.hidden = NO;
}

- (IBAction)backAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goToSkiCenterDetails:(id)sender {
    /*analytics add/event per ski center*/
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     ski_center, @"Ski_Center", // Ski Center Main
     nil];
    
    [Flurry logEvent:@"SkiCenterMoreInfoScreen" withParameters:articleParams];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CenterMoreInfoV2 *vc = [sb instantiateViewControllerWithIdentifier:@"CenterMoreID"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];

}

- (IBAction)goToLifts:(id)sender {
    
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     ski_center, @"Ski_Center", // Ski Center Main
     nil];
    
    [Flurry logEvent:@"SkiCenterMainScreen_Lifts" withParameters:articleParams];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LiftsView *vc = [sb instantiateViewControllerWithIdentifier:@"LiftsList"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.skiCenter=self.skiCenter;
    vc.total_lifts=total_number_lifts;
    vc.liftsArray=lifts;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)goToWeather:(id)sender {
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     ski_center, @"Ski_Center", // Ski Center Main
     nil];
    
    [Flurry logEvent:@"SkiCenterMainScreen_Weather" withParameters:articleParams];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    WeatherViewController*vc = [sb instantiateViewControllerWithIdentifier:@"WeatherID"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (IBAction)goToMap:(id)sender {
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     ski_center, @"Ski_Center", // Ski Center Main
     nil];
    
    [Flurry logEvent:@"SkiCenterMainScreen_Map" withParameters:articleParams];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    TrailMap*vc = [sb instantiateViewControllerWithIdentifier:@"TrailMapID"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)goToCam:(id)sender {
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     ski_center, @"Ski_Center", // Ski Center Main
     nil];
    
    [Flurry logEvent:@"SkiCenterMainScreen_Cameras" withParameters:articleParams];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CameraList*vc = [sb instantiateViewControllerWithIdentifier:@"CameraID"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];

}

- (IBAction)goToTrack:(id)sender {
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     ski_center, @"Ski_Center", // Ski Center Main
     nil];
    
    [Flurry logEvent:@"SkiCenterMainScreen_Track" withParameters:articleParams];
    
    if ([tracks count] !=0) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        TracksViewViewController *vc = [sb instantiateViewControllerWithIdentifier:@"TrackList"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        vc.skiCenter=self.skiCenter;
        vc.tracksArray=tracks;
        [self presentViewController:vc animated:YES completion:NULL];
    } else { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ski Greece"
                                                       message:@"Δεν υπάρχουν διαθέσιμα στοιχεία για τις πίστες του συγκεκριμένου χιονοδρομικού κέντρου."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

@end

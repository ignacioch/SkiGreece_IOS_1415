//
//  NotificationScreen.m
//  Ski Greece
//
//  Created by VimaTeamGr on 9/21/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "NotificationScreen.h"
#import <Parse/Parse.h>
#import "UIFont+SnapAdditions.h"
#import "NotificationInfo.h"

#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface NotificationScreen ()

@end

@implementation NotificationScreen
{
    NSArray * englishSkiCenters;
    NSString * skiCenterToRegister;
    NSString * previousSkiCenterChannel;
    NSString * previousTrackPref;
    NSString * previousLiftsPref;
    NSString * previousWeatherPref;
    NSString * previousRoadPref;
    NSMutableArray * changesInChannels;
    NSArray * channelsNames;
    BOOL visiblePicker;

}

@synthesize skiCentersArray=_skiCentersArray;
@synthesize registeredCenterLabel=_registeredCenterLabel;
@synthesize liftsLabel=_liftsLabel;
@synthesize liftsSwitch=_liftsSwitch;
@synthesize weatherLabel=_weatherLabel;
@synthesize weatherSwitch=_weatherSwitch;
@synthesize tracksLabel=_tracksLabel;
@synthesize tracksSwitch=_tracksSwitch;
@synthesize roadLabel=_roadLabel;
@synthesize roadSwitch=_roadSwitch;
@synthesize arrow=_arrow;
@synthesize placeholderLabel=_placeholderLabel;
@synthesize saveButton=_saveButton;
@synthesize saveButtonLabel=_saveButtonLabel;

@synthesize thumbTintColor=_thumbTintColor;
@synthesize onTintColor=_onTintColor;
@synthesize TintColor=_TintColor;

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
    
    self.tutorial.hidden=YES;
    self.tutorial.userInteractionEnabled = NO;
    self.closeTutorial.hidden= YES;
    self.closeTutorial.userInteractionEnabled = NO;
    
	// Do any additional setup after loading the view.
    self.skiCentersArray  = [[NSMutableArray alloc] initWithObjects:@"Κανένα",@"Χ.Κ. Καλαβρύτων",@"Χ.Κ. Παρνασσού",@"Χ.Κ. Βασιλίτσας",@"Χ.Κ. Καιμακτσαλάν",@"Χ.Κ. Σελίου",@"Χ.Κ. Πηλίου",@"Χ.Κ. 3-5 Πηγάδια",@"Χ.Κ. Πισοδερίου",@"Χ.Κ. Καρπενησίου",@"Χ.Κ. Ελατοχωρίου",@"Χ.Κ. Λαιλιά",@"Χ.Κ. Μαινάλου",@"Χ.Κ. Φαλακρού",@"Χ.Κ. Ανηλίου",@"Χ.Κ. Περτουλίου",nil];
    englishSkiCenters=[[NSArray alloc] initWithObjects:@"None",@"Kalavryta",@"Parnassos", @"Vasilitsa",@"Kaimaktsalan",@"Seli",@"Pilio",@"Pigadia",@"Pisoderi",@"Karpenisi",@"Elatohori",@"Lailia",@"Mainalo",@"Falakro",@"Anilio",@"Pertouli", nil];
    
    
    NSArray *subscribedChannels = [PFInstallation currentInstallation].channels;
    NSLog(@"Subscribed channels :%@",subscribedChannels);
    
    
    changesInChannels=[NSMutableArray arrayWithObjects:@"NO",@"NO",@"NO",@"NO",@"NO",nil];
    /****
     0: SkiCenter
     1: Tracks
     2: Lifts
     3: Weather
     4: Road
     *****/
    channelsNames=[NSArray arrayWithObjects:@"Unused",@"Tracks",@"Lifts",@"Weather",@"Road", nil];
    
    [self setInitialValues];
    
    /*set colours for switch*/
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
    } else {
         [[UISwitch appearance] setOnTintColor:[UIColor colorWithRed:230.0/255 green:115.0/255 blue:14.0/255 alpha:1.0]];
         [[UISwitch appearance] setTintColor:[UIColor colorWithRed:213.0/255 green:183.0/255 blue:165.0/255 alpha:1.000]];
         [[UISwitch appearance] setThumbTintColor:[UIColor colorWithRed:247.0/255 green:169.0/255 blue:51.0/255 alpha:1.000]];
    }
    
    
   /* [self setThumbTintColor:[UIColor colorWithRed:247.0/255 green:169.0/255 blue:51.0/255 alpha:1.000]];
    [[UISwitch appearance] setThumbTintColor:[self thumbTintColor]];
    
    [self setOnTintColor:[UIColor colorWithRed:230.0/255 green:115.0/255 blue:14.0/255 alpha:1.0]];
    [[UISwitch appearance] setOnTintColor:[self onTintColor]];
    
    [self setTintColor:[UIColor colorWithRed:213.0/255 green:183.0/255 blue:165.0/255 alpha:1.000]];
    [[UISwitch appearance] setTintColor:[self TintColor]];*/
    
    /*custom fonts for labels*/
    [self.placeholderLabel setFont:[UIFont vt_myriadBoldWithSize:17.0f ]];
    [self.liftsLabel setFont:[UIFont vt_myriadBoldWithSize:13.0f ]];
    [self.tracksLabel setFont:[UIFont vt_myriadBoldWithSize:13.0f ]];
    [self.roadLabel setFont:[UIFont vt_myriadBoldWithSize:13.0f ]];
    [self.weatherLabel setFont:[UIFont vt_myriadBoldWithSize:13.0f ]];
    
    [self.saveButtonLabel setFont:[UIFont vt_myriadBoldWithSize:17.0f ]];
    /*[self.saveButton setTitle:@"Save!" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveButton.titleLabel.font=[UIFont vt_myriadBoldWithSize:17.0f];*/

    visiblePicker = NO;
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    if (IS_IPHONE_6) {
        
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_with_back_5.png"]];
        
        self.backBtn.frame = CGRectMake(self.backBtn.frame.origin.x, self.backBtn.frame.origin.y + OFFSET_IOS_7 , self.backBtn.frame.size.width , self.backBtn.frame.size.height);
        
        self.tutorial.frame = CGRectMake(self.tutorial.frame.origin.x, self.tutorial.frame.origin.y, SCREEN_WIDTH - 2*self.tutorial.frame.origin.x , SCREEN_HEIGHT - 2*self.tutorial.frame.origin.y );
        self.closeTutorial.frame = CGRectMake(self.tutorial.frame.origin.x, self.closeTutorial.frame.origin.y, self.closeTutorial.frame.size.width, self.closeTutorial.frame.size.height);
        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            if (subview.tag == 10) {                // 10 is the up label
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 10.0f, subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag == 20) {                // is the placeholder
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 10.0f + 5.0f, subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag == 30) {                // 30 is the switches
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 10.0f + 5.0f + 30.0f, subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag == 40) {                // 30 is the group for the bottom
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + OFFSET_5, subview.frame.size.width, subview.frame.size.height);
            }
        }
        
        
    } else if (IS_IPHONE_5){
        
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_with_back_5.png"]];
        
        self.backBtn.frame = CGRectMake(self.backBtn.frame.origin.x, self.backBtn.frame.origin.y + OFFSET_IOS_7 , self.backBtn.frame.size.width , self.backBtn.frame.size.height);
        
        self.tutorial.frame = CGRectMake(self.tutorial.frame.origin.x, self.tutorial.frame.origin.y, self.tutorial.frame.size.width, self.tutorial.frame.size.height);
        self.closeTutorial.frame = CGRectMake(self.tutorial.frame.origin.x, self.closeTutorial.frame.origin.y, self.closeTutorial.frame.size.width, self.closeTutorial.frame.size.height);
        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            if (subview.tag == 10) {                // 10 is the up label
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 10.0f, subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag == 20) {                // is the placeholder
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 10.0f + 5.0f, subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag == 30) {                // 30 is the switches
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 10.0f + 5.0f + 30.0f, subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag == 40) {                // 30 is the group for the bottom
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + OFFSET_5, subview.frame.size.width, subview.frame.size.height);
            }
        }
        
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7, subview.frame.size.width, subview.frame.size.height);
        }
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        imgView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:imgView];
    }
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    
    
    /*check whether the user wants to receive push notification*/
    UIRemoteNotificationType status = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(![defaults boolForKey:@"hasSeenNotifGuides"]) {
        NSLog(@"User will see the notice");
        [defaults setBool:false forKey:@"hasSeenNotifGuides"];
        [self seeGuidance];
        [defaults synchronize];
    } else if (status == UIRemoteNotificationTypeNone)
    {
        NSLog(@"User doesn't want to receive push-notifications");
    }
    

    self.roadLabel.hidden = YES;
    self.roadLabel.userInteractionEnabled = NO;
    self.roadSwitch.hidden = YES;
    self.roadSwitch.userInteractionEnabled = NO;
    
}

-(void) seeGuidance
{
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"hasSeenNotifGuides"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.tutorial.hidden=NO;
    self.tutorial.userInteractionEnabled = YES;
    self.closeTutorial.hidden= NO;
    self.closeTutorial.userInteractionEnabled = YES;
}



-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Do your resizing
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeCenter:(id)sender {
    
    if (!visiblePicker) {
        //[self disappearMid];
        visiblePicker= YES;
        if (defaultPickerView == nil) {
            //if (screenBounds.size.height == 568) {
            if (IS_IPHONE_6) {
              defaultPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 216.0f ,SCREEN_WIDTH,216) backgroundImage:@"PickerBG.png" shadowImage:@"PickerShadow.png" glassImage:@"pickerGlass.png" title:@" Επίλεξε Χιονοδρομικό"];
            } else if (IS_IPHONE_5) {
                defaultPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(0,245 + OFFSET_IOS_7 +  + OFFSET_5 ,320,216) backgroundImage:@"PickerBG.png" shadowImage:@"PickerShadow.png" glassImage:@"pickerGlass.png" title:@" Επίλεξε Χιονοδρομικό"];


            } else {
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
                    defaultPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(0,245 + OFFSET_IOS_7,320,216) backgroundImage:@"PickerBG.png" shadowImage:@"PickerShadow.png" glassImage:@"pickerGlass.png" title:@" Επίλεξε Χιονοδρομικό"];
                } else {
                    defaultPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(0,245,320,216) backgroundImage:@"PickerBG.png" shadowImage:@"PickerShadow.png" glassImage:@"pickerGlass.png" title:@" Επίλεξε Χιονοδρομικό"];
                }
            }
            
            defaultPickerView.dataSource = self;
            defaultPickerView.delegate = self;
            [self.view addSubview:defaultPickerView];
        }
        [defaultPickerView showPicker];
        [defaultPickerView reloadData];
        [self.arrow setImage:[UIImage imageNamed:@"notification_arrow_up.png"] forState:UIControlStateNormal];
    } else {
        [self.arrow setImage:[UIImage imageNamed:@"notification_arrow_down.png"] forState:UIControlStateNormal];
        [defaultPickerView hidePicker];
        visiblePicker= NO;
    }
}


#pragma mark - AFPickerViewDataSource

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView {
    return [self.skiCentersArray count];
}


- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row {
    return [self.skiCentersArray objectAtIndex:row];
}


#pragma mark - AFPickerViewDelegate

- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row {
    NSLog(@"row is:%d",row);
    [self.registeredCenterLabel setText:[self.skiCentersArray objectAtIndex:row]];
    skiCenterToRegister=[englishSkiCenters objectAtIndex:row];

}

- (void)pickerView:(AFPickerView *)pickerView hidedRow:(NSInteger)row
{
    /*change local variables*/
    [self.arrow setImage:[UIImage imageNamed:@"notification_arrow_down.png"] forState:UIControlStateNormal];
    //[self syncText];
    visiblePicker= NO;
}

/*-(void)syncText
{
    if ([ selectedRowInComponent:0] >=0 ) {
        [self.registeredCenterLabel setText:[self.skiCentersArray objectAtIndex:[self.pickerSkiCenter selectedRowInComponent:0]]];
    }
    skiCenterToRegister=[englishSkiCenters objectAtIndex:[self.pickerSkiCenter selectedRowInComponent:0]];
}*/

-(void) disappearMidElements
{
    _liftsLabel.hidden=YES;
    _liftsSwitch.hidden=YES;
    _tracksLabel.hidden=YES;
    _tracksSwitch.hidden=YES;
    _weatherLabel.hidden=YES;
    _weatherSwitch.hidden=YES;
    _roadLabel.hidden=YES;
    _roadSwitch.hidden=YES;
    _liftsSwitch.enabled=NO;
    _tracksSwitch.enabled=NO;
    _weatherSwitch.enabled=NO;
    _roadSwitch.enabled=NO;
    
    [self.arrow setImage:[UIImage imageNamed:@"notification_arrow_up.png"] forState:UIControlStateNormal];
}

-(void) appearMidElements
{
    _liftsSwitch.hidden=NO;
    _liftsLabel.hidden=NO;
    _tracksSwitch.hidden=NO;
    _tracksLabel.hidden=NO;
    _weatherSwitch.hidden=NO;
    _weatherLabel.hidden=NO;
    _roadSwitch.hidden=NO;
    _roadLabel.hidden=NO;
    _weatherSwitch.enabled=YES;
    _tracksSwitch.enabled=YES;
    _liftsSwitch.enabled=YES;
    _roadSwitch.enabled=YES;
    
    [self.arrow setImage:[UIImage imageNamed:@"notification_arrow_down.png"] forState:UIControlStateNormal];
}


- (IBAction)skiCenterSelected:(id)sender
{
    [defaultPickerView hidePicker];
    /*[self syncText];
    self.pickerSkiCenter.alpha=0;
    [self appearMidElements];*/
}

- (IBAction)saveButton:(id)sender
{
    NSLog(@"Saving Notification Preferences");
    NSLog(@"Selected Ski Center is:%@",skiCenterToRegister);
    // When users indicate they are Giants fans, we subscribe them to that channel.
    
    
    [self checkforChanges];
    
    [self removePreviousChannels];
    
    
    //add to Channels
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:[NSString stringWithFormat:@"%@",skiCenterToRegister] forKey:@"channels"];
    if (_tracksSwitch.on) {
        [currentInstallation addUniqueObject:@"Tracks" forKey:@"channels"];
    }
    if (_liftsSwitch.on) {
        [currentInstallation addUniqueObject:@"Lifts" forKey:@"channels"];
    }
    if (_weatherSwitch.on) {
        [currentInstallation addUniqueObject:@"Weather" forKey:@"channels"];
    }
    
    if (_roadSwitch.on) {
        [currentInstallation addUniqueObject:@"Road" forKey:@"channels"];
    }
    
    // DEMO
    //[currentInstallation addUniqueObject:@"Admin" forKey:@"channels"];
    
    [currentInstallation saveInBackground];
    
       
    NSArray *subscribedChannels = [PFInstallation currentInstallation].channels;
    for (int i=0;i<[subscribedChannels count];i++){
        NSLog(@"Channel %d:%@",i,(NSString*)subscribedChannels[i]);
    }
    
    NSMutableDictionary *newPreferences = [[NSMutableDictionary  alloc] init];
    [newPreferences setObject:[NSString stringWithFormat:@"%@",skiCenterToRegister] forKey:@"skiCenterPref"];
    [newPreferences setObject:[NSString stringWithFormat:@"%@",(_tracksSwitch.on) ? @"YES" : @"NO" ] forKey:@"tracksPref"] ;
    [newPreferences setObject:[NSString stringWithFormat:@"%@",(_liftsSwitch.on) ? @"YES" : @"NO" ] forKey:@"liftsPref"];
    [newPreferences setObject:[NSString stringWithFormat:@"%@",(_weatherSwitch.on) ? @"YES" : @"NO" ] forKey:@"weatherPref"];
    [newPreferences setObject:[NSString stringWithFormat:@"%@",(_roadSwitch.on) ? @"YES" : @"NO" ] forKey:@"roadPref"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:newPreferences forKey:@"DicKey"];
    [defaults synchronize];
    
    NSString* temp_name= self.registeredCenterLabel.text;
    NSLog(@"temp_name:%@",temp_name);
    if (![temp_name isEqualToString:@"Κανένα"]) {
        NSString *message2= [NSString stringWithFormat:@"Έχεις επιλέξει να ενημερώνεσαι άμεσα για οποιαδήποτε αλλαγή στο %@",temp_name];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Μείνε συντονισμένος"
                                                        message: message2
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Μείνε συντονισμένος"
                                                        message:@"Επίλεξε Χιονοδρομικό Κέντρο για το οποίο θέλεις να λαμβάνεις ειδοποιήσεις για την κατάσταση λειτουργίας του."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)backButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeLiftsValue:(id)sender
{
    if (_liftsSwitch.on) {
        //will be now switched off
    } else {
        //will no be switched off
    }
}
- (IBAction)changeTracksValue:(id)sender
{
}

- (IBAction)changeWeatherValue:(id)sender
{
}


-(void) checkforChanges
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *previousDictionary=[defaults objectForKey:@"DicKey"];
    
    previousSkiCenterChannel=[previousDictionary objectForKey:@"skiCenterPref"];
    NSLog(@"Previous registered Ski Center:%@",previousSkiCenterChannel);
    
    previousLiftsPref=[previousDictionary objectForKey:@"liftsPref"];
    NSLog(@"Previous lift status:%@",previousLiftsPref);
    
    previousTrackPref=[previousDictionary objectForKey:@"tracksPref"];
    NSLog(@"Previous track status:%@",previousTrackPref);
    
    previousWeatherPref=[previousDictionary objectForKey:@"weatherPref"];
    NSLog(@"Previous weather status:%@",previousWeatherPref);
    
    previousRoadPref=[previousDictionary objectForKey:@"roadPref"];
    NSLog(@"Previous road status:%@",previousRoadPref);
    
    //check for different ski center
    if (previousSkiCenterChannel==nil) {
        NSLog(@"First time - Nothing to remove from channels");
    } else if (![previousSkiCenterChannel isEqualToString:skiCenterToRegister]) {
        NSLog(@"I want notifications for a different skiCenter - You need to unregister from the other");
        [changesInChannels replaceObjectAtIndex:0 withObject:@"YES"];
    }
    
    //check for tracks
    if (previousTrackPref==nil) {
        NSLog(@"First time - Nothing to remove from channels");
    } else if ([previousTrackPref isEqualToString:@"YES"] && [[NSString stringWithFormat:@"%@",(_tracksSwitch.on) ? @"YES" : @"NO" ] isEqualToString:@"NO"]) {
        NSLog(@"Tracks was YES and now is NO - I should remove it");
        [changesInChannels replaceObjectAtIndex:1 withObject:@"YES"];
    }
    
    //check for lifts
    if (previousLiftsPref==nil) {
        NSLog(@"First time - Nothing to remove from channels");
    } else if ([previousLiftsPref isEqualToString:@"YES"] && [[NSString stringWithFormat:@"%@",(_liftsSwitch.on) ? @"YES" : @"NO" ] isEqualToString:@"NO"]) {
        NSLog(@"Lifts was YES and now is NO - I should remove it");
        [changesInChannels replaceObjectAtIndex:2 withObject:@"YES"];
    }
    
    
    //check for lifts
    if (previousWeatherPref==nil) {
        NSLog(@"First time - Nothing to remove from channels");
    } else if ([previousWeatherPref isEqualToString:@"YES"] && [[NSString stringWithFormat:@"%@",(_weatherSwitch.on) ? @"YES" : @"NO" ] isEqualToString:@"NO"]) {
        NSLog(@"Weather was YES and now is NO - I should remove it");
        [changesInChannels replaceObjectAtIndex:3 withObject:@"YES"];
    }
    
    //check for roads
    if (previousRoadPref==nil) {
        NSLog(@"First time - Nothing to remove from channels");
    } else if ([previousRoadPref isEqualToString:@"YES"] && [[NSString stringWithFormat:@"%@",(_roadSwitch.on) ? @"YES" : @"NO" ] isEqualToString:@"NO"]) {
        NSLog(@"Road was YES and now is NO - I should remove it");
        [changesInChannels replaceObjectAtIndex:4 withObject:@"YES"];
    }
    NSLog(@"changesInChannel Array");
    for (int i=0;i<[changesInChannels count];i++)
    {
        NSLog(@"%d:%@",i,(NSString*)changesInChannels[i]);
    }
}

-(void) removePreviousChannels
{
    PFInstallation *installation=[PFInstallation currentInstallation];
    for (int i=0;i<[changesInChannels count];i++){
        if ([(NSString*)changesInChannels[i] isEqualToString:@"YES"]){
            if (i==0){
                NSLog(@"removing installation for %d with channel name %@",i,previousSkiCenterChannel);
                [self removeInstallation:previousSkiCenterChannel forInstallation:installation];
            } else {
                NSLog(@"removing installation for %d with channel name %@",i,(NSString*)channelsNames[i]);
                [self removeInstallation:(NSString*)channelsNames[i] forInstallation:installation];
            }
        }
    }
    
    [installation saveInBackground];
    NSArray *subscribedChannels = [PFInstallation currentInstallation].channels;
    NSLog(@"%@",subscribedChannels);
}

-(NSString*) getLabelInGreek:(NSString*)text
{
    if ([text isEqualToString:@"Kalavryta"]) {
        return @"Χ.Κ. Καλαβρύτων";
    } if ([text isEqualToString:@"Parnassos"]) {
        return @"Χ.Κ. Παρνασσού";
    }
    
    return @" Κανένα";
}

-(void) setInitialValues
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *previousDictionary=[defaults objectForKey:@"DicKey"];
    
    skiCenterToRegister=[previousDictionary objectForKey:@"skiCenterPref"];
    
    [self.registeredCenterLabel setText:[self getLabelInGreek:[previousDictionary objectForKey:@"skiCenterPref"]]];
    
    if ([[previousDictionary objectForKey:@"liftsPref"] isEqualToString:@"NO"]){
        [self.liftsSwitch setOn:NO animated:NO];
    } else {
        [self.liftsSwitch setOn:YES animated:NO];
    }
    
    if ([[previousDictionary objectForKey:@"tracksPref"] isEqualToString:@"NO"]){
        [self.tracksSwitch setOn:NO animated:NO];
    } else {
        [self.tracksSwitch setOn:YES animated:NO];
    }
    
    if ([[previousDictionary objectForKey:@"weatherPref"] isEqualToString:@"NO"]){
        [self.weatherSwitch setOn:NO animated:NO];
    } else {
        [self.weatherSwitch setOn:YES animated:NO];
    }
    
    if ([[previousDictionary objectForKey:@"roadPref"] isEqualToString:@"NO"]){
        [self.roadSwitch setOn:NO animated:NO];
    } else {
        [self.roadSwitch setOn:YES animated:NO];
    }
    

}


-(void)removeInstallation:(NSString*)object forInstallation:(PFInstallation*)installation
{
    [installation removeObject:object forKey:@"channels"];
}
- (IBAction)goToInfo:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    NotificationInfo *vc = [sb instantiateViewControllerWithIdentifier:@"NotificationInfoID"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}
- (IBAction)closeTut:(id)sender {
    self.tutorial.hidden=YES;
    self.tutorial.userInteractionEnabled = NO;
    self.closeTutorial.hidden= YES;
    self.closeTutorial.userInteractionEnabled = NO;
}
@end

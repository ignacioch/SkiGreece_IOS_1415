//
//  InfoScreen.m
//  Ski Greece
//
//  Created by VimaTeamGr on 10/27/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "InfoScreen.h"
#import "PSLocationManager.h"
#import <VTAcknowledgementsViewController/VTAcknowledgementsViewController.h>

@interface InfoScreen ()

@end

@implementation InfoScreen

@synthesize backgroundImg=_backgroundImg;
@synthesize copyright=_copyright;
@synthesize homeBtn=_homeBtn;
@synthesize locationSwitch=_locationSwitch;

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
	// Do any additional setup after loading the view.
    
    // alocate and initialize scroll
    UIScrollView *myScroll;
    if (IS_IPHONE_6) {
        myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0f, 80.0f, SCREEN_WIDTH - 20.0f,300.0f  + OFFSET_H_6)];
    } else {
        myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0f, 80.0f, SCREEN_WIDTH - 20.0f,300.0f )];
    }
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    if (IS_IPHONE_6) {
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_no_back_5.png"]];
        
        myScroll.frame= CGRectMake(myScroll.frame.origin.x, myScroll.frame.origin.y + OFFSET_IOS_7, myScroll.frame.size.width + OFFSET_W_6, myScroll.frame.size.height + OFFSET_H_6);
        
        self.homeBtn.frame = CGRectMake(SCREEN_WIDTH - self.homeBtn.frame.size.width , SCREEN_HEIGHT - self.homeBtn.frame.size.height , self.homeBtn.frame.size.width, self.homeBtn.frame.size.height);
        
        self.copyright.frame = CGRectMake(self.copyright.frame.origin.x, SCREEN_HEIGHT - self.copyright.frame.size.height, self.copyright.frame.size.width, self.copyright.frame.size.height);
    } else if (IS_IPHONE_5) {
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_no_back_5.png"]];
        
        myScroll.frame= CGRectMake(myScroll.frame.origin.x, myScroll.frame.origin.y + OFFSET_IOS_7, myScroll.frame.size.width, myScroll.frame.size.height + OFFSET_5);
        
        self.homeBtn.frame = CGRectMake(self.homeBtn.frame.origin.x, self.homeBtn.frame.origin.y + OFFSET_IOS_7 + OFFSET_5, self.homeBtn.frame.size.width, self.homeBtn.frame.size.height);
        
        self.copyright.frame = CGRectMake(self.copyright.frame.origin.x, self.copyright.frame.origin.y + OFFSET_IOS_7 + OFFSET_5, self.copyright.frame.size.width, self.copyright.frame.size.height);
        
    } else { //iphone 3GS,4,4S
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , self.backgroundImg.frame.size.width, self.backgroundImg.frame.size.height);
            myScroll.frame= CGRectMake(myScroll.frame.origin.x, myScroll.frame.origin.y + OFFSET_IOS_7, myScroll.frame.size.width, myScroll.frame.size.height);
            
            self.homeBtn.frame = CGRectMake(self.homeBtn.frame.origin.x, self.homeBtn.frame.origin.y + OFFSET_IOS_7, self.homeBtn.frame.size.width, self.homeBtn.frame.size.height);
            
            self.copyright.frame = CGRectMake(self.copyright.frame.origin.x, self.copyright.frame.origin.y + OFFSET_IOS_7, self.copyright.frame.size.width, self.copyright.frame.size.height);
            
        }
    }
    
    // alocate and initialize labels
    UILabel *info= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH - 30.0f, 20.0f)];
    [info setBackgroundColor:[UIColor clearColor]];
    
    NSString * infotxt=@"Το Ski Greece σου παρέχει όλες τις πληροφορίες που χρειάζεσαι για να γίνει η εμπειρία σου στο βουνό πιο ευχάριστη.\n Μέσω του Live News, μπορείς να έχεις εικόνα για την κατάσταση λειτουργίας που επικρατεί αυτή τη στιγμή στο Χιονοδρομικό Κέντρο της επιλογής σου. Ενημερώνεσαι για τις ανοικτές πίστες, τους αναβατήρες, τον καιρό, ενώ με τις live cameras έχεις ζωντανή εικόνα ανά πάσα στιγμή. \nΜε το Track my Day μπορείς πλέον να καταγράψεις τα χιλιόμετρα που έγραψες πάνω στο βουνό. Πάτησε το \"Start\" και η εφαρμογή καταγράφει κάθε σου κίνηση. Με το \"Reset\" μηδενίζεις τα νούμερα που έχεις ήδη γράψει και σε περίπτωση που θέλεις να σταματήσεις για λίγο με το \"Pause\" σταματάς και συνεχίζεις να γράφεις όποτε εσύ το επιθυμείς απλά ξαναπατώντας το ίδιο button. Μόλις τελειώσεις την διαδρομή σου, πάτα το \"Stop\" και βλέπεις αυτόματα την διαδρομή σου πάνω στον χάρτη. Μοιράσου τις επιδόσεις σου με τους φίλους σου στα Social Media, και...σίγουρα πλέον δεν θα μπορεί να σε αμφισβητήσει κανείς! \n Μέσω του NotifyΜe μπορείς να γραφτείς σε κανάλια ενημέρωσης για να λαμβάνεις push notifications για το αγαπημένο σου Χιονοδρομικό Κέντρο. Το μόνο που έχεις να κάνεις είναι να διαλέξεις ανάμεσα στις επιλογές που σε ενδιαφέρουν, και να λαμβάνεις push notifications όταν προκύπτει κάποια αλλαγή. \n Με το NearBy έχεις τη δυνατότητα να βρεις σημεία ενδιαφέροντος στην ευρύτερη περιοχή γύρω από τα Χιονοδρομικά Κέντρα. Στο κάτω μέρος της οθόνης υπάρχουν περισσότερες πληροφορίες τις οποίες και μπορείς να δεις απλά σύροντας το βέλος προς τα επάνω.\n Γίνε μέλος του πρώτου Social Community αποκλειστικά για Ski και Snowboard. Ανέβασε φωτογραφίες από το βουνό, μοιράσου τις εμπειρίες σου και ταξίδεψε με την παρέα του Ski Greece στον κόσμο των χειμερινών σπορ. ";
    info.lineBreakMode = UILineBreakModeWordWrap;
    info.numberOfLines = 0;
    [info setFont:[UIFont fontWithName:@"Myriad Pro" size:11.0f]];
    [info setTextColor:[UIColor colorWithRed:(183/255.f) green:(183/255.f) blue:(183/255.f) alpha:1.0f]];

    
    CGSize maximumLabelSize = CGSizeMake(296,9999);
    
    CGSize expectedLabelSize = [infotxt sizeWithFont:info.font
                                      constrainedToSize:maximumLabelSize
                                          lineBreakMode:info.lineBreakMode];
    
    
    //adjust the label the the new height.
    CGRect newFrame = info.frame;
    newFrame.size.height = expectedLabelSize.height;
    info.frame = newFrame;
    info.text = infotxt;
    
    /*title for terms and conditions*/
    UILabel *tc= [[UILabel alloc] initWithFrame:CGRectMake(info.frame.origin.x, info.frame.origin.y + info.frame.size.height + 10.0f, SCREEN_WIDTH - 30.0f, 20.0f)];
    tc.text = @"Όροι χρήσης";
    [tc setFont:[UIFont fontWithName:@"Myriad Pro" size:14.0f]];
    [tc setBackgroundColor:[UIColor clearColor]];

    
    /*terms and conditions*/
    
    UILabel *terms= [[UILabel alloc] initWithFrame:CGRectMake(tc.frame.origin.x , tc.frame.origin.y + tc.frame.size.height + 10.0f, SCREEN_WIDTH - 30.0f, 20.0f)];
    
    NSString * termstxt=@"Ο χρήστης εγγράφεται στο Community είτε δημιουργώντας νέο λογαριασμό, είτε κάνοντας σύνδεση με λογαριασμό Facebook. Σε περίπτωση που δημιουργήσει νέο λογαριασμό, δεν απαιτείται mail ενεργοποίησης. Ο κωδικός του λογαριασμού αποθηκεύται στο Server κρυπτογραφημένος και δεν είναι ορατός ούτε απο τους διαχειριστές της εφαρμογής Ski Greece, ώστε να διασφαλιστεί η ασφάλεια των προσωπικών δεδομένων. Ο χρήστης έχει κάθε δικάιωμα στα δικά του posts, συνεπώς και μπορεί ανα πάσα στιγμή να τα διαγράψει. Απαγορεύονται τα posts με υβριστικό, ρατσιστικό και σεξουαλικό περιεχόμενο, και η ομάδα του Ski Greece διατηρεί κάθε δικαίωμα να τα διαγράψει χωρίς προειδοποίηση και να αποκλείσει τους χρήστες. Για οποιοδήποτε πρόβλημα που αφορά στη λειτουργία της εφαρμογής ή διαφωνία με τους όρους χρήσης παρακαλούμε επικοινωνήστε μαζί μας στο email info@skigreece.gr. ";
    terms.lineBreakMode = UILineBreakModeWordWrap;
    terms.numberOfLines = 0;
    [terms setFont:[UIFont fontWithName:@"Myriad Pro" size:11.0f]];
    [terms setTextColor:[UIColor colorWithRed:(183/255.f) green:(183/255.f) blue:(183/255.f) alpha:1.0f]];
    [terms setBackgroundColor:[UIColor clearColor]];

    
    
    expectedLabelSize = [termstxt sizeWithFont:terms.font
                                   constrainedToSize:maximumLabelSize
                                       lineBreakMode:info.lineBreakMode];
    
    
    newFrame = terms.frame;
    newFrame.size.height = expectedLabelSize.height;
    terms.frame = newFrame;
    terms.text = termstxt;
    
    /*credits title*/
    UILabel *cred= [[UILabel alloc] initWithFrame:CGRectMake(info.frame.origin.x, terms.frame.origin.y + terms.frame.size.height + 10.0f, SCREEN_WIDTH - 30.0f, 20.0f)];
    cred.text = @"Credits";
    [cred setFont:[UIFont fontWithName:@"Myriad Pro" size:14.0f]];
    [cred setBackgroundColor:[UIColor clearColor]];

    
    /*credits text*/
    
    UILabel *credits= [[UILabel alloc] initWithFrame:CGRectMake( cred.frame.origin.x , cred.frame.origin.y + cred.frame.size.height + 10.0f, SCREEN_WIDTH - 30.0f, 20.0f)];
    
    NSString * creditstxt=@"Ευχαριστούμε όλους όσους βοήθησαν στην παραγωγή της εφαρμογής Ski Greece. Οι βιβλιοθήκες που χρησιμοποιούνται είναι open-source licensed. Τα γραφικά έγιναν από την εταιρεία Crodek Ltd.";
    credits.lineBreakMode = UILineBreakModeWordWrap;
    credits.numberOfLines = 0;
    [credits setFont:[UIFont fontWithName:@"Myriad Pro" size:11.0f]];
    [credits setTextColor:[UIColor colorWithRed:(183/255.f) green:(183/255.f) blue:(183/255.f) alpha:1.0f]];
    [credits setBackgroundColor:[UIColor clearColor]];

    
    
    expectedLabelSize = [creditstxt sizeWithFont:terms.font
                             constrainedToSize:maximumLabelSize
                                 lineBreakMode:info.lineBreakMode];
    
    
    
    newFrame = credits.frame;
    newFrame.size.height = expectedLabelSize.height;
    credits.frame = newFrame;
    credits.text=creditstxt;
    
    /*option for location tracking text*/
    //?? removed for now
    
    UIButton *goToCreditsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [goToCreditsButton addTarget:self
               action:@selector(openCredits:)
     forControlEvents:UIControlEventTouchUpInside];
    [goToCreditsButton setTitle:@"View Credits >" forState:UIControlStateNormal];
    goToCreditsButton.frame = CGRectMake( credits.frame.origin.x , credits.frame.origin.y + credits.frame.size.height + 30.0f, 200.0f, 50.0f);
    goToCreditsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
//    UILabel *option_loc= [[UILabel alloc] initWithFrame:CGRectMake( credits.frame.origin.x , credits.frame.origin.y + credits.frame.size.height + 30.0f, 200.0f, 50.0f)];
//    
//    NSString * options_loc_txt=@"Επιθυμώ να λαμβάνω προσφορές από επιχειρήσεις όταν βρίσκομαι στα ΧΚ (με χρήση της τοποθεσίας μου).";
//    option_loc.lineBreakMode = UILineBreakModeWordWrap;
//    option_loc.numberOfLines = 4;
//    [option_loc setFont:[UIFont fontWithName:@"Myriad Pro" size:11.0f]];
//    [option_loc setTextColor:[UIColor blackColor]];
//    [option_loc setBackgroundColor:[UIColor clearColor]];
//    
//    
//    
//    /*expectedLabelSize = [options_loc_txt sizeWithFont:option_loc.font
//                               constrainedToSize:maximumLabelSize
//                                   lineBreakMode:option_loc.lineBreakMode];
//    
//    NSLog(@"Expected label size:%f",expectedLabelSize.height);
//    newFrame = option_loc.frame;
//    newFrame.size.height = expectedLabelSize.height;
//    option_loc.frame = newFrame;*/
//    option_loc.text=options_loc_txt;
//    
//    /*add the switch*/
//    CGRect myFrame = CGRectMake(credits.frame.origin.x + 210.0f , credits.frame.origin.y + credits.frame.size.height + 30.0f, 230.0f, 30.0f);
//    //create and initialize the slider
//    self.locationSwitch = [[UISwitch alloc] initWithFrame:myFrame];
//    //set the switch to ON or OFF based on the preferences
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    if(![defaults boolForKey:@"wantLocTarget"]) {
//        NSLog(@"User does not want to see Location targeting adverts");
//        [defaults setBool:false forKey:@"wantLocTarget"];
//        [defaults synchronize];
//        [self.locationSwitch setOn:NO];
//    } else
//    {
//        NSLog(@"User want to see Location targeting adverts");
//        [defaults setBool:true forKey:@"wantLocTarget"];
//        [defaults synchronize];
//        [self.locationSwitch setOn:YES];
//    }
//    
//    
//    //attach action method to the switch when the value changes
//    [self.locationSwitch addTarget:self
//                      action:@selector(switchIsChanged:)
//            forControlEvents:UIControlEventValueChanged];

    
    
    // set scroll view size
    myScroll.contentSize = CGSizeMake(SCREEN_WIDTH - 20.0f, info.frame.size.height + tc.frame.size.height + terms.frame.size.height + cred.frame.size.height + credits.frame.size.height + goToCreditsButton.frame.size.height + 80.0f);
    myScroll.delegate = self;
    [myScroll setScrollEnabled:YES];
    // add myLabel
    [myScroll addSubview:info];
    [myScroll addSubview:tc];
    [myScroll addSubview:terms];
    [myScroll addSubview:cred];
    [myScroll addSubview:credits];
    [myScroll addSubview:goToCreditsButton];
    [myScroll addSubview:self.locationSwitch];
    // add scroll view to main view
    [self.view addSubview:myScroll];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        imgView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:imgView];
    }
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//check if the switch is currently ON or OFF
- (void) switchIsChanged:(UISwitch *)paramSender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([paramSender isOn]){
        NSLog(@"The switch is turned on.");
        [defaults setBool:true forKey:@"wantLocTarget"];
        [defaults synchronize];
        // when turned on I should registered in the regions
        
        //[[PSLocationManager sharedLocationManager] initializeLocationManager];
        NSArray *geofences = [[PSLocationManager sharedLocationManager] buildGeofenceData];
        [[PSLocationManager sharedLocationManager] initializeRegionMonitoring:geofences];
        [[PSLocationManager sharedLocationManager] currentMonitoringRegions];
    } else {
        NSLog(@"The switch is turned off.");
        [defaults setBool:false forKey:@"wantLocTarget"];
        [defaults synchronize];
        // when turned off I should un-register from the regions
        [[PSLocationManager sharedLocationManager] stopMonitoringForRegions];

    }
}

-(void)openCredits:(UIButton*)sender
{
//    VTAcknowledgementsViewController *viewController = [VTAcknowledgementsViewController acknowledgementsViewController];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Pods-Ski Greece-acknowledgements" ofType:@"plist"];
    VTAcknowledgementsViewController *viewController = [[VTAcknowledgementsViewController alloc] initWithAcknowledgementsPlistPath:path];
    viewController.headerText = NSLocalizedString(@"We love open source software.", nil); // optional
    [self presentViewController:viewController animated:YES completion:NULL];

}
@end

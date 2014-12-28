//
//  CenterMoreInfoV2.m
//  Ski Greece
//
//  Created by VimaTeamGr on 12/28/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import "CenterMoreInfoV2.h"
#import "AppDelegate.h"
//#import "UIImageView+WebCache.h"
#import "SingleWebview.h"
#import "SingleMap.h"
#import "MBProgressHUD.h"
#import "Flurry.h"
#import "GalleryViewController.h"

@interface CenterMoreInfoV2 ()
{
    int cnt_id;
    NSString *ski_center;
    NSArray *centers_labels;
    int condit;
    NSString *dialog_title;
    NSString *dialog_message;
    NSString *email;
    NSString *telephone;
    NSString *centerUrl;
    NSString *address;
    MBProgressHUD *hud;
}

@end

@implementation CenterMoreInfoV2
@synthesize more_info_back,more_info_center_label,more_info_image,more_info_condition_label;
@synthesize more_info_label;
//@synthesize centerDescription=_centerDescription;

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
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud show:YES];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ski_center=delegate.center;
    condit=delegate.cond;
    cnt_id=delegate.cent_id;
    
    if (condit == 0) {
        [more_info_condition_label setImage:[UIImage imageNamed:@"more_info_label_closed"]];
    } else {
        [more_info_condition_label setImage:[UIImage imageNamed:@"button_opened2"]];
    }
    
    centers_labels = [NSArray arrayWithObjects:@"Χ.Κ. Παρνασσού",@"Χ.Κ. Καλαβρύτων",@"Χ.Κ. Βασιλίτσας",@"Χ.Κ. Καιμακτσαλάν",@"Χ.Κ. Σελίου",@"Χ.Κ. Πηλίου",@"Χ.Κ. 3-5 Πηγάδια",@"Χ.Κ. Πισοδερίου",@"Χ.Κ. Καρπενησίου",@"Χ.Κ. Ελατοχωρίου",@"Χ.Κ. Λαιλιά",@"Χ.Κ. Μαινάλου",@"Χ.Κ. Φαλακρού",@"Χ.Κ. Ανηλίου",@"Χ.Κ. Περτουλίου",nil];
    
    /*[more_info_back setImage:[UIImage imageNamed:[NSString stringWithFormat:@"header_%@",ski_center]]];*/
    more_info_label.text = [centers_labels objectAtIndex:cnt_id];

    
    [self performSelectorInBackground:@selector(downloadImage) withObject:nil];
    
    // alocate and initialize scroll
    UIScrollView *myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0f, 305.0f, SCREEN_WIDTH-30.f, 104.0f)];
    // alocate and initialize label
    UILabel *centerLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH -30.0f, 304.0f)];
    
    centerLabel.text=[self getCenterDescription];
    // set line break mode to word wrap
    centerLabel.lineBreakMode = UILineBreakModeWordWrap;
    // set number of lines to zero
    centerLabel.numberOfLines = 0;
    myScroll.tag=30;
    if (IS_IPHONE_6) {
        // bigger font for iphone 6
        [centerLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:13.0f]];
    } else {
        [centerLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:11.0f]];
    }
    [centerLabel setTextColor:[UIColor colorWithRed:(183/255.f) green:(183/255.f) blue:(183/255.f) alpha:1.0f]];
    [centerLabel setBackgroundColor:[UIColor clearColor]];
    // resize label
    [centerLabel sizeToFit];
    
    // set scroll view size
    myScroll.contentSize = CGSizeMake(SCREEN_WIDTH-30.f, centerLabel.frame.size.height);
    NSLog(@"Content size:%f - %f",myScroll.contentSize.width, centerLabel.frame.size.height);
    myScroll.delegate = self;
    [myScroll setScrollEnabled:YES];
    // add myLabel
    [myScroll addSubview:centerLabel];
    // add scroll view to main view
    [self.view addSubview:myScroll];
    
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    if (IS_IPHONE_6) {
        
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , SCREEN_WIDTH, SCREEN_HEIGHT);
        //?? FIXME - IMAGE FOR IPHONE 6
        [self.backgroundImg setImage:[UIImage imageNamed:@"main_screen_header_iphone5.png"]];
        
        self.backBtn.frame = CGRectMake(self.backBtn.frame.origin.x, self.backBtn.frame.origin.y + OFFSET_IOS_7 , self.backBtn.frame.size.width , self.backBtn.frame.size.height);
        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            if (subview.tag == 10) {                // 10 s the ski center label and that group
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 20.0f + 25.f, subview.frame.size.width + OFFSET_W_6, subview.frame.size.height);
            } else if (subview.tag == 20) {                // 20 is the image
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 10.0f + 5.0f + 40.0f, subview.frame.size.width + OFFSET_W_6, subview.frame.size.height + 30.f);
            } else if (subview.tag == 30) {                // 30 is the scrollview
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 10.0f + 5.0f + 5.0f + 40.0f + 40.0f, subview.frame.size.width + OFFSET_W_6, subview.frame.size.height + 50.0f);
            } else if (subview.tag == 40) {                // 30 is the group for the bottom
                // width goes from 320 to 375 (+55)
                subview.frame = CGRectMake(subview.frame.origin.x, SCREEN_HEIGHT - subview.frame.size.height, subview.frame.size.width + OFFSET_W_6, subview.frame.size.height);
            }
        }
    } else if (IS_IPHONE_5) {
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_with_back_5.png"]];
        
        self.backBtn.frame = CGRectMake(self.backBtn.frame.origin.x, self.backBtn.frame.origin.y + OFFSET_IOS_7 , self.backBtn.frame.size.width , self.backBtn.frame.size.height);
        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            if (subview.tag == 10) {                // 10 s the ski center label and that group
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7, subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag == 20) {                // 20 is the image
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 10.0f + 5.0f, subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag == 30) {                // 30 is the scrollview
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 10.0f + 5.0f + 5.0f, subview.frame.size.width, subview.frame.size.height + 50.0f);
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
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(NSString*) getCenterDescription
{
    if ([@"parnassos" isEqualToString:ski_center]) {
        return [NSString stringWithFormat:@"Ο Παρνασσός είναι από τα ομορφότερα βουνά της Ελλάδας, κατάφυτο από Κεφαλονήτικα έλατα με πυκνή βλάστηση και σπάνια φυσική ομορφιά που γοητεύει τον επισκέπτη όλο το χρόνο. Το Χιονοδρομικό Κέντρο Παρνασσού, το μεγαλύτερο και αρτιότερα οργανωμένο χιονοδρομικό κέντρο της Ελλάδας λειτουργεί από Δεκέμβριο έως αρχές Μαΐου στις τοποθεσίες Κελάρια και Φτερόλακκα"];
    } else if ([@"kalavryta" isEqualToString:ski_center]) {
        return @"Το Χιονοδρομικό Κέντρο των Καλαβρύτων είναι από τα πιο φημισμένα της χώρας, γεγονός που οφείλεται εκτός από τις υπηρεσίες που προσφέρει και την ομορφιά του τοπίου, στη σχετικά μικρή απόσταση από την Αθήνα, πράγμα που διευκολύνει ακόμη και για μια μονοήμερη εξόρμηση. Λειτουργεί στη ΒΔ πλευρά του Χελμού στη θέση Βαθειά Λάκα έχοντας στο δυναμικό του τον ψηλότερο εναέριο αναβατήρα δίνοντας στον επισκέπτη τη δυνατότητα να απολαύσει μια καταπληκτική θέα που εκτείνεται ως τα νερά του Κορινθιακού Κόλπου.";
    } else if ([@"elatohori" isEqualToString:ski_center]) {
       return @"Το Χιονοδρομικό Κέντρο Ελατοχωρίου το συναντάμε στη βορειοανατολική πλευρά των Πιερίων Ορέων, στη θέση \"Παπά Χωράφι\", και σε υψόμετρο 1450μ. Βρίσκεται σε μια προνομιακή τοποθεσία με καταπληκτική θέα προς τον Όλυμπο και τον Αλιάκμονα. Οι εγκαταστάσεις του Χιονοδρομικού Κέντρου περιλαμβάνουν 10 πίστες με κυμαινόμενη υψομετρική διαφορά και με διαφορετικό βαθμό δυσκολίας ώστε να ικανοποιούνται τόσο οι έμπειροι και απαιτητικοί σκιέρ, όσο και οι αρχάριοι που πρωτοδοκιμάζουν τις δυνατότητές τους στο δημοφιλέστερο χειμερινό σπορ. Επίσης, λειτουργεί μια πίστα για snowboard και μια για έλκηθρα. Το συνολικό μήκους που έχουν οι πίστες και το δίκτυο των χιονο-διαδρόμων που τις συνδέει μεταξύ τους, ξεπερνάει τα 12.000 μ.";
    } else if ([@"kaimaktsalan" isEqualToString:ski_center]) {
        return @"Βρίσκεται στο όρος Βόρας-Καϊμακταλάν, στα όρια του νομού Πέλλας που αποτελεί το σύνορο με τα Σκόπια. Το όρος αυτό, είναι το τρίτο μεγαλύτερο σε ύψος της Ελλάδας με υψόμετρο 2.524μ. Στην κορυφή του, και επί της γραμμής των συνόρων, υπάρχει το εκκλησάκι του Προφήτη Ηλία που αποτελεί μνημείο του 1ου Παγκοσμίου Πολέμου. Η θέα από το βουνό είναι εξαιρετική και όταν το επιτρέπει ο καιρός μπορεί να παρατηρήσει κάποιος το Θερμαϊκό κόλπο και την κορυφή του Ολύμπου. Διαθέτει μακριές και φαρδιές πίστες χωρίς ιδιαίτερη δυσκολία καθώς επίσης θεωρείται ιδανικό κέντρο για βελτίωση τεχνικής και διαδρομές σε απάτητο χιόνι.";
    } else if ([@"karpenisi" isEqualToString:ski_center]) {
        return @"Πάνω στις πανέμορφες πλαγιές του όρους Τυμφρηστού ( Βελούχι) οι σύγχρονες εγκαταστάσεις του υποδέχονται τον επισκέπτη προσφέροντάς του όλες τις ανέσεις για να απολαύσει το αγαπημένο του σπορ ή τη συγκλονιστική θέα του κατάλευκου χιονισμένου τοπίου. Το Χιονοδρομικό Κέντρο Βελουχίου είναι το κοντινότερο χιονοδρομικό σε πόλη σε ολόκληρη την Ελλάδα, απέχοντας μόλις 10 χλμ από την πρωτεύουσα της Ευρυτανίας, με ομαλή και ευκρινή σηματοδότηση σε όλη την διαδρομή. Οι φίλοι του σκι, αρχάριοι ή προχωρημένοι έχουν στη διάθεσή τους 11 πίστες υψηλών προδιαγραφών, που ανταποκρίνονται σε κάθε βαθμό δυσκολίας ή εμπειρίας.";
    } else if ([@"pisoderi" isEqualToString:ski_center]) {
        return @"Στον αυχένα που σχηματίζεται στην συμβολή των οροσειρών Βαρνούντα και Βέρνου, μέσα σε μια κατάφυτη περιοχή απο φυλοβόλλα δέντρα(οξιές), βρίσκεται ένα από τα καλύτερα χιονοδρομικά κέντρα της χώρας, αυτό της Βίγλας-Πισοδερίου. Το χιονοδρομικό κέντρο της Βίγλας διαθέτει πίστες ολυμιακών προδιαγραφών δίνοντας την δυνατότητα ακόμα και στους πιο απαιτητικούς σκιερ να απολάυσουν το αγαπημένο τους σπορ.";
    } else if ([@"vasilitsa" isEqualToString:ski_center]) {
       return @"Στις ψηλότερες πλαγιές του όρους Λίγγος, βρίσκονται οι εγκαταστάσεις του χιονοδρομικού κέντρου Βασιλίτσας. Είναι ιδιαίτερο για τις fun καταστάσεις στο μικρό σαλέ αλλά και στις πλαγιές του, που αποτελούν σημείο συνάντησης αρκετών snowbarder. Άλλος ένας λόγος που το κάνει ιδιαιτέρως γνωστό είναι το μοναδικής ομορφιάς τοπίο που το περιβάλλει, αλλά και η ειδυλιακή διαδρομή για να φτάσει κανείς στα 2246 μέτρα, ανάμεσα από μαυροπεύκα και πανύψηλα ρόμπολα. Η δημιουργία και η λειτουργία του οφείλεται στους ανθρώπους του ορειβατικού σύλλογου Γρεβενών, που πίστεψαν και ουσιαστικά κατάφεραν να υλοποιήσουν ένα όνειρο τους.";
    } else if ([@"metsovo" isEqualToString:ski_center]) {
        return @"Βρίσκεται στην τοποθεσία Καρακόλι, μόλις 1.5 χλμ από το Μέτσοβο. Το τελεφερίκ κατασκευάστηκε το 1968 και απο τότε μέχρι και σήμερα λειτουργεί υπό την ευθύνη του ιδρύματος Βαρώνου Μιχάλη Τοσίτσα/ Επεκτείνεται σε υψόμετρο απο 1340 μ ως 1520 μ. Διαθέτει 3 πίστες συνολικού μήκους περίπου 2.2 χλμ και το επίπεδο δυσκολίας αφορά τόσο αρχάριους όσο και προχωρημένους. Το κέντρο διαθέτει ένα μονοθέσιο εναέριο χιονοδρομικό αναβατήρα με 82 καθίσματα. Συχνα χρησιμοποιείται και από τους σκιέρ όσο και τους επισκέπτες για απλή βόλτα.";
    } else if ([@"pertouli" isEqualToString:ski_center]) {
        return @"Πολλοί το ξέρουν και το αγαπούν από το 1985 οπότε και άρχισε να λειτουργεί. Άλλοι πάλι το μάθανε πρόσφατα καθώς δεν είναι ένα απο τα πιο διαφημισμένα χνιονοδρομικά κέντρα της χώρας. Είναι ένα από τα πιο εύκολα προσβάσιμα, καθότι βρίσκεται μολις 45' από την πόλη των Τρικάλων, ακριβώς ανάμεσα στην Ελάτη και στο Περτούλι. Με πίστες για καινούριους σκιερ αλλά και για πιο έμπειρους, με δυο σαλέ στην βάση και στην κορυφή του αλλά και δύο λιφτ, το Χιονοδρομικό Κέντρο αποτελεί πόλο έλξης για την μαγευτική περιοχή των Περτουλιωτικών λιβαδιών.";
    } else if ([@"lailias" isEqualToString:ski_center]) {
        return @"Στη βόρεια πλευρά του Aλή Mπαμπά, μέσα σε δάσος από οξυές και πεύκα, βρίσκεται το χιονοδρομικό κέντρο του Λαϊλιά, δημιούργημα του Eλληνικού Oρειβατικού Συλλόγου Σερρών. Παρά το σχετικά μέσο υψόμετρό του, ο βορινός προσανατολισμός του το βοηθά να κρατά για πολλούς μήνες το χιόνι.";
    } else if ([@"falakro" isEqualToString:ski_center]) {
        return @"Το Χιονοδρομικό Κέντρο Φαλακρού ιδρύθηκε το 1980 με πρωτοβουλίες του Ορειβατικού Συλλόγου Δράμας, με στόχο να καλύψει τις βασικές ανάγκες αναψυχής και άθλησης της γύρω περιοχής. Ωστόσο, με το πέρασμα των χρόνων, το Χιονοδρομικό Κέντρο απέκτησε τη δική του δυναμική και ένα φανατικό κοινό που το ανέδειξε σε ένα από τα πιο σημαντικά χιονοδρομικά κέντρα της χώρας και βασικό τουριστικό πόλο της Περιφέρειας Ανατολικής Μακεδονίας –Θράκης. Σημαντικό συγκριτικό πλεονέκτημα του Φαλακρού αποτελεί η μακρά περίοδος χιονοκάλυψης που οφείλεται τόσο στη γεωγραφική του θέση όσο και στο μεγάλο υψόμετρο, καθώς  η βάση του χιονοδρομικού είναι στα 1720μ και οι πίστες βρίσκονται σε υψόμετρο που φτάνει και τα 2232μ.";
    } else if ([@"pigadia" isEqualToString:ski_center]) {
       return @"Το χιονοδρομικό κέντρο των 3-5 Πηγαδίων βρίσκεται στο βορειοδυτικό μέρος του όρους Βέρμιου σε υψόμετρο 1430-2005 μέτρα. Απέχει 17 χλμ από την πόλη της Νάουσας και ο ασφαλτοστρωμένος δρόμος παραμένει ανοιχτός και κατά την χειμερινή περίοδο. Το έμπειρο και εξειδικευμένο προσωπικό φροντίζει πάντα οι πίστες να βρίσκονται σε άψογη κατάσταση, προσφέροντας ασφάλεια και μοναδικές συγκινήσεις. Επιπλέον διαθέτει σύστημα τεχνητής χιόνωσης εξασφαλίζοντας άριστη ποιότητα σε όλη την χειμερινή περίοδο.";
    } else if ([@"seli" isEqualToString:ski_center]) {
        return @"Το χιονοδρομικό κέντρο Σελίου, αποτελεί το πρώτο ιστορικά οργανωμένο χιονοδρομικό κέντρο της χώρας. Λειτουργεί από το 1934, όταν και διοργανώθηκαν οι πρώτοι αγώνες  πανελλήνιοι χιονοδρομίας. Απέχει 24 χλμ από την Βέροια, 20 χλμ από την Νάουσα, 94 χλμ από την θεσσαλονίκη και 74 χλμ από την Κοζάνη. Οι άριστες συνθήκες χιονιού, ο ελέυθερος ορίζοντας,η εκπληκτική ηλιοφάνεια και η περιορισμένη υγρασία προσφέρουν στους επισκέπτες μοναδικές εμπειρίες.";
    } else if ([@"pilio" isEqualToString:ski_center]) {
        return @"Το Χιονοδρομικό Κέντρο Πηλίου απέχει 2 χλμ από τον οικισμό των Χανίων, 8 χλμ από τον οικισμό του Αγ. Λαυρεντίου και 20 χλμ από τον Βόλο. Βρίσκεται σε υψόμετρο 1417 μέτρων, το οποίο θεωρείται ιδιαιτέρως χαμηλό για χιονοδρομικό κέντρο, γεγονός που του προσδίδει ιδιαιτερότητες όσον αφορά την κατάσταση του χιονιού και την μορφολογία του εδάφους.";
    } else if ([@"mainalo" isEqualToString:ski_center]) {
       return  @"Το χιονοδρομικό κέντρο της Οστρακίνας είναι ευκολα προσβάσιμο από την Αθήνα (μόλις 160 χλμ.) και για αυτό τον λόγο αποτελέι πόλο έλξης ανάμεσα στους λάτρεις της χιονοδρομίας και της ορειβασίας. Οι επισκέπτες μπορούν να απολαύσουν ένα ζεστό ρόφημα στο σαλέ του χιονοδρομικού ή να διανυκτερεύσουν στο καταφύγιο του Ελληνικού Ορειβατικού Συλλόγου Τρίπολης κατόπιν συνεννοησης. Το Μαίναλο είναι ιδανικό για οικογενειακές αποδράσεις. Για τους πιο απαιτητικούς, διαθέτει και δυσκολες διαδρομές με απάτητο χιόνι μέσα στο ελατόδασος.";
    }
    return @"label";
}

- (void) downloadImage{
    NSString *urlString=[NSString stringWithFormat:@"http://vimateam.gr/projects/skigreece/images/ski_center_main_photos/photos_IOS/%@.jpg",ski_center];
    NSLog(@"DownLoad Image URL is:%@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    
    [more_info_image performSelectorOnMainThread:@selector(setImage:) withObject:downloadedImage waitUntilDone:NO];
    
    //[spinner performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //[self performSelectorOnMainThread:@selector(stopSpinnerAnimating) withObject:nil waitUntilDone:NO];
}

-(void) stopSpinnerAnimating
{
    //[hud show:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    more_info_back = nil;
    more_info_center_label = nil;
    more_info_image = nil;
    more_info_text = nil;
    more_info_condition_label = nil;
    [super viewDidUnload];
}
- (IBAction)make_a_call:(id)sender {
    
    
    if ([@"parnassos" isEqualToString:ski_center]) {
        telephone=@"2234022700";
        centerUrl=@"http://www.parnassos-ski.gr";
        email=@"infoxkp@etasa.gr";
        dialog_title=@"Χ.Κ. Παρνασσού";
        dialog_message=[NSString stringWithFormat:@"Τηλέφωνο: %@ \nEmail: %@ \nWebsite:%@",telephone,email,centerUrl];
    } else if ([@"kalavryta" isEqualToString:ski_center]) {
        dialog_message=[NSString stringWithFormat:@"Τηλέφωνο: %@ \nEmail: %@ \nWebsite:%@",telephone,email,centerUrl];
        telephone=@"2692024452";
        centerUrl=@"http://www.kalavrita-ski.gr/";
        email=@"mail@kalavrita-ski.com";
        dialog_title=@"Χ.Κ. Καλαβρύτων";
    } else if ([@"elatohori" isEqualToString:ski_center]) {
        telephone=@"2351082994";
        dialog_title=@"Χ.Κ. Ελατοχωρίου";
        centerUrl=@"http://www.elatohori-ski.gr/";
        email=@"info@elatohori-ski.gr";
        dialog_message=[NSString stringWithFormat:@"Τηλέφωνο: %@ \nEmail: %@ \nWebsite:%@",telephone,email,centerUrl];
    } else if ([@"kaimaktsalan" isEqualToString:ski_center]) {
        telephone=@"2381032000";
        dialog_title=@"Χ.Κ. Καιμακτσαλάν";
        centerUrl=@"http://www.kaimaktsalan.gr/";
        email=@"kaimaktsalanpella@gmail.com";
        dialog_message=[NSString stringWithFormat:@"Τηλέφωνο: %@ \nEmail: %@ \nWebsite:%@",telephone,email,centerUrl];
    } else if ([@"karpenisi" isEqualToString:ski_center]) {
        telephone=@"2237022002";
        dialog_title=@"Χ.Κ. Καρπενησίου";
        centerUrl=@"http://www.velouxi.gr/";
        email=@"info@velouxi.gr";
        dialog_message=[NSString stringWithFormat:@"Τηλέφωνο: %@ \nEmail: %@ \nWebsite:%@",telephone,email,centerUrl];
    } else if ([@"pisoderi" isEqualToString:ski_center]) {
        telephone=@"2385045800";
        dialog_title=@"Χ.Κ. Πισοδερίου";
        centerUrl=@"http://www.vigla-ski.gr/";
        email=@"tottis@vigla-ski.gr";
        dialog_message=[NSString stringWithFormat:@"Τηλέφωνο: %@ \nEmail: %@ \nWebsite:%@",telephone,email,centerUrl];
    } else if ([@"vasilitsa" isEqualToString:ski_center]) {
        telephone=@"2462084850";
        dialog_title=@"Χ.Κ. Βασιλίτσας";
        centerUrl=@"http://www.vasilitsa.com/";
        email=@"exkb@vasilitsa.com";
        dialog_message=[NSString stringWithFormat:@"Τηλέφωνο: %@ \nEmail: %@ \nWebsite:%@",telephone,email,centerUrl];
    } else if ([@"metsovo" isEqualToString:ski_center]) {
        telephone=@"6980760850";
        dialog_title=@"Χ.Κ. Ανηλίου";
        centerUrl=@"http://www.anilio-ski.gr/";
        email=@"info@anilio-ski.gr";
        dialog_message=[NSString stringWithFormat:@"Τηλέφωνο: %@ \nEmail: %@ \nWebsite:%@",telephone,email,centerUrl];
    } else if ([@"pertouli" isEqualToString:ski_center]) {
        telephone=@"2334091385";
        dialog_title=@"Χ.Κ. Περτουλίου";
        centerUrl=@"";
        email=@"";
        dialog_message=[NSString stringWithFormat:@"Τηλέφωνο: %@ \nEmail: %@ \nWebsite:%@",telephone,email,centerUrl];
    } else if ([@"lailias" isEqualToString:ski_center]) {
        telephone=@"2321062400";
        dialog_title=@"Χ.Κ. Λαιλιά";
        centerUrl=@"";
        email=@"";
        dialog_message=[NSString stringWithFormat:@"Τηλέφωνο: %@ \nEmail: %@ \nWebsite:%@",telephone,email,centerUrl];
    } else if ([@"falakro" isEqualToString:ski_center]) {
        telephone=@"2522041811";
        dialog_title=@"Χ.Κ. Φαλακρού";
        centerUrl=@"http://www.falakro.gr/";
        email=@"info@falakro.gr";
        dialog_message=[NSString stringWithFormat:@"Τηλέφωνο: %@ \nEmail: %@ \nWebsite:%@",telephone,email,centerUrl];
    } else if ([@"pigadia" isEqualToString:ski_center]) {
        dialog_message=@"2332044981";
        dialog_title=@"Χ.Κ. Πηγαδίων";
        centerUrl=@"http://www.3-5pigadia.gr/";
        email=@"info@3-5pigadia.gr";
        dialog_message=[NSString stringWithFormat:@"Τηλέφωνο: %@ \nEmail: %@ \nWebsite:%@",telephone,email,centerUrl];
    } else if ([@"seli" isEqualToString:ski_center]) {
        dialog_message=@"2331049226";
        dialog_title=@"Χ.Κ. Σελίου";
        centerUrl=@"http://www.seli-ski.gr/";
        email=@"info@seli-ski.gr";
        dialog_message=[NSString stringWithFormat:@"Τηλέφωνο: %@ \nEmail: %@ \nWebsite:%@",telephone,email,centerUrl];
    } else if ([@"pilio" isEqualToString:ski_center]) {
        dialog_message=@"2428074048,2428074048";
        dialog_title=@"Χ.Κ. Πηλίου";
        centerUrl=@"http://www.pelionski.gr/";
        email=@"info@pelionski.gr";
        dialog_message=[NSString stringWithFormat:@"Τηλέφωνο: %@ \nEmail: %@ \nWebsite:%@",telephone,email,centerUrl];
    } else if ([@"mainalo" isEqualToString:ski_center]) {
        dialog_message=@"6987048155";
        dialog_title=@"Χ.Κ. Μαινάλου";
        centerUrl=@"http://www.mainalo.gr/ski-center.html";
        email=@"";
        dialog_message=[NSString stringWithFormat:@"Τηλέφωνο: %@ \nEmail: %@ \nWebsite:%@",telephone,email,centerUrl];
    } 
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:dialog_title
                                                      message:dialog_message
                                                     delegate:nil
                                            cancelButtonTitle:@"Ακύρωση"
                                            otherButtonTitles:@"Κλήση",@"Email",@"Website",nil];
    message.delegate=self;
    [message show];
}

#pragma mark - UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)//OK button pressed
    {
        NSLog(@"Cancel Button called");
    }
    else if(buttonIndex == 1)//make a call button pressed.
    {
        NSDictionary *articleParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         ski_center, @"Ski_Center", // Ski Center Main
         @"phoneCall",@"action",
         nil];
        
        [Flurry logEvent:@"SkiCenterInfoScreen_Contact" withParameters:articleParams];
        
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:telephone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    } else if(buttonIndex == 2)//send an email button pressed.
    {
        NSDictionary *articleParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         ski_center, @"Ski_Center", // Ski Center Main
         @"email",@"action",
         nil];
        
        [Flurry logEvent:@"SkiCenterInfoScreen_Contact" withParameters:articleParams];
        //NSString *emailTitle = @"Test Email";
        // Email Content
        NSString *messageBody = @"-- \n Email sent from SkiGreece iPhone app.";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:email];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        //[mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
        
    } else if(buttonIndex == 3)//open a website button pressed.
    {
        NSDictionary *articleParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         ski_center, @"Ski_Center", // Ski Center Main
         @"website",@"action",
         nil];
        
        [Flurry logEvent:@"SkiCenterInfoScreen_Contact" withParameters:articleParams];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        SingleWebview *vc = [sb instantiateViewControllerWithIdentifier:@"SingleWebviewID"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        vc.url=centerUrl;
        vc.name=[centers_labels objectAtIndex:cnt_id];
        [self presentViewController:vc animated:YES completion:NULL];

    }
}

#pragma mark - mail compose delegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)open_google_map:(id)sender {
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     ski_center, @"Ski_Center", // Ski Center Main
     nil];
    
    [Flurry logEvent:@"SkiCenterInfoScreen_GoogleMap" withParameters:articleParams];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SingleMap *vc = [sb instantiateViewControllerWithIdentifier:@"SingleMapID"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    CGPoint midCoordinate = CGPointFromString([self getAddress]);
    CLLocationCoordinate2D _midCoordinate = CLLocationCoordinate2DMake(midCoordinate.x, midCoordinate.y);
    vc.coordinate=_midCoordinate;
    vc.name=[centers_labels objectAtIndex:cnt_id];
    [self presentViewController:vc animated:YES completion:NULL];
}

-(NSString*) getAddress
{
    if ([@"parnassos" isEqualToString:ski_center]) {
        return @"{38.587095,22.638292}";
    } else if ([@"kalavryta" isEqualToString:ski_center]) {
        return @"{37.998731,22.190003}";
    } else if ([@"elatohori" isEqualToString:ski_center]) {
       return @"{}";
    } else if ([@"kaimaktsalan" isEqualToString:ski_center]) {
        return @"{40.875752,21.79121}";
    } else if ([@"karpenisi" isEqualToString:ski_center]) {
        return @"{39.942736,21.804047}";
    } else if ([@"pisoderi" isEqualToString:ski_center]) {
       return @"{40.747785,21.312586}";
    } else if ([@"vasilitsa" isEqualToString:ski_center]) {
        return @"{40.046242,21.097717}";
    } else if ([@"metsovo" isEqualToString:ski_center]) {
        return @"{}";
    } else if ([@"pertouli" isEqualToString:ski_center]) {
        return @"{}";
    } else if ([@"lailias" isEqualToString:ski_center]) {
        return @"{}";
    } else if ([@"falakro" isEqualToString:ski_center]) {
        return @"{41.306956,24.071999}";
    } else if ([@"pigadia" isEqualToString:ski_center]) {
        return @"{40.643557,21.962093}";
    } else if ([@"seli" isEqualToString:ski_center]) {
        return @"{}";
    } else if ([@"pilio" isEqualToString:ski_center]) {
        return @"{39.942736,21.804047}";
    } else if ([@"mainalo" isEqualToString:ski_center]) {
        return @"{37.670047,22.295559}";
    }
    return @"{}";
}

- (IBAction)open_gallery:(id)sender {
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     ski_center, @"Ski_Center", // Ski Center Main
     nil];
    
    [Flurry logEvent:@"SkiCenterInfoScreen_Gallery" withParameters:articleParams];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    GalleryViewController *vc = [sb instantiateViewControllerWithIdentifier:@"GalleryViewID"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)backAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end

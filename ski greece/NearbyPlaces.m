//
//  NearbyPlaces.m
//  Ski Greece
//
//  Created by VimaTeamGr on 10/12/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "NearbyPlaces.h"
#import "PlacesPIn.h"
#import "PlacesAnnotationView.h"
#import "LocalAPI.h"
#import "LocalPosts.h"
#import "SingleWebview.h"
#import "Flurry.h"

#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface NearbyPlaces ()

@end

@implementation NearbyPlaces
{
    int indexCount;
    CGFloat mapTopLeftX;
    CGFloat mapTopLeftY;
    CGFloat init_arrowTopLeftX;
    CGFloat init_arrowTopLeftY;
    CGFloat init_arrowCenter;
    CGFloat end_arrowTopLeftX;
    CGFloat end_arrowTopLeftY;
    CGFloat end_arrowCenter;
    CGFloat init_tableTopLeftX;
    CGFloat init_tableTopLeftY;
    CGFloat end_tableTopLeftX;
    CGFloat end_tableTopLeftY;
    CGFloat init_tableHeight;
    CGFloat end_tableHeight;
    CGFloat init_mapHeight;
    CGFloat end_mapHeight;
    NSArray *tableData;
    NSArray *tableDataEng;
    NSString *selectedPlace;
    int selectedIndex;
    NSMutableArray* dataFromServer;
    NSMutableArray* hotelsFromServer;
    NSMutableArray* foodFromServer;
    NSMutableArray* coffeeFromServer;
    NSMutableArray* skiequipFromServer;
    NSMutableArray* pinsFromServer;
    BOOL visiblePicker;
}

@synthesize placesMap=_placesMap;
@synthesize arrowImage=_arrowImage;
@synthesize postsTable=_postsTable;
@synthesize arrowForCenter=_arrowForCenter;
@synthesize skiCenterplaceholder=_skiCenterplaceholder;
@synthesize topBar=_topBar;
@synthesize tableBorder=_tableBorder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    //self = [super init];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Custom initialization
    self.titleArray = [NSMutableArray arrayWithObjects:@"    Όλες οι κατηγορίες", @"Διαμονή", @"Φαγητό", @"Καφές", @"Εξοπλισμός-Σχολές", @"Τοπικά Προιόντα", nil];
    
    indexCount = 0;
    selectedPlace=@"all";
    
    CGFloat margin = 0.0f;
	CGFloat width = (self.view.bounds.size.width - (margin * 2.0f));
	CGFloat pickerHeight = 40.0f;
	CGFloat x = margin;
	CGFloat y = 80.0f;
	//CGFloat spacing = 25.0f;
	CGRect tmpFrame = CGRectMake(x, y, width, pickerHeight);
    
	self.pickerView = [[V8HorizontalPickerView alloc] initWithFrame:tmpFrame];
	self.pickerView.backgroundColor   = [UIColor darkGrayColor];
	self.pickerView.selectedTextColor = [UIColor whiteColor];
	self.pickerView.textColor   = [UIColor grayColor];
	self.pickerView.delegate    = self;
	self.pickerView.dataSource  = self;
	self.pickerView.elementFont = [UIFont boldSystemFontOfSize:14.0f];
	self.pickerView.selectionPoint = CGPointMake(60, 0);
    
    
	// add carat or other view to indicate selected element
	UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator_new"]];
	self.pickerView.selectionIndicatorView = indicator;
    
	[self.view addSubview:self.pickerView];
    
    
    CGPoint midCoordinate = CGPointFromString([self getAddress:selectedPlace]);
    CLLocationCoordinate2D _midCoordinate = CLLocationCoordinate2DMake(midCoordinate.x, midCoordinate.y);
    
    MKCoordinateRegion viewRegion;
    if ([selectedPlace isEqualToString:@"all"]) {
        CGPoint midCoordinate = CGPointFromString(@"{39.074208,21.824312}");
        CLLocationCoordinate2D _midCoordinate = CLLocationCoordinate2DMake(midCoordinate.x, midCoordinate.y);
        viewRegion = MKCoordinateRegionMakeWithDistance(_midCoordinate, 500000, 500000);
    } else {
        viewRegion = MKCoordinateRegionMakeWithDistance(_midCoordinate, 12000, 12000);
    }
    MKCoordinateRegion adjustedRegion = [self.placesMap regionThatFits:viewRegion];
    [self.placesMap setRegion:adjustedRegion animated:YES];
    
    [self loadSelectedOptions];
    
    end_arrowTopLeftX = 0.0f;
    end_arrowTopLeftY = 182.0f;
    
    
    //??FIXME - To be taken from strings or constants
    tableData = [NSArray arrayWithObjects:@"Όλες οι περιοχές",@"Χ.Κ. Παρνασσού",@"Χ.Κ. Καλαβρύτων",@"Χ.Κ. Βασιλίτσας",@"Χ.Κ. Καιμακτσαλάν",@"Χ.Κ. Σελίου",@"Χ.Κ. Πηλίου",@"Χ.Κ. 3-5 Πηγάδια",@"Χ.Κ. Πισοδερίου",@"Χ.Κ. Καρπενησίου",@"Χ.Κ. Ελατοχωρίου",@"Χ.Κ. Λαιλιά",@"Χ.Κ. Μαινάλου",@"Χ.Κ. Φαλακρού",@"Χ.Κ. Ανηλίου",@"Χ.Κ. Περτουλίου",@"Αθήνα",@"Θεσσαλονίκη",nil];
    tableDataEng = [NSArray arrayWithObjects:@"all",@"parnassos",@"kalavryta",@"vasilitsa",@"kaimaktsalan",@"seli",@"pilio",@"pigadia",@"pisoderi",@"karpenisi",@"elatohori",@"lailias",@"mainalo",@"falakro",@"metsovo",@"pertouli",@"athens",@"thessaloniki", nil];
    
    self.skiCenterplaceholder.text=[tableData objectAtIndex:0];


    hotelsFromServer=[[NSMutableArray alloc] init];
    foodFromServer=[[NSMutableArray alloc] init];
    coffeeFromServer=[[NSMutableArray alloc] init];
    skiequipFromServer=[[NSMutableArray alloc] init];
    
    [self getData];
    
    [self updateMap:0];
    [self updateArrays:0];
    
    visiblePicker = NO;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.topBar.tintColor = [UIColor colorWithRed:(163/255.f) green:(163/255.f) blue:(163/255.f) alpha:1.0f];
    } else {
        self.topBar.barTintColor = [UIColor colorWithRed:(163/255.f) green:(163/255.f) blue:(163/255.f) alpha:1.0f];
    }
    
    UINavigationItem *buttonCarrier = [[UINavigationItem alloc]initWithTitle:@""];
    
    buttonCarrier.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"skigreece_topbar_logo.png"]];
    
    //Creating some buttons:
    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    
    
    //Putting the Buttons on the Carrier
    [buttonCarrier setLeftBarButtonItem:barBackButton];
    
    //The NavigationBar accepts those "Carrier" (UINavigationItem) inside an Array
    NSArray *barItemArray = [[NSArray alloc]initWithObjects:buttonCarrier,nil];
    
    // Attaching the Array to the NavigationBar
    [self.topBar setItems:barItemArray];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        imgView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:imgView];
    }
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    // Register Class for Cell Reuse Identifier
    //[self.postsTable registerClass:[LocalPosts class] forCellReuseIdentifier:@"LocalPostsCell"];
    
    
    /*fix it for iphone5/ios7*/
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.topBar.frame = CGRectMake(self.topBar.frame.origin.x , self.topBar.frame.origin.y + OFFSET_IOS_7, self.topBar.frame.size.width, self.topBar.frame.size.height);
        self.arrowForCenter.frame = CGRectMake(self.arrowForCenter.frame.origin.x, self.arrowForCenter.frame.origin.y + OFFSET_IOS_7, self.arrowForCenter.frame.size.width, self.arrowForCenter.frame.size.height);
        self.skiCenterplaceholder.frame = CGRectMake(self.skiCenterplaceholder.frame.origin.x, self.skiCenterplaceholder.frame.origin.y + OFFSET_IOS_7, self.skiCenterplaceholder.frame.size.width, self.skiCenterplaceholder.frame.size.height);
        //self.placesMap.frame = CGRectMake(self.placesMap.frame.origin.x, self.placesMap.frame.origin.y + OFFSET_IOS_7, self.placesMap.frame.size.width, self.placesMap.frame.size.height);
        //self.arrowImage.frame = CGRectMake(self.arrowImage.frame.origin.x, self.arrowImage.frame.origin.y + OFFSET_IOS_7, self.arrowImage.frame.size.width, self.arrowImage.frame.size.height);
        //self.postsTable.frame = CGRectMake(self.postsTable.frame.origin.x, self.postsTable.frame.origin.y + OFFSET_IOS_7, self.postsTable.frame.size.width, self.postsTable.frame.size.height + OFFSET_5);
        self.pickerView.frame = CGRectMake(self.pickerView.frame.origin.x, self.pickerView.frame.origin.y + OFFSET_IOS_7, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
        
        self.placesMap.frame = CGRectMake(0, 82 + OFFSET_IOS_7, 320, 282);
        self.postsTable.frame = CGRectMake(0, 365 + OFFSET_IOS_7, 320, 95 + OFFSET_5);
        self.arrowImage.frame = CGRectMake(0, 344 + OFFSET_IOS_7, 320, 20);
        
    } else { //iphone 3GS,4,4S
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            self.topBar.frame = CGRectMake(self.topBar.frame.origin.x , self.topBar.frame.origin.y + OFFSET_IOS_7, self.topBar.frame.size.width, self.topBar.frame.size.height);
            self.arrowForCenter.frame = CGRectMake(self.arrowForCenter.frame.origin.x, self.arrowForCenter.frame.origin.y + OFFSET_IOS_7, self.arrowForCenter.frame.size.width, self.arrowForCenter.frame.size.height);
            self.skiCenterplaceholder.frame = CGRectMake(self.skiCenterplaceholder.frame.origin.x, self.skiCenterplaceholder.frame.origin.y + OFFSET_IOS_7, self.skiCenterplaceholder.frame.size.width, self.skiCenterplaceholder.frame.size.height);
            self.placesMap.frame = CGRectMake(self.placesMap.frame.origin.x, self.placesMap.frame.origin.y + OFFSET_IOS_7, self.placesMap.frame.size.width, self.placesMap.frame.size.height);
            self.arrowImage.frame = CGRectMake(self.arrowImage.frame.origin.x, self.arrowImage.frame.origin.y + OFFSET_IOS_7, self.arrowImage.frame.size.width, self.arrowImage.frame.size.height);
            self.postsTable.frame = CGRectMake(self.postsTable.frame.origin.x, self.postsTable.frame.origin.y + OFFSET_IOS_7, self.postsTable.frame.size.width, self.postsTable.frame.size.height);
            self.pickerView.frame = CGRectMake(self.pickerView.frame.origin.x, self.pickerView.frame.origin.y + OFFSET_IOS_7, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
        }
    }
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	self.pickerView = nil;
	self.nextButton = nil;
	self.infoLabel  = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.pickerView scrollToElement:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getData
{
    NSString *tempCategory;
    if (selectedIndex == 0) {
        tempCategory=@"AllCategories";
    } else if (selectedIndex == 1) {
        tempCategory=@"Hotels";
    } else if (selectedIndex == 2) {
        tempCategory=@"Food";
    } else if (selectedIndex == 3) {
        tempCategory=@"Coffee";
    } else if (selectedIndex == 4) {
        tempCategory=@"SkiEquip";
    } else {
        tempCategory=@"AllCategories";
    }
    
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     selectedPlace, @"Ski_Center_Offers", // Ski Center Main
     tempCategory,@"Offer_Category",
     nil];
    
    [Flurry logEvent:@"Nearby_Screen" withParameters:articleParams];
    
    
    NSLog(@"I will get local data for: %@",selectedPlace);
    [[LocalAPI sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"stream",@"command",
                                             selectedPlace,@"place",
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   //got stream
                                   NSLog(@"got stream with total number of data: %lu",(unsigned long)[[json objectForKey:@"result"] count]);
                                   NSLog(@"Printing result:%@",[[json objectForKey:@"result"] description]);
                                   dataFromServer=[json objectForKey:@"result"];
                                   [self loadArrays:dataFromServer];
                                   [self.postsTable reloadData];
                               }];
}

-(void) loadArrays:(NSMutableArray*)data
{
    [hotelsFromServer removeAllObjects];
    [foodFromServer removeAllObjects];
    [coffeeFromServer removeAllObjects];
    [skiequipFromServer removeAllObjects];
    for (int i=0; i<[data count]; i++) {
        NSDictionary *current=[data objectAtIndex:i];
        int category = [[current objectForKey:@"type"] intValue];
        if (category == 1) {
            [hotelsFromServer addObject:current];
        } else if (category == 2) {
            [foodFromServer addObject:current];
        } else if (category == 3) {
            [coffeeFromServer addObject:current];
        } else if (category == 4) {
            [skiequipFromServer addObject:current];
        }
    }
}


#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
    NSLog(@"Title array count: %lu",(unsigned long)[self.titleArray count]);
	return [self.titleArray count];
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
    NSLog(@"Title:%@",[self.titleArray objectAtIndex:index]);
	return [self.titleArray objectAtIndex:index];
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
	CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
	NSString *text = [self.titleArray objectAtIndex:index];
	CGSize textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]
					   constrainedToSize:constrainedSize
						   lineBreakMode:UILineBreakModeWordWrap];
	return textSize.width + 40.0f; // 20px padding on each side
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    NSLog(@"Selected index %ld",(long)index);
    selectedIndex=index;
    [self updateArrays:index];
    [self updateMap:index];
    indexCount=index;
}

- (IBAction)backAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) goBack
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadSelectedOptions {
    [self.placesMap removeAnnotations:self.placesMap.annotations];
    [self.placesMap removeOverlays:self.placesMap.overlays];
    [self addAttractionPins];
}

- (void)addAttractionPins {
    
    [[LocalAPI sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  @"getPins",@"command",
                                                  selectedPlace,@"place",
                                                  nil]
                                    onCompletion:^(NSDictionary *json) {
                                        //got stream
                                        NSLog(@"Pins on the map : Printing result:%@",[[json objectForKey:@"result"] description]);
                                        pinsFromServer = [json objectForKey:@"result"];
                                        NSDictionary *photo;
                                        for (int i =0; i<[pinsFromServer count]; i++) {
                                            NSLog(@"Item:%d",i);
                                            photo = [pinsFromServer objectAtIndex:i];
                                            PlacesPIn *annotation = [[PlacesPIn alloc] init];
                                            NSString * pin_lat= [photo objectForKey:@"lat"];
                                            NSString * pin_lon= [photo objectForKey:@"lon"];
                                            NSString * name = [photo objectForKey:@"name"];
                                            int type =[ [photo objectForKey:@"type"] intValue];
                                            CGPoint point = CGPointFromString([NSString stringWithFormat:@"{%@,%@}",pin_lat,pin_lon]);
                                            annotation.coordinate = CLLocationCoordinate2DMake(point.x, point.y);
                                            NSLog(@"Coordinates: %@",[NSString stringWithFormat:@"{%@,%@}",pin_lat,pin_lon]);
                                            annotation.title = name;
                                            annotation.type = type;
                                            if ((selectedIndex==0) || (selectedIndex==type)) {
                                                [self.placesMap addAnnotation:annotation];
                                            }

                                            
                                        }
                                        
                                    }];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    float offset = 0.0f;
    float iphone5_offset = 0.0f;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        iphone5_offset = OFFSET_5;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        offset = OFFSET_IOS_7;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x,recognizer.view.center.y);
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        
        if (velocity.y >0)   // panning down
        {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.placesMap.frame = CGRectMake(0, 82 + offset, 320, 282);
                self.postsTable.frame = CGRectMake(0, 365 + offset, 320, 95 + iphone5_offset);
                self.arrowImage.frame = CGRectMake(0, 344 + offset, 320, 20);
            } completion:nil];
            [self.arrowImage setImage:[UIImage imageNamed:@"up.png"]];

        }
        else                // panning up
        {
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.placesMap.frame = CGRectMake(0, 82 + offset, 320, 120);
                self.postsTable.frame = CGRectMake(0, 202 + offset, 320, 258 + iphone5_offset);
                self.arrowImage.frame = CGRectMake(end_arrowTopLeftX, end_arrowTopLeftY + offset, 320, 20);
            } completion:nil];
            [self.arrowImage setImage:[UIImage imageNamed:@"down.png"]];
        }
       
    }
    
   

    
}

- (IBAction)selectSki:(id)sender {
    if (!visiblePicker) {
        //[self disappearMid];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];

        visiblePicker= YES;
        if (defaultPickerView == nil) {
            /*efaultPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(0,245,320,216) backgroundImage:@"PickerBG.png" shadowImage:@"PickerShadow.png" glassImage:@"pickerGlass.png" title:@" Επίλεξε Χιονοδρομικό"];*/
            if (screenBounds.size.height == 568) {
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
        [self.arrowForCenter setImage:[UIImage imageNamed:@"notification_arrow_up.png"] forState:UIControlStateNormal];
    } else {
        [self.arrowForCenter setImage:[UIImage imageNamed:@"notification_arrow_down.png"] forState:UIControlStateNormal];
        [defaultPickerView hidePicker];
        visiblePicker= NO;
    }
}

-(void) updateArrays:(int) category
{
    NSLog(@"Selected Category:%d Place: %@",category,selectedPlace);
    [self.postsTable reloadData];
}

-(void) updateMap:(int) category
{
    NSLog(@"Selected Category:%d Place:%@",category,selectedPlace);
    [self.placesMap removeAnnotations:self.placesMap.annotations];
    [self.placesMap removeOverlays:self.placesMap.overlays];
    [self addAttractionPins];
    
    MKCoordinateRegion viewRegion;
    CGPoint midCoordinate;
    if ([selectedPlace isEqualToString:@"all"]) {
        midCoordinate = CGPointFromString(@"{39.074208,21.824312}");
        CLLocationCoordinate2D _midCoordinate = CLLocationCoordinate2DMake(midCoordinate.x, midCoordinate.y);
        viewRegion = MKCoordinateRegionMakeWithDistance(_midCoordinate, 500000, 500000);
    } else {
        midCoordinate = CGPointFromString([self getAddress:selectedPlace]);
        CLLocationCoordinate2D _midCoordinate = CLLocationCoordinate2DMake(midCoordinate.x, midCoordinate.y);
        viewRegion = MKCoordinateRegionMakeWithDistance(_midCoordinate, 60000, 60000);
    }
    MKCoordinateRegion adjustedRegion = [self.placesMap regionThatFits:viewRegion];
    [self.placesMap setRegion:adjustedRegion animated:YES];
}


# pragma mark - mkanottationview delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    PlacesAnnotationView *annotationView = [[PlacesAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Attraction"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

// Add the following method
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    /*PlacesAnnotationView *location = (PlacesAnnotationView*)view.annotation;
    
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [self.placesMap. openInMapsWithLaunchOptions:launchOptions];*/
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        NSString* addr = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%1.6f,%1.6f&saddr=Posizione attuale", view.annotation.coordinate.latitude,view.annotation.coordinate.longitude];
        NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    else {
        NSString* addr = [NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%1.6f,%1.6f&saddr=Posizione attuale", view.annotation.coordinate.latitude,view.annotation.coordinate.longitude];
        NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
        
        
    }
}

# pragma mark - tableview delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.postsTable) {
        if (selectedIndex==0) {
            return [dataFromServer count];
        } else if (selectedIndex ==1) {
            return [hotelsFromServer count];
        } else if (selectedIndex == 2){
            return [foodFromServer count];
        } else if (selectedIndex == 3) {
            return [coffeeFromServer count];
        } else if (selectedIndex ==4) {
            return [skiequipFromServer count];
        } else return 0;
    } else {
        return [tableData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (tableView == self.postsTable) {
        NSDictionary *photo;
        if (selectedIndex == 0) {
            photo = [dataFromServer objectAtIndex:indexPath.row];
        } else if (selectedIndex == 1) {
            photo = [hotelsFromServer objectAtIndex:indexPath.row];
        } else if (selectedIndex == 2) {
            photo = [foodFromServer objectAtIndex:indexPath.row];
        } else if (selectedIndex == 3) {
            photo = [coffeeFromServer objectAtIndex:indexPath.row];
        } else if (selectedIndex == 4) {
            photo = [skiequipFromServer objectAtIndex:indexPath.row];
        } else {
            photo = [dataFromServer objectAtIndex:indexPath.row];
        }
        
       // NSLog(@"Selected Index:%d. Row:%d:%@",selectedIndex, indexPath.row,[photo description]);

        
        int IdPost=[[photo objectForKey:@"IdPost"] intValue];
        //int type=[[photo objectForKey:@"type"] intValue];
        NSString * name= [photo objectForKey:@"name"];
        NSString * text= [photo objectForKey:@"title"];
        
        // Custom Cell init - using tags for labels/imageviews
        // The cell structure is visible in the storyboard
        
        UITableViewCell *cell = [self.postsTable dequeueReusableCellWithIdentifier:@"LocalPostsCell" forIndexPath:indexPath];

        UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
        
        UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:101];
        
        if (name == nil || [name isEqual:[NSNull null]]) {
            // handle the place not being available
            nameLabel.text= @"";
        } else {
            nameLabel.text = name;
        }
        
        if (text == nil || [text isEqual:[NSNull null]]) {
            // handle the place not being available
            descriptionLabel.text = @"";
        } else {
            descriptionLabel.text = text;
        }
        
        UIImageView *businessImageView = (UIImageView *)[cell viewWithTag:102];
        businessImageView.frame = CGRectMake(0.0f, 0.0f, 125.0f, 78.0f);
    

    
    
        //load the image
        NSURL* imageURL = [[LocalAPI sharedInstance] urlForImageWithId:IdPost];
        
        
        AFImageRequestOperation* imageOperation =
        [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL]
                                                          success:^(UIImage *image) {
                                                              //create an image view, add it to the view
                                                              UIImageView* thumbView = [[UIImageView alloc] initWithImage: image];
                                                              thumbView.frame = CGRectMake(0,0,90,90);
                                                              thumbView.contentMode = UIViewContentModeScaleAspectFit;
                                                              businessImageView.image=thumbView.image;
                                                          }];
        
        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        [queue addOperation:imageOperation];
        

        
        return cell;
        
    //}
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tableView == self.postsTable) {
        return 80.0f;
    } /*else {
        return 34.0f;
    }*/
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.postsTable) {
        /*open url based on position and place*/
        NSDictionary *photo;
        if (selectedIndex == 0) {
            photo = [dataFromServer objectAtIndex:indexPath.row];
        } else if (selectedIndex == 1) {
            photo = [hotelsFromServer objectAtIndex:indexPath.row];
        } else if (selectedIndex == 2) {
            photo = [foodFromServer objectAtIndex:indexPath.row];
        } else if (selectedIndex == 3) {
            photo = [coffeeFromServer objectAtIndex:indexPath.row];
        } else if (selectedIndex == 4) {
            photo = [skiequipFromServer objectAtIndex:indexPath.row];
        } else {
            photo = [dataFromServer objectAtIndex:indexPath.row];
        }
        NSString* urlString=[photo objectForKey:@"url"];
        NSString * name= [photo objectForKey:@"name"];
       // NSURL *url = [NSURL URLWithString:[photo objectForKey:@"url"]];
       // [[UIApplication sharedApplication] openURL:url];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        SingleWebview *vc = [sb instantiateViewControllerWithIdentifier:@"SingleWebviewID"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        vc.url=urlString;
        vc.name=name;
        [self presentViewController:vc animated:YES completion:NULL];


    } /*else {
        NSString *placeofPhoto;
        NSLog(@"Row selected is:%d",indexPath.row);
        if (indexPath.row != [tableData count]-1) {
            placeofPhoto=[tableData objectAtIndex:indexPath.row];
            self.skiCenterplaceholder.text=placeofPhoto;
            selectedPlace=[tableDataEng objectAtIndex:indexPath.row];
        }
        NSLog(@"place: %@",placeofPhoto);
        [self appearMid];
        [self updateArrays:selectedIndex];
        [self updateMap:selectedIndex];
        [self.postsTable reloadData];
        //update map and tableView based on the plaec
    }*/
}

#pragma mark - AFPickerViewDataSource

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView {
    return [tableData count];
}


- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%@", [tableData objectAtIndex:row]];
}


#pragma mark - AFPickerViewDelegate

- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row {
    NSLog(@"Current row is: %d",row);
   /* NSString *placeofPhoto;
    placeofPhoto=[tableData objectAtIndex:row];
    self.skiCenterplaceholder.text=placeofPhoto;
    selectedPlace=[tableDataEng objectAtIndex:row];
    [self updateArrays:selectedIndex];
    [self updateMap:selectedIndex];
    //[self.postsTable reloadData];
    [self getData];
    NSLog(@"------- Picker View updated: %@ ------------",placeofPhoto);*/
    
   
}

- (void)pickerView:(AFPickerView *)pickerView hidedRow:(NSInteger)row
{
    /*change local variables*/
    NSLog(@"Selected row is: %d",row);
    
    /*load the data*/
    NSString *placeofPhoto;
    placeofPhoto=[tableData objectAtIndex:row-1];
    self.skiCenterplaceholder.text=placeofPhoto;
    selectedPlace=[tableDataEng objectAtIndex:row-1];
    [self updateArrays:selectedIndex];
    [self updateMap:selectedIndex];
    //[self.postsTable reloadData];
    [self getData];
    
    [self.arrowForCenter setImage:[UIImage imageNamed:@"notification_arrow_down.png"] forState:UIControlStateNormal];
    visiblePicker= NO;
}

-(NSString*) getAddress :(NSString *) ski_center;
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
    } else if ([@"falakro" isEqualToString:ski_center]) {
        return @"{41.306956,24.071999}";
    } else if ([@"pigadia" isEqualToString:ski_center]) {
        return @"{40.643557,21.962093}";
    } else if ([@"pilio" isEqualToString:ski_center]) {
        return @"{39.942736,21.804047}";
    } else if ([@"mainalo" isEqualToString:ski_center]) {
        return @"{37.670047,22.295559}";
    } else if ([@"athens" isEqualToString:ski_center]) {
        return @"{37.983716,23.729310}";
    } else if ([@"thessaloniki" isEqualToString:ski_center]) {
        return @"{37.983716,23.729310}";
    } else
    return @"{40.639350,22.944606}";
}

@end

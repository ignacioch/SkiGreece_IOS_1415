//
//  SingleMap.m
//  Ski Greece
//
//  Created by VimaTeamGr on 10/27/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "SingleMap.h"
#import "PlacesPIn.h"

#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface SingleMap ()

@end

@implementation SingleMap

@synthesize coordinate=_coordinate;
@synthesize name=_name;

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
    
    UINavigationItem *buttonCarrier = [[UINavigationItem alloc]initWithTitle:@""];
    
    //Creating some buttons:
    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    
    buttonCarrier.title = self.name;
    
    //Putting the Buttons on the Carrier
    [buttonCarrier setLeftBarButtonItem:barBackButton];
    
    //The NavigationBar accepts those "Carrier" (UINavigationItem) inside an Array
    NSArray *barItemArray = [[NSArray alloc]initWithObjects:buttonCarrier,nil];
    
    // Attaching the Array to the NavigationBar
    [self.topBar setItems:barItemArray];
    
    /*add topBar*/
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.topBar.tintColor = [UIColor colorWithRed:(163/255.f) green:(163/255.f) blue:(163/255.f) alpha:1.0f];
    } else {
        self.topBar.barTintColor = [UIColor colorWithRed:(163/255.f) green:(163/255.f) blue:(163/255.f) alpha:1.0f];
        //TO DO ADD CODE FOR IOS 7.0
    }
    
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.coordinate, 12000, 12000);
    MKCoordinateRegion adjustedRegion = [self.mainMap regionThatFits:viewRegion];
    [self.mainMap setRegion:adjustedRegion animated:YES];
    
    [self addPin];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.topBar.frame = CGRectMake(self.topBar.frame.origin.x , self.topBar.frame.origin.y + OFFSET_IOS_7, self.topBar.frame.size.width, self.topBar.frame.size.height);
        self.mainMap.frame= CGRectMake(self.mainMap.frame.origin.x, self.mainMap.frame.origin.y + OFFSET_IOS_7, self.mainMap.frame.size.width, self.mainMap.frame.size.height + OFFSET_5);
        
    } else { //iphone 3GS,4,4S
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            self.topBar.frame = CGRectMake(self.topBar.frame.origin.x , self.topBar.frame.origin.y + OFFSET_IOS_7, self.topBar.frame.size.width, self.topBar.frame.size.height);
            self.mainMap.frame= CGRectMake(self.mainMap.frame.origin.x, self.mainMap.frame.origin.y + OFFSET_IOS_7, self.mainMap.frame.size.width, self.mainMap.frame.size.height);
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
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addPin
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = self.coordinate;
    annotation.title = self.name;
    [self.mainMap addAnnotation:annotation];
    //annotation.subtitle = attraction[@"subtitle"];
    
}

# pragma mark - mkanottationview delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSLog(@"Annotation viewed");
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Attraction"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //annotationView.image = [UIImage imageNamed:@"driveme"];
    return annotationView;
}

// Add the following method
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    
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

-(void)goBack
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

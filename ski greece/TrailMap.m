//
//  TrailMap.m
//  Ski Greece
//
//  Created by VimaTeamGr on 9/10/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import "TrailMap.h"
#import "AppDelegate.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"

#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface TrailMap ()

@end

@implementation TrailMap
{
    NSString *cnt;
    NSString *urlAddress;
    CGFloat lastScale;
    UIImage *dataImage;
    UIScrollView * imgScrollView;
}
@synthesize img,spinner;
@synthesize trailImg=_trailImg;
@synthesize topBar=_topBar;

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
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    cnt=delegate.center;
    
    spinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center=CGPointMake(160.0,240.0 );
    spinner.hidesWhenStopped=YES;
    [self.view addSubview:spinner];
    //[spinner startAnimating];
    
    //[self performSelectorInBackground:@selector(downloadImage) withObject:nil];
    
    if ([@"parnassos" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/parnassos_map.jpg";
    } else if ([@"kalavryta" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/kalavryta_map.jpg";
    } else if ([@"vasilitsa" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/vasilitsa_map.jpg";
    } else if ([@"kaimaktsalan" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/kaimaktsalan_map.jpg";
    } else if ([@"seli" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/seli_map.jpg";
    } else if ([@"pigadia" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/pigadia_map.jpg";
    } else if ([@"pisoderi" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/pisoderi_map.jpg";
    } else if ([@"pilio" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/pilio_map.jpg";
    } else if ([@"karpenisi" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/karpenisi_map.jpg";
    } else if ([@"elatohori" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/elatohori_map.jpg";
    } else if ([@"mainalo" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/mainalo_map.jpg";
    } else if ([@"metsovo" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/metsovo_map.jpg";
    } else if ([@"lailias" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/lailias_map.jpg";
    } else if ([@"falakro" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/falakro_map.jpg";
    } else if ([@"pertouli" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/pertouli_map.jpg";
    }
    NSURL *url = [NSURL URLWithString:urlAddress];
    
     NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
     self.trailImg = [[UIImageView alloc] initWithImage:[UIImage imageWithData: imageData]];
     [self.trailImg setUserInteractionEnabled:YES];
     [self.trailImg setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
     [self.trailImg setFrame:CGRectMake(0, 45, 320, 380)];
    
    imgScrollView = [[UIScrollView alloc] initWithFrame:self.trailImg.frame];
    imgScrollView.delegate = self;
    imgScrollView.showsVerticalScrollIndicator = NO;
    imgScrollView.showsHorizontalScrollIndicator = NO;
    [imgScrollView setScrollEnabled:YES];
    [imgScrollView setClipsToBounds:YES];
    imgScrollView.minimumZoomScale = 1.0;
    imgScrollView.maximumZoomScale = 4.0;
    imgScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imgScrollView.contentSize = self.trailImg.frame.size;
    [imgScrollView addSubview:self.trailImg];

    
    [self.view addSubview:imgScrollView];
    
    /*UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
     [pinchRecognizer setDelegate:self];
     [self.trailImg addGestureRecognizer:pinchRecognizer];*/
    
    /*add topBar*/
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.topBar.tintColor = [UIColor colorWithRed:(163/255.f) green:(163/255.f) blue:(163/255.f) alpha:1.0f];
    } else {
        self.topBar.barTintColor = [UIColor colorWithRed:(163/255.f) green:(163/255.f) blue:(163/255.f) alpha:1.0f];
        //TO DO ADD CODE FOR IOS 7.0
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
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.topBar.frame = CGRectMake(self.topBar.frame.origin.x, self.topBar.frame.origin.y + OFFSET_IOS_7, self.topBar.frame.size.width, self.topBar.frame.size.height);
        
        imgScrollView.frame= CGRectMake(imgScrollView.frame.origin.x, imgScrollView.frame.origin.y + OFFSET_IOS_7, imgScrollView.frame.size.width, imgScrollView.frame.size.height + OFFSET_5);
        
        self.trailImg.frame = CGRectMake(self.trailImg.frame.origin.x, self.trailImg.frame.origin.y, self.trailImg.frame.size.width, self.trailImg.frame.size.width);
        
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        self.topBar.frame = CGRectMake(self.topBar.frame.origin.x, self.topBar.frame.origin.y + OFFSET_IOS_7, self.topBar.frame.size.width, self.topBar.frame.size.height);
        imgScrollView.frame= CGRectMake(imgScrollView.frame.origin.x, imgScrollView.frame.origin.y + OFFSET_IOS_7, imgScrollView.frame.size.width, imgScrollView.frame.size.height );
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Do your resizing
    
}

- (void) downloadImage{
    
    
    if ([@"parnassos" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/parnassos_map.jpg";
    } else if ([@"kalavryta" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/kalavryta_map.jpg";
    } else if ([@"vasilitsa" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/vasilitsa_map.jpg";
    } else if ([@"kaimaktsalan" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/kaimaktsalan_map.jpg";
    } else if ([@"seli" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/seli_map.jpg";
    } else if ([@"pigadia" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/pigadia_map.jpg";
    } else if ([@"pisoderi" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/pisoderi_map.jpg";
    } else if ([@"pilio" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/pilio_map.jpg";
    } else if ([@"karpenisi" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/karpenisi_map.jpg";
    } else if ([@"elatohori" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/elatohori_map.jpg";
    } else if ([@"mainalo" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/mainalo_map.jpg";
    } else if ([@"metsovo" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/metsovo_map.jpg";
    } else if ([@"lailias" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/lailias_map.jpg";
    } else if ([@"falakro" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/falakro_map.jpg";
    } else if ([@"pertouli" isEqualToString:cnt]){
        urlAddress=@"http://vimateam.gr/projects/skigreece/images/trails/pertouli_map.jpg";
    }
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //[img performSelectorOnMainThread:@selector(setImage:) withObject:imgdata waitUntilDone:NO];

    
    //[self.trailImg setImageWithURL:url];
    
    
    AFImageRequestOperation* imageOperation =
    [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:url]
                                                      success:^(UIImage *image) {
                                                          //create an image view, add it to the view
                                                          UIImageView* thumbView = [[UIImageView alloc] initWithImage: image];
                                                          thumbView.frame = CGRectMake(0, 0, 320, 380);
                                                          thumbView.contentMode = UIViewContentModeScaleAspectFit;
                                                          //dataImage=thumbView.image;
                                                          self.trailImg.image = thumbView.image;
                                                      }];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperation:imageOperation];
    
    [spinner performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];


}

#pragma mark - scrollview delegate methods

// Implement a single scroll view delegate method
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
    return self.trailImg;
}

#pragma mark GestureRecognizer Methods
-(void)scale:(id)sender
{
    NSLog(@"Pinch");
    UIView *imgTempGest = [sender view];
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        lastScale = 1.0;
        return;
    }
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
    
    [imgTempGest setTransform:newTransform];
    
    lastScale = [(UIPinchGestureRecognizer*)sender scale];
}

- (void)viewDidUnload
{
    img = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) goBack
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end

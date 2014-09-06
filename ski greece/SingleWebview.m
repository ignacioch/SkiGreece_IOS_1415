//
//  SingleWebview.m
//  Ski Greece
//
//  Created by VimaTeamGr on 10/27/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "SingleWebview.h"


@interface SingleWebview ()

@end

@implementation SingleWebview

@synthesize webView=_webView;
@synthesize topBar=_topBar;
@synthesize url=_url;
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
    //The UINavigationItem is neede as a "box" that holds the Buttons or other elements
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
    
    NSURL *url = [NSURL URLWithString:self.url];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.topBar.frame = CGRectMake(self.topBar.frame.origin.x , self.topBar.frame.origin.y + OFFSET_IOS_7, self.topBar.frame.size.width, self.topBar.frame.size.height);
        self.webView.frame= CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y + OFFSET_IOS_7, self.webView.frame.size.width, self.webView.frame.size.height + OFFSET_5);
       
    } else { //iphone 3GS,4,4S
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            self.topBar.frame = CGRectMake(self.topBar.frame.origin.x , self.topBar.frame.origin.y + OFFSET_IOS_7, self.topBar.frame.size.width, self.topBar.frame.size.height);
            self.webView.frame= CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y + OFFSET_IOS_7, self.webView.frame.size.width, self.webView.frame.size.height);
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
    
    /*NSLog(@"webview Y: %f Height: %f",self.webView.frame.origin.y,self.webView.frame.size.height);
    NSLog(@"topBar Y: %f Height: %f",self.topBar.frame.origin.y,self.topBar.frame.size.height);*/

    
    //Load the request in the UIWebView.
    //[weather_url loadRequest:requestObj];
    [self.webView performSelectorOnMainThread:@selector(loadRequest:) withObject:requestObj waitUntilDone:NO];

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)goBack
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

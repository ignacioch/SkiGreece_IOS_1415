//
//  WeatherViewController.m
//  Ski Greece
//
//  Created by VimaTeamGr on 9/10/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import "WeatherViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController
{
    NSString *center_name;
    MBProgressHUD *hud;

}
@synthesize weather_url;


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
    center_name=delegate.center;
    
    [self.weather_url setBackgroundColor:[UIColor clearColor]];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_with_back_5.png"]];
        
        self.backBtn.frame = CGRectMake(self.backBtn.frame.origin.x, self.backBtn.frame.origin.y + OFFSET_IOS_7, self.backBtn.frame.size.width, self.backBtn.frame.size.height);
        
        self.weather_url.frame = CGRectMake(self.weather_url.frame.origin.x, self.weather_url.frame.origin.y + OFFSET_IOS_7, self.weather_url.frame.size.width, self.weather_url.frame.size.height + OFFSET_5 - OFFSET_IOS_7);
        
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , self.backgroundImg.frame.size.width, self.backgroundImg.frame.size.height);
        
        self.backBtn.frame = CGRectMake(self.backBtn.frame.origin.x, self.backBtn.frame.origin.y + OFFSET_IOS_7, self.backBtn.frame.size.width, self.backBtn.frame.size.height);
        
        self.weather_url.frame = CGRectMake(self.weather_url.frame.origin.x, self.weather_url.frame.origin.y + OFFSET_IOS_7, self.weather_url.frame.size.width, self.weather_url.frame.size.height);
        
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
    
    [self performSelectorInBackground:@selector(downloadImage) withObject:nil];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void) downloadImage{
    NSString *urlAddress;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    urlAddress=delegate.weather_url;
    NSLog(@"WEATHER SCREEN: weather url:%@",urlAddress);
 
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    

    [weather_url performSelectorOnMainThread:@selector(loadRequest:) withObject:requestObj waitUntilDone:NO];
    
    [hud hide:YES];
}

- (void)viewDidUnload
{
    weather_url = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end

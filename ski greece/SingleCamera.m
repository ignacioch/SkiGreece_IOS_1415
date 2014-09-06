//
//  SingleCamera.m
//  Ski Greece
//
//  Created by VimaTeamGr on 12/30/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import "SingleCamera.h"
#import "AppDelegate.h"

@interface SingleCamera ()

@end

@implementation SingleCamera
@synthesize camera_display;

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

    NSString *urlAddress=[delegate.cameras_urls objectAtIndex:delegate.current_camera];
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_with_back_5.png"]];
        
        self.backBtn.frame = CGRectMake(self.backBtn.frame.origin.x, self.backBtn.frame.origin.y + OFFSET_IOS_7, self.backBtn.frame.size.width, self.backBtn.frame.size.height);
        
        self.camera_display.frame = CGRectMake(self.camera_display.frame.origin.x, self.camera_display.frame.origin.y + OFFSET_IOS_7, self.camera_display.frame.size.width, self.camera_display.frame.size.height + OFFSET_5);
        
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , self.backgroundImg.frame.size.width, self.backgroundImg.frame.size.height);
        
        self.backBtn.frame = CGRectMake(self.backBtn.frame.origin.x, self.backBtn.frame.origin.y + OFFSET_IOS_7, self.backBtn.frame.size.width, self.backBtn.frame.size.height);
        
        self.camera_display.frame = CGRectMake(self.camera_display.frame.origin.x, self.camera_display.frame.origin.y + OFFSET_IOS_7, self.camera_display.frame.size.width, self.camera_display.frame.size.height);
        
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
    
    //Load the request in the UIWebView.
    [camera_display loadRequest:requestObj];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    camera_display = nil;
    [super viewDidUnload];
}

- (IBAction)backAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end

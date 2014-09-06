//
//  NotificationInfo.m
//  Ski Greece
//
//  Created by VimaTeamGr on 11/24/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "NotificationInfo.h"

@interface NotificationInfo ()

@end

@implementation NotificationInfo

@synthesize backgroundImg=_backgroundImg;
@synthesize copyright=_copyright;
@synthesize smallButton=_smallButton;
@synthesize smallText=_smallText;

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

    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_with_back_5.png"]];
        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7, subview.frame.size.width, subview.frame.size.height);
        }
        
        self.copyright.frame = CGRectMake(self.copyright.frame.origin.x, self.copyright.frame.origin.y + OFFSET_5, self.copyright.frame.size.width, self.copyright.frame.size.height);
        self.smallText.frame = CGRectMake(self.smallText.frame.origin.x, self.smallText.frame.origin.y + OFFSET_5, self.smallText.frame.size.width, self.smallText.frame.size.height);
        self.smallButton.frame = CGRectMake(self.smallButton.frame.origin.x, self.smallButton.frame.origin.y + OFFSET_5, self.smallButton.frame.size.width, self.smallButton.frame.size.height);
        
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7, subview.frame.size.width, subview.frame.size.height);
        }
    }
    
    // Do any additional setup after loading the view.
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

- (IBAction)goBack:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)openImg:(id)sender {
    self.tutorial.hidden=NO;
    self.tutorial.userInteractionEnabled = YES;
    self.closeTutorial.hidden= NO;
    self.closeTutorial.userInteractionEnabled = YES;
}

- (IBAction)closeTut:(id)sender {
    self.tutorial.hidden=YES;
    self.tutorial.userInteractionEnabled = NO;
    self.closeTutorial.hidden= YES;
    self.closeTutorial.userInteractionEnabled = NO;
}
@end

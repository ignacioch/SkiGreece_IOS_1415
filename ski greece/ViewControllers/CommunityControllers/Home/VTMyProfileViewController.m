//
//  VTMyProfileViewController.m
//  ski greece
//
//  Created by ignacio on 06/12/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import "VTMyProfileViewController.h"
#import "AppDelegate.h"


@interface VTMyProfileViewController ()

@end

@implementation VTMyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.backgroundImg.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height +43.0f, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 43.0f);
    self.backgroundImg.image = [UIImage imageNamed:@"backgroundFromPSD@2x.png"];
    
    self.navigationBar.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height, SCREEN_WIDTH , 43.0f);
    self.containerView.frame = CGRectMake(0.0, self.navigationBar.frame.origin.y + self.navigationBar.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - self.navigationBar.frame.origin.y - self.navigationBar.frame.size.height );
    self.backButton.frame = CGRectMake(0.0f, self.navigationBar.frame.origin.y, self.backButton.frame.size.width,self.navigationBar.frame.size.height);

    
    
    /*UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
     [texturedBackgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLeather.png"]]];
     self.tableView.backgroundView = texturedBackgroundView;*/
    
    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    del.myprofileViewController = [[PAPAccountViewController alloc] init];
    [del.myprofileViewController setUser:[PFUser currentUser]];
    PAPAccountViewController *vc = del.myprofileViewController;
    vc.view.frame = self.containerView.bounds;
    [self.containerView addSubview:vc.view];
    [self.containerView setBackgroundColor:[UIColor clearColor]];
    [self addChildViewController:vc];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        imgView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:imgView];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

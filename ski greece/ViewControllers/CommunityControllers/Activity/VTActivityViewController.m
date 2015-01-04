//
//  VTActivityViewController.m
//  ski greece
//
//  Created by ignacio on 06/12/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import "VTActivityViewController.h"
#import "AppDelegate.h"

@interface VTActivityViewController ()

@end

@implementation VTActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (IS_IPHONE_6) {
        self.navBar_top.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height, SCREEN_WIDTH , 43.0f);
        self.containerView.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height +43.0f, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 43.0f);
        self.backButton.frame = CGRectMake(10.0f, [UIApplication sharedApplication].statusBarFrame.size.height, self.backButton.frame.size.width, self.backButton.frame.size.height);
    } else if (IS_IPHONE_5) {
        self.navBar_top.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height, SCREEN_WIDTH , 43.0f);
        self.containerView.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height +43.0f, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 43.0f);
        self.backButton.frame = CGRectMake(10.0f, [UIApplication sharedApplication].statusBarFrame.size.height, self.backButton.frame.size.width, self.backButton.frame.size.height);
    } else {
        self.navBar_top.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height, SCREEN_WIDTH , 43.0f);
        self.containerView.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height +43.0f, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 43.0f);
        self.backButton.frame = CGRectMake(10.0f, [UIApplication sharedApplication].statusBarFrame.size.height, self.backButton.frame.size.width, self.backButton.frame.size.height);
    }
    
    self.backgroundImg.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height +43.0f, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 43.0f);
    self.backgroundImg.image = [UIImage imageNamed:@"backgroundFromPSD@2x.png"];

    
    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    del.activityController = [[PAPActivityFeedViewController alloc] init];
    PAPActivityFeedViewController *vc = del.activityController;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

//
//  VTFindFriendsViewController.m
//  ski greece
//
//  Created by ignacio on 23/11/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import "VTFindFriendsViewController.h"

@interface VTFindFriendsViewController ()

@end

@implementation VTFindFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (IS_IPHONE_6) {
        self.topBar.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height, SCREEN_WIDTH , 43.0f);
        self.containerView.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height +43.0f, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 43.0f);
        self.backBtn.frame = CGRectMake(10.0f, [UIApplication sharedApplication].statusBarFrame.size.height, self.backBtn.frame.size.width, self.backBtn.frame.size.height);
    } else if (IS_IPHONE_5) {
        self.topBar.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height, SCREEN_WIDTH , 43.0f);
        self.containerView.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height +43.0f, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 43.0f);
        self.backBtn.frame = CGRectMake(10.0f, [UIApplication sharedApplication].statusBarFrame.size.height, self.backBtn.frame.size.width, self.backBtn.frame.size.height);
    } else {
        self.topBar.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height, SCREEN_WIDTH , 43.0f);
        self.containerView.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height +43.0f, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 43.0f);
        self.backBtn.frame = CGRectMake(10.0f, [UIApplication sharedApplication].statusBarFrame.size.height, self.backBtn.frame.size.width, self.backBtn.frame.size.height);
    }
    
    self.backgroundImg.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height +43.0f, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 43.0f);
    self.backgroundImg.image = [UIImage imageNamed:@"backgroundFromPSD@2x.png"];

    
    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    del.findFriendViewController = [[PAPFindFriendsViewController alloc] init];
    PAPFindFriendsViewController *vc = del.findFriendViewController;
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

//
//  VTHomeViewController.m
//  ski greece
//
//  Created by ignacio on 10/11/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import "VTHomeViewController.h"
#import "AppDelegate.h"

@interface VTHomeViewController ()

@property (nonatomic, strong) UIView *blankTimelineView;

@end

@implementation VTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //(AppDelegate*)[[UIApplication sharedApplication].delegate].homeViewController;
    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    PAPHomeViewController *vc = del.homeViewController;
    vc.view.frame = self.containerView.bounds;
    [self.containerView addSubview:vc.view];
    [self addChildViewController:vc];
    
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



@end

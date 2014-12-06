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
    
    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    del.activityController = [[PAPActivityFeedViewController alloc] init];
    PAPActivityFeedViewController *vc = del.activityController;
    vc.view.frame = self.containerView.bounds;
    [self.containerView addSubview:vc.view];
    [self.containerView setBackgroundColor:[UIColor clearColor]];
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

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

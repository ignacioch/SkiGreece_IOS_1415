//
//  VTEditPhotoViewController.m
//  ski greece
//
//  Created by ignacio on 10/12/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import "VTEditPhotoViewController.h"
#import "AppDelegate.h"

@interface VTEditPhotoViewController ()

@end

@implementation VTEditPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    del.editPhotoController= [[PAPEditPhotoViewController alloc] initWithImage:self.image];
    PAPEditPhotoViewController *vc = del.editPhotoController;
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

@end

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
    
    if (IS_IPHONE_6) {
        self.navBar.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height, SCREEN_WIDTH , 43.0f);
        self.containerView.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height +43.0f, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 43.0f);
        self.backButton.frame = CGRectMake(10.0f, [UIApplication sharedApplication].statusBarFrame.size.height, self.backButton.frame.size.width, self.backButton.frame.size.height);
        self.doneButton.frame = CGRectMake(SCREEN_WIDTH - self.doneButton.frame.size.width -10.0f, [UIApplication sharedApplication].statusBarFrame.size.height, self.doneButton.frame.size.width, self.doneButton.frame.size.height);
    } else  if (IS_IPHONE_5) {
        self.navBar.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height, SCREEN_WIDTH , 43.0f);
        self.containerView.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height +43.0f, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 43.0f);
        self.backButton.frame = CGRectMake(10.0f, [UIApplication sharedApplication].statusBarFrame.size.height, self.backButton.frame.size.width, self.backButton.frame.size.height);
        self.doneButton.frame = CGRectMake(SCREEN_WIDTH - self.doneButton.frame.size.width -10.0f, [UIApplication sharedApplication].statusBarFrame.size.height, self.doneButton.frame.size.width, self.doneButton.frame.size.height);
    }
    
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


- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)doneButtonPressed:(id)sender {
    PAPEditPhotoViewController *tempVC = self.childViewControllers[0];
    [tempVC doneButtonAction:sender];
}
@end

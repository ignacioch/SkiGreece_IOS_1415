//
//  VTPhotoDetailsViewController.m
//  ski greece
//
//  Created by ignacio on 16/11/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import "VTPhotoDetailsViewController.h"
#import "AppDelegate.h"

enum ActionSheetTags {
    MainActionSheetTag = 0,
    ConfirmDeleteActionSheetTag = 1
};


@interface VTPhotoDetailsViewController ()

@end

@implementation VTPhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    del.photoDetailsViewController = [[PAPPhotoDetailsViewController alloc] initWithPhoto:self.photo];
    PAPPhotoDetailsViewController *vc = del.photoDetailsViewController;
    vc.view.frame = self.containerView.bounds;
    [self.containerView addSubview:vc.view];
    [self.containerView setBackgroundColor:[UIColor clearColor]];
    [self addChildViewController:vc];
    
  if (NSClassFromString(@"UIActivityViewController")) {
       // Use UIActivityViewController if it is available (iOS 6 +)
       [self.activityBtn addTarget:self
                            action:@selector(activityButtonAction:)
                  forControlEvents:UIControlEventTouchUpInside];
  } else  if ([self currentUserOwnsPhoto]) {
      // Else we only want to show an action button if the user owns the photo and has permission to delete it.
      [self.activityBtn addTarget:self
                           action:@selector(actionButtonAction:)
                 forControlEvents:UIControlEventTouchUpInside];
  }
    
    
    
    
    //PAPPhotoDetailsViewController *photoDetailsVC = [[PAPPhotoDetailsViewController alloc] initWithPhoto:photo];
    //photoDetailsVC.view.frame = CGRectMake(0.0, 43.0f, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 43.0f);
    //[self presentViewController:photoDetailsVC animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)activityButtonAction:(id)sender {
    if (IS_DEVELOPER) NSLog(@"Calling activity Button action from father");
    [self.childViewControllers[0] activityButtonAction:sender]; //assuming you have only one child
}

- (IBAction)actionButtonAction:(id)sender{
    if (IS_DEVELOPER) NSLog(@"Calling action Button action from father");
    [self.childViewControllers[0] actionButtonAction:sender];
}


#pragma mark - ()

- (BOOL)currentUserOwnsPhoto {
    return [[[self.photo objectForKey:kPAPPhotoUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]];
}


@end

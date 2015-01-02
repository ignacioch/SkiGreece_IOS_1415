//
//  VTPhotoDetailsViewController.m
//  ski greece
//
//  Created by ignacio on 16/11/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import "VTPhotoDetailsViewController.h"
#import "AppDelegate.h"
#import "TrackDayMenuViewController.h"

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
    
    // check whether we are from push notif or usual opening
    
    if (del.openedFromNotification) {
        
        // remove the image
        // make text to be bold and set title to Done
        
        [self.backBtn setTitle:@"Done" forState:UIControlStateNormal];
        self.photo = del.photoFromNotif;
    }
    
    if (IS_IPHONE_6) {
        self.topBar.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height, SCREEN_WIDTH , 43.0f);
        self.containerView.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height +43.0f, SCREEN_WIDTH, SCREEN_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - 43.0f);
        self.backBtn.frame = CGRectMake(10.0f, [UIApplication sharedApplication].statusBarFrame.size.height, self.backBtn.frame.size.width, self.backBtn.frame.size.height);
        self.deleteBtn.frame = CGRectMake(SCREEN_WIDTH - self.activityBtn.frame.size.width -10.0f - self.deleteBtn.frame.size.width - 50.0f, self.deleteBtn.frame.origin.y + [UIApplication sharedApplication].statusBarFrame.size.height, self.deleteBtn.frame.size.width, self.deleteBtn.frame.size.height);
        self.activityBtn.frame = CGRectMake(SCREEN_WIDTH - self.activityBtn.frame.size.width -10.0f, self.activityBtn.frame.origin.y + [UIApplication sharedApplication].statusBarFrame.size.height, self.activityBtn.frame.size.width, self.activityBtn.frame.size.height);
    }
    
    del.photoDetailsViewController = [[PAPPhotoDetailsViewController alloc] initWithPhoto:self.photo];
    PAPPhotoDetailsViewController *vc = del.photoDetailsViewController;
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



- (IBAction)activityButtonAction:(id)sender {
    if (IS_DEVELOPER) NSLog(@"Calling activity Button action from father");
    [self.childViewControllers[0] activityButtonAction:sender]; //assuming you have only one child
}

- (IBAction)actionButtonAction:(id)sender{
    //if (IS_DEVELOPER) NSLog(@"Calling action Button action from father");
    //[self.childViewControllers[0] actionButtonAction:sender];
    if ([self currentUserOwnsPhoto]) {
        if (IS_DEVELOPER) NSLog(@"User is the owner of the photo");
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to delete this photo?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Yes, delete photo", nil) otherButtonTitles:nil];
        actionSheet.tag = ConfirmDeleteActionSheetTag;
        [actionSheet showInView:self.view];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No permission"
                                                        message:@"You don't have permission to delete this photo"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)backButtonAction:(id)sender {

    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (del.openedFromNotification) {
        del.openedFromNotification = NO;
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        TrackDayMenuViewController *vc=[sb instantiateViewControllerWithIdentifier:@"OpenScreen"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];
        
        
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - ()

- (BOOL)currentUserOwnsPhoto {
    return [[[self.photo objectForKey:kPAPPhotoUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]];
}

- (void)shouldDeletePhoto {
    // Delete all activites related to this photo
    PFQuery *query = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [query whereKey:kPAPActivityPhotoKey equalTo:self.photo];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteEventually];
            }
        }
        
        // Delete photo
        [self.photo deleteEventually];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPPhotoDetailsViewControllerUserDeletedPhotoNotification object:[self.photo objectId]];
    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (del.openedFromNotification) {
        del.openedFromNotification = NO;
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        TrackDayMenuViewController *vc=[sb instantiateViewControllerWithIdentifier:@"OpenScreen"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == ConfirmDeleteActionSheetTag) {
            [self shouldDeletePhoto];
        }
}



@end

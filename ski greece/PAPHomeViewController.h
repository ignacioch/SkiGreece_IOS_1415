//
//  PAPHomeViewController.h
//  Anypic
//
//  Created by Héctor Ramos on 5/3/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PAPPhotoTimelineViewController.h"

@interface PAPHomeViewController : PAPPhotoTimelineViewController <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

- (BOOL)shouldPresentPhotoCaptureController;


@property (nonatomic, assign, getter = isFirstLaunch) BOOL firstLaunch;
@property (nonatomic,assign) IBOutlet UIButton * settingsButton;

@end

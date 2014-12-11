//
//  VTEditPhotoViewController.h
//  ski greece
//
//  Created by ignacio on 10/12/2014.
//  Copyright (c) 2014 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTEditPhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *navBar;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, strong) UIImage * image;

@end

//
//  PhotoScreen.h
//  Ski Greece
//
//  Created by VimaTeamGr on 8/15/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFPickerView.h"

@class PhotoScreen;

@protocol PhotoScreenDelegate <NSObject>

- (void)photoScreenCompleted:(PhotoScreen *)controller;


@end

@interface PhotoScreen : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,AFPickerViewDataSource, AFPickerViewDelegate>
{
    AFPickerView *defaultPickerView;
}
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) UIImage *imageFromCamera;
@property (strong, nonatomic) IBOutlet UITextField *imgDescription;
@property (strong, nonatomic) IBOutlet UIButton *applyEffects;
- (IBAction)applyEffectsAction:(id)sender;
- (IBAction)uploadPhoto:(id)sender;
@property (nonatomic, weak) id <PhotoScreenDelegate> delegate;
- (IBAction)undoEffect:(id)sender;
- (IBAction)getInitialImage:(id)sender;
- (IBAction)cancelCamera:(id)sender;
@property (assign) CGPoint originalCenter;

@property (strong, nonatomic) IBOutlet UIButton *bakBtn;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;


- (IBAction)choosePlace:(id)sender;
- (IBAction)backButton:(id)sender;

@end

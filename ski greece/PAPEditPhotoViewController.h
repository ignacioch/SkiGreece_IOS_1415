//
//  PAPEditPhotoViewController.h
//  Anypic
//
//  Created by Héctor Ramos on 5/3/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

@interface PAPEditPhotoViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>

- (id)initWithImage:(UIImage *)aImage;
- (void)doneButtonAction:(id)sender;

@property (nonatomic,retain) IBOutlet UIButton * cancelButton;
@property (nonatomic,retain) IBOutlet UIButton * doneButton;


@end

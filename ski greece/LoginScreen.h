//
//  LoginScreen.h
//  Ski Greece
//
//  Created by VimaTeamGr on 8/15/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginScreen;

@protocol LoginScreenDelegate <NSObject>

- (void)loginScreenCompleted:(LoginScreen *)controller;

@end

@interface LoginScreen : UIViewController <UITextFieldDelegate>
- (IBAction)fbLogin:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *fldUsername;
@property (strong, nonatomic) IBOutlet UITextField *fldPassword;
- (IBAction)btnLoginTapped:(id)sender;
- (IBAction)btnRegisterTapped:(id)sender;
@property (nonatomic, weak) id <LoginScreenDelegate> delegate;

- (IBAction)goBack:(id)sender;


@end

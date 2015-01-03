//
//  PAPLogInViewController.m
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/17/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "PAPLogInViewController.h"

@implementation PAPLogInViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (IS_DEVELOPER) {
        NSLog(@"SCREEN_WIDTH: %f", SCREEN_WIDTH);
        NSLog(@"SCREEN_HEIGHT: %f", SCREEN_HEIGHT);
        NSLog(@"SCREEN_MAX_LENGTH: %f", SCREEN_MAX_LENGTH);
        NSLog(@"SCREEN_MIN_LENGTH: %f", SCREEN_MIN_LENGTH);
        NSLog(@"main screen height : %f", [UIScreen mainScreen].bounds.size.height);
        NSLog(@"main screen width : %f", [UIScreen mainScreen].bounds.size.width);
    }
    
    
    // There is no documentation on how to handle assets with the taller iPhone 5 screen as of 9/13/2012
    //if ([UIScreen mainScreen].bounds.size.height > 568.0f) {
    if (IS_IPHONE_6) {
        // for the iPhone 6
        if (IS_DEVELOPER) NSLog(@"iPhone 6 device");
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLogin-667h.png"]];
    } else if (IS_IPHONE_5) {
        // for the iPhone 5
        if (IS_DEVELOPER) NSLog(@"iPhone 5 device");
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLogin-568h.png"]];
    } else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLogin.png"]];
    }
    
    if (IS_DEVELOPER) NSLog(@"Background added");
    
    //NSString *text = NSLocalizedString(@"Sign up and start sharing your story with your friends.", @"Sign up and start sharing your story with your friends.");

    //NSString *text = @"Join SkiGreece and start sharing your story with your friends.";
    NSString *text = @"Μπες και εσύ στην παρέα του SkiGreece!";
    
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(255.0f, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin // wordwrap?
                                                 attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]}
                                                    context:nil].size;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake( ([UIScreen mainScreen].bounds.size.width - textSize.width)/2.0f, 380.0f, textSize.width, textSize.height)];
    [textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]];
    [textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [textLabel setNumberOfLines:0];
    [textLabel setText:text];
    [textLabel setTextColor:[UIColor colorWithRed:214.0f/255.0f green:206.0f/255.0f blue:191.0f/255.0f alpha:1.0f]];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];

    [self.logInView setLogo:nil];
    [self.logInView addSubview:textLabel];
    
    
    self.fields = PFLogInFieldsUsernameAndPassword;
    self.logInView.usernameField.placeholder = @"Enter your email";
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (IS_IPHONE_6) {
       self.logInView.facebookButton.frame = CGRectMake(self.logInView.facebookButton.frame.origin.x, 330.0f, self.logInView.facebookButton.frame.size.width, self.logInView.facebookButton.frame.size.height);
        [self.logInView.facebookButton setImage:nil forState:UIControlStateNormal];
        [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"fb_button.png"] forState:UIControlStateNormal];
    } else if (IS_IPHONE_5) {
        self.logInView.facebookButton.frame = CGRectMake(self.logInView.facebookButton.frame.origin.x, 310.0f, self.logInView.facebookButton.frame.size.width, self.logInView.facebookButton.frame.size.height);
        [self.logInView.facebookButton setImage:nil forState:UIControlStateNormal];
        [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"fb_button.png"] forState:UIControlStateNormal];
    } else {
        self.logInView.facebookButton.frame = CGRectMake(self.logInView.facebookButton.frame.origin.x, self.logInView.facebookButton.frame.origin.y + [UIApplication sharedApplication].statusBarFrame.size.height, self.logInView.facebookButton.frame.size.width, self.logInView.facebookButton.frame.size.height);
        [self.logInView.facebookButton setImage:nil forState:UIControlStateNormal];
        [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"fb_button.png"] forState:UIControlStateNormal];
    }
    
    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateNormal];
    
    if (IS_DEVELOPER) NSLog(@"Facebook button is %@ . Frame is (%f,%f,%f,%f) ", (self.logInView.facebookButton.hidden) ? @"Hidden" : @"Visible",self.logInView.facebookButton.frame.origin.x, self.logInView.facebookButton.frame.origin.y, self.logInView.facebookButton.frame.size.width, self.logInView.facebookButton.frame.size.height);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

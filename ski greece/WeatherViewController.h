//
//  WeatherViewController.h
//  Ski Greece
//
//  Created by VimaTeamGr on 9/10/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewController : UIViewController
{
    
    IBOutlet UIWebView *weather_url;
}
@property (nonatomic,strong) IBOutlet UIWebView *weather_url;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)backAction:(id)sender;

@end

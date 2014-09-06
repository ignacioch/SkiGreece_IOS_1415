//
//  DriveMeScreen.h
//  Ski Greece
//
//  Created by VimaTeamGr on 11/26/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriveMeScreen : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITableView *skiCenterTable;
@property (nonatomic, strong) NSMutableData *responseData;

- (IBAction)goBack:(id)sender;

@end

//
//  CameraList.h
//  Ski Greece
//
//  Created by VimaTeamGr on 12/30/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraList : UIViewController <UITableViewDelegate, UITableViewDataSource>

{
    
    IBOutlet UITableView *cameras_list_labels;
}
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (nonatomic,strong) IBOutlet UITableView *cameras_list_labels;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)backAction:(id)sender;


@end

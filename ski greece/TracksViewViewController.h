//
//  TracksViewViewController.h
//  Ski Greece
//
//  Created by VimaTeamGr on 9/10/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TracksViewViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

{
    IBOutlet UITableView *TracksMain;
    
}
@property (nonatomic,strong) IBOutlet UITableView *TracksMain;
@property (nonatomic,assign) NSString * skiCenter;
@property(nonatomic, assign) int total_tracks;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;


@property (nonatomic,assign) NSArray *tracksArray;

- (IBAction)backAction:(id)sender;

@end

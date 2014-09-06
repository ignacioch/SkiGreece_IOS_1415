//
//  LiftsView.h
//  Ski Greece
//
//  Created by VimaTeamGr on 9/10/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiftsView : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
    IBOutlet UITableView *LiftsMain;
}
@property (nonatomic,strong) IBOutlet UITableView *LiftsMain;
@property (nonatomic,assign) NSString * skiCenter;
@property(nonatomic, assign) int total_lifts;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic,assign) NSArray *liftsArray;


- (IBAction)backAction:(id)sender;

@end

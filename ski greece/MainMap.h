//
//  MainMap.h
//  Ski Greece
//
//  Created by VimaTeamGr on 9/5/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMap : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
    IBOutlet UITableView *mapMain;
    NSMutableData *responseData;
    //NSMutableArray *condition;
}

@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (nonatomic,strong) IBOutlet UITableView *mapMain;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic,strong)    UIActivityIndicatorView *spinner;;
- (IBAction)backAction:(id)sender;

@end

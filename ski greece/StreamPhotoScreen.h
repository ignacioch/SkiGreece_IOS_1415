//
//  StreamPhotoScreen.h
//  Ski Greece
//
//  Created by VimaTeamGr on 8/15/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LoginScreen.h"

@class StreamPhotoScreen;

@protocol StreamPhotoScreenDelegate <NSObject>

- (void)streamPhotoScreenCompleted:(StreamPhotoScreen *)controller;

@end



@interface StreamPhotoScreen : UIViewController <UITableViewDataSource, UITableViewDelegate,LoginScreenDelegate,UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *photoDescription;
@property (strong, nonatomic) IBOutlet UITableView *commentsTable;
@property (strong, nonatomic) IBOutlet UITextField *commentPlaceholder;
- (IBAction)makeComment:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *likes;
@property (strong, nonatomic) IBOutlet UILabel *comments;
@property (nonatomic, retain) NSDictionary  *stats;
- (IBAction)goBack:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *photoPlace;
@property (nonatomic, weak) id <StreamPhotoScreenDelegate> delegate;
@property (nonatomic,strong) NSMutableArray * dataFromServer;
@property (assign) CGPoint originalCenter;
@property (strong, nonatomic) IBOutlet UIImageView *littleArrow;
@property (strong, nonatomic) IBOutlet UIImageView *imgBack;
@property (strong, nonatomic) IBOutlet UINavigationBar *topBar;
@property (strong, nonatomic) IBOutlet UIButton *commentBtnPlaceholder;
@property (strong, nonatomic) IBOutlet UIButton *formerBackBtn;
- (IBAction)likeAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;




@end

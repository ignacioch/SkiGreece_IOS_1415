//
//  LikeUsPrompt.h
//  Ski Greece
//
//  Created by VimaTeamGr on 11/2/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LikeUsPrompt;
@protocol LikeUsDelegate <NSObject>

- (void)likeUsCompleted:(LikeUsPrompt *)controller;

@end

@interface LikeUsPrompt : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *mainAdImg;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UIButton *skipBtn;
@property (nonatomic, weak) id <LikeUsDelegate> delegate;
@property (nonatomic,assign) NSString * offerUrl;



- (IBAction)skipAction:(id)sender;
@end

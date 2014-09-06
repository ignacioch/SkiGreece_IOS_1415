//
//  PhotoStreamCell.h
//  Ski Greece
//
//  Created by VimaTeamGr on 8/18/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoStreamCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;
@property (strong, nonatomic) IBOutlet UILabel *headerUser;
@property (strong, nonatomic) IBOutlet UILabel *imageText;
@property (strong, nonatomic) IBOutlet UIButton *deletePhoto;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UILabel *no_likes;
@property (strong, nonatomic) IBOutlet UILabel *no_comments;
@property (strong, nonatomic) IBOutlet UILabel *datePlace;
@property (strong, nonatomic) IBOutlet UIImageView *imgBack;
@property (strong, nonatomic) IBOutlet UIButton *facebookBtn;
@property (strong, nonatomic) IBOutlet UIButton *twitterBtn;

@end

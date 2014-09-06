//
//  PostStreamCell.h
//  Ski Greece
//
//  Created by VimaTeamGr on 8/18/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostStreamCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *postText;
@property (strong, nonatomic) IBOutlet UILabel *headerUser;
@property (strong, nonatomic) IBOutlet UIButton *deletePost;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UILabel *no_likes;
@property (strong, nonatomic) IBOutlet UILabel *no_comments;
@property (strong, nonatomic) IBOutlet UILabel *datePlace;

@end

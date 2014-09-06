//
//  CameraInitCell.m
//  Ski Greece
//
//  Created by VimaTeamGr on 12/30/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import "CameraInitCell.h"

@implementation CameraInitCell
@synthesize camera_title=_camera_title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

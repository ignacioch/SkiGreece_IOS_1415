//
//  LiftsCell.m
//  Ski Greece
//
//  Created by VimaTeamGr on 9/10/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import "LiftsCell.h"

@implementation LiftsCell
@synthesize name=_name;

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

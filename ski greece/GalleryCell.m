//
//  GalleryCell.m
//  Ski Greece
//
//  Created by VimaTeamGr on 1/4/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "GalleryCell.h"

@implementation GalleryCell
@synthesize galleryphoto=_galleryphoto;

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

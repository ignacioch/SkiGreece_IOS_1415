//
//  GalleryViewController.h
//  Ski Greece
//
//  Created by VimaTeamGr on 1/4/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
    IBOutlet UITableView *gallery_photos;
    NSMutableData *responseData;
}
@property (nonatomic,strong) IBOutlet UITableView *gallery_photos;
@property (nonatomic,strong) NSMutableData *responseData;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)goBack:(id)sender;
@end

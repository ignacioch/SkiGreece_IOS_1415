//
//  TrailMap.h
//  Ski Greece
//
//  Created by VimaTeamGr on 9/10/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrailMap : UIViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    
    IBOutlet UIImageView *img;
    UIActivityIndicatorView *spinner;
}
@property (nonatomic,strong) IBOutlet UIImageView *img;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIImageView *trailImg;
@property (strong, nonatomic) IBOutlet UINavigationBar *topBar;

- (IBAction)backButton:(id)sender;
@end

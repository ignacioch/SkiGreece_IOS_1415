//
//  TracksViewViewController.m
//  Ski Greece
//
//  Created by VimaTeamGr on 9/10/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import "TracksViewViewController.h"
#import "AppDelegate.h"
#import "LiftsCell.h"

@interface TracksViewViewController ()

@end

@implementation TracksViewViewController

@synthesize TracksMain;
@synthesize skiCenter=_skiCenter;
@synthesize total_tracks=_total_tracks;
@synthesize backgroundImg=_backgroundImg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_with_back_5.png"]];
        
        self.backBtn.frame = CGRectMake(self.backBtn.frame.origin.x, self.backBtn.frame.origin.y + OFFSET_IOS_7, self.backBtn.frame.size.width, self.backBtn.frame.size.height);
        self.TracksMain.frame = CGRectMake(self.TracksMain.frame.origin.x, self.TracksMain.frame.origin.y + OFFSET_IOS_7, self.TracksMain.frame.size.width, self.TracksMain.frame.size.height);
        
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , self.backgroundImg.frame.size.width, self.backgroundImg.frame.size.height);
        
        self.backBtn.frame = CGRectMake(self.backBtn.frame.origin.x, self.backBtn.frame.origin.y + OFFSET_IOS_7, self.backBtn.frame.size.width, self.backBtn.frame.size.height);
         self.TracksMain.frame = CGRectMake(self.TracksMain.frame.origin.x, self.TracksMain.frame.origin.y + OFFSET_IOS_7, self.TracksMain.frame.size.width, self.TracksMain.frame.size.height);
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        imgView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:imgView];
    }
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidUnload
{
    TracksMain = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tracksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"LiftsCell";
    
    
    LiftsCell *cell = (LiftsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    tableView.backgroundColor=[UIColor clearColor];
    tableView.opaque=NO;
    tableView.backgroundView=nil;
    
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LiftsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *data = [self.tracksArray objectAtIndex:indexPath.row];
    NSLog(@"Lift :%d Data:%@",indexPath.row,data);
    
    cell.name.text = [data objectForKey:@"name"];
    int open = [[data objectForKey:@"open"] intValue];
    
    if (open == 0) {
        cell.name.textColor = [UIColor redColor];
    } else {
        cell.name.textColor = [UIColor greenColor];
    }
    
    cell.backgroundColor = [UIColor clearColor];

    
    return cell;
}



- (IBAction)backAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end

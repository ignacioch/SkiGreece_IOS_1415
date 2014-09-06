//
//  LiftsView.m
//  Ski Greece
//
//  Created by VimaTeamGr on 9/10/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import "LiftsView.h"
#import "AppDelegate.h"
#import "LiftsCell.h"


@interface LiftsView ()

@end

@implementation LiftsView
{
    NSString *cent;
}
@synthesize LiftsMain;
@synthesize backgroundImg=_backgroundImg;
@synthesize liftsArray=_liftsArray;

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
    
    cent=self.skiCenter;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_with_back_5.png"]];
        
        self.backBtn.frame = CGRectMake(self.backBtn.frame.origin.x, self.backBtn.frame.origin.y + OFFSET_IOS_7, self.backBtn.frame.size.width, self.backBtn.frame.size.height);
        self.LiftsMain.frame = CGRectMake(self.LiftsMain.frame.origin.x, self.LiftsMain.frame.origin.y + OFFSET_IOS_7, self.LiftsMain.frame.size.width, self.LiftsMain.frame.size.height);
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , self.backgroundImg.frame.size.width, self.backgroundImg.frame.size.height);
        
        self.backBtn.frame = CGRectMake(self.backBtn.frame.origin.x, self.backBtn.frame.origin.y + OFFSET_IOS_7, self.backBtn.frame.size.width, self.backBtn.frame.size.height);
        self.LiftsMain.frame = CGRectMake(self.LiftsMain.frame.origin.x, self.LiftsMain.frame.origin.y + OFFSET_IOS_7, self.LiftsMain.frame.size.width, self.LiftsMain.frame.size.height);
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
    LiftsMain = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.liftsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"LiftsCell";
    
    LiftsCell *cell = (LiftsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    tableView.backgroundColor=[UIColor clearColor];
    tableView.opaque=NO;
    tableView.backgroundView=nil;
    
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LiftsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *data = [self.liftsArray objectAtIndex:indexPath.row];
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

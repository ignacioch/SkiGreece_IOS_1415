//
//  MainMap.m
//  Ski Greece
//
//  Created by VimaTeamGr on 9/5/12.
//  Copyright (c) 2012 VimaTeamGr. All rights reserved.
//

#import "MainMap.h"
#import "MainMapCell.h"
#import "AppDelegate.h"
#import "CenterClassViewController.h"
#import "MBProgressHUD.h"
#import "Flurry.h"

#import "CBZSplashView.h"


@interface MainMap ()

@property (nonatomic, strong) CBZSplashView *splashView;

@end

@implementation MainMap
{
    NSMutableArray *condition ;
    NSString *dt;
    NSInteger flag;
    MBProgressHUD *hud;
    NSMutableArray * dataFromServer;
}
@synthesize mapMain;
@synthesize responseData;
@synthesize backBtn=_backBtn;

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
    
    
    flag=0;
    
    
    [self.mapMain setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
    // Showing HUD for loading data
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud show:YES];

    self.responseData = [NSMutableData data];
    
    self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , SCREEN_WIDTH, SCREEN_HEIGHT);
    /*if (IS_IPHONE_5) {
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_with_back_5.png"]];
    } else if (IS_IPHONE_6){
        //?? FIXME 
        // create the png for iphone 6
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_with_back_5.png"]];
    }*/
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        imgView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:imgView];
    }
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    //fetching condition for all the ski centers
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[NSString stringWithFormat:@"http://%s/_all",BASE_URL]]];
    

    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    // adding splash screen for cosmote
    __unused UIImage *icon = [UIImage imageNamed:@"ic_launcher.png"];
    
    CBZSplashView *splashView = [CBZSplashView splashViewWithIcon:icon backgroundImage:[UIImage imageNamed:@"ski_greece_splash_screen_new"]];
    splashView.animationDuration = 3;
    splashView.iconColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_launcher.png"]];
    
    [self.view addSubview:splashView];
    self.splashView = splashView;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /* wait a beat before animating in */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.splashView startAnimation];
    });
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    
    //[hud show:NO];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
    // now we'll parse our data using NSJSONSerialization
    id myJSON = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers error:nil];
    
    // typecast an array and list its contents
    NSArray *jsonArray = (NSArray *)myJSON;
    
    dataFromServer= [[NSMutableArray alloc] initWithCapacity:[jsonArray count]];
    
    // take a look at all elements in the array
    for (id element in jsonArray) {
        [dataFromServer addObject:element];
    }
    
    flag = 1;
    [self.mapMain reloadData];
    

   

}



- (void)viewDidUnload
{
    mapMain = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [centers_labels count];
    return [dataFromServer count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"MainMapCell";
    //this is the identifier of the custom cell
    MainMapCell *cell = (MainMapCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainMapCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    NSDictionary* data= [dataFromServer objectAtIndex:indexPath.row];
    NSLog(@"%ld : %@",(long)indexPath.row,data);
    int open = [[data objectForKey:@"open"] intValue];
    NSString *name = [data objectForKey:@"name"];
    

    // before loading data label is closed
    // flag init to 0 - going to 1 after fetching data
    
    if (flag==1){
        if (open == 0) {
            cell.mainImage.image = [UIImage imageNamed:@"label_closed"];
        } else{
            cell.mainImage.image = [UIImage imageNamed:@"label_opened"];
        }
    }
    
    cell.mainImage.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 79.0f);

    
    cell.titleLabel.text = name;
    [cell.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:17.0f]];
    [cell.titleLabel sizeToFit];
    
    cell.takeMeLabel.hidden = YES;
    cell.takeMeLabel.userInteractionEnabled = NO;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.backgroundColor=[UIColor clearColor];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// get the selected language

    /*add entry for advertisment*/
    
    /*analytics add/event per ski center*/
    NSLog(@"Added Flurry event for :%@",[[dataFromServer objectAtIndex:indexPath.row] objectForKey:@"englishName"]);
    
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [[dataFromServer objectAtIndex:indexPath.row] objectForKey:@"englishName"], @"Ski_Center_Main", // Ski Center Main
     nil];
    
    [Flurry logEvent:@"SkiCenterMainScreen" withParameters:articleParams];

	
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CenterClassViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CenterMain"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.skiCenterDictionary = [dataFromServer objectAtIndex:indexPath.row];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)backAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end

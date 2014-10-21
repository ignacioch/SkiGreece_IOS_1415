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
//#import "Reachability.h"
#import "CenterClassViewController.h"
#import "MBProgressHUD.h"
#import "Flurry.h"




@interface MainMap ()

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
    
    /*Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ski Greece"
                                                        message:@"Η εφαρμογή ενδέχεται να μην λειτουργεί σωστά χωρίς σύνδεση στο Internet. Παρακαλόυμε συνδεθείτε πρώτα!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        
    }*/
    
    [self.mapMain setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud show:YES];

    self.responseData = [NSMutableData data];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_with_back_5.png"]];
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
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[NSString stringWithFormat:@"http://%s/_all",BASE_URL]]];
    
    //NSURLRequest *request = [NSURLRequest requestWithURL:
                             //[NSURL URLWithString:@"http://vimateam.gr/projects/skigreece/scripts/data/condition.php"]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
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
    NSLog(@"%d : %@",indexPath.row,data);
    int open = [[data objectForKey:@"open"] intValue];
    NSString *name = [data objectForKey:@"name"];
    

    if (flag==1){
        if (open == 0) {
            cell.mainImage.image = [UIImage imageNamed:@"label_closed"];
        } else{
            cell.mainImage.image = [UIImage imageNamed:@"label_opened"];
        }
    }
    
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

    /*NSLog(@"The row id is %d",  indexPath.row);
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.center=[centers objectAtIndex:indexPath.row];
    delegate.cent_id=indexPath.row;
    delegate.cond=[condition objectAtIndex:indexPath.row];*/
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
    /*vc.skiCenter=[centers objectAtIndex:indexPath.row];
    vc.skiCenterId=[NSString stringWithFormat:@"%d",indexPath.row];
    vc.skiCenterCondition=[condition objectAtIndex:indexPath.row];*/
    vc.skiCenterDictionary = [dataFromServer objectAtIndex:indexPath.row];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)backAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end

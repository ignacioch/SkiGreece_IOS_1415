//
//  DriveMeScreen.m
//  Ski Greece
//
//  Created by VimaTeamGr on 11/26/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "DriveMeScreen.h"
#import "MBProgressHUD.h"
#import "Flurry.h"
#import "MainMapCell.h"
#import "SingleMap.h"

@interface DriveMeScreen ()

@end

@implementation DriveMeScreen
{
    NSArray *centers_labels;
    NSArray *centers;
    NSMutableArray *condition ;
    BOOL flag;

}

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
    
    flag = NO;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"main_screen_header_iphone5.png"]];
    }  else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7, subview.frame.size.width, subview.frame.size.height);
        }
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
    
    [self.skiCenterTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud show:YES];
    
    centers_labels = [NSArray arrayWithObjects:@"Χ.Κ. Παρνασσού",@"Χ.Κ. Καλαβρύτων",@"Χ.Κ. Βασιλίτσας",@"Χ.Κ. Καιμακτσαλάν",@"Χ.Κ. Σελίου",@"Χ.Κ. Πηλίου",@"Χ.Κ. 3-5 Πηγάδια",@"Χ.Κ. Πισοδερίου",@"Χ.Κ. Καρπενησίου",@"Χ.Κ. Μαινάλου",@"Χ.Κ. Φαλακρού",nil];
    
    centers=[NSArray arrayWithObjects:@"parnassos",@"kalavryta",@"vasilitsa",@"kaimaktsalan",@"seli",@"pilio",@"pigadia",@"pisoderi",@"karpenisi",@"mainalo",@"falakro", nil];
    self.responseData = [NSMutableData data];

    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[NSString stringWithFormat:@"http://%s/_all",BASE_URL]]];
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
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    //[hud show:NO];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    // now we'll parse our data using NSJSONSerialization
    id myJSON = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers error:nil];
    
    // typecast an array and list its contents
    NSArray *jsonArray = (NSArray *)myJSON;
    
    //dataFromServer= [[NSMutableArray alloc] initWithCapacity:[jsonArray count]];
    condition= [NSMutableArray new];

    // take a look at all elements in the array
    for (id element in jsonArray) {
        //[dataFromServer addObject:element];
        NSString *name = [element objectForKey:@"englishName"];
        int open =[[element objectForKey:@"open"] intValue];
        if ([name isEqualToString:@"parnassos"]) {
            [condition addObject:[NSString stringWithFormat:@"%d",open]];
        } else if ([name isEqualToString:@"kalavryta"]) {
            [condition addObject:[NSString stringWithFormat:@"%d",open]];
        } else if ([name isEqualToString:@"vasilitsa"]) {
            [condition addObject:[NSString stringWithFormat:@"%d",open]];
        } else if ([name isEqualToString:@"kaimaktsalan"]) {
            [condition addObject:[NSString stringWithFormat:@"%d",open]];
        } else if ([name isEqualToString:@"seli"]) {
            [condition addObject:[NSString stringWithFormat:@"%d",open]];
        } else if ([name isEqualToString:@"pilio"]) {
            [condition addObject:[NSString stringWithFormat:@"%d",open]];
        } else if ([name isEqualToString:@"pigadia"]) {
            [condition addObject:[NSString stringWithFormat:@"%d",open]];
        } else if ([name isEqualToString:@"pisoderi"]) {
            [condition addObject:[NSString stringWithFormat:@"%d",open]];
        } else if ([name isEqualToString:@"karpenisi"]) {
            [condition addObject:[NSString stringWithFormat:@"%d",open]];
        } else if ([name isEqualToString:@"mainalo"]) {
            [condition addObject:[NSString stringWithFormat:@"%d",open]];
        } else if ([name isEqualToString:@"falakro"]) {
            [condition addObject:[NSString stringWithFormat:@"%d",open]];
        }
    }
    
    flag = YES;
    
    [self.skiCenterTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [centers_labels count];
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
    
    NSLog(@"Condition at %d is %@ ",indexPath.row,[condition objectAtIndex:indexPath.row]);
    
    if (flag){
        if ([[condition objectAtIndex:indexPath.row] intValue] == 0) {
            cell.mainImage.image = [UIImage imageNamed:@"closed_driveme"];
        } else{
            cell.mainImage.image = [UIImage imageNamed:@"open_driveme"];
        }
    }
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",[centers_labels objectAtIndex:indexPath.row]];
    [cell.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:17.0f]];
    [cell.titleLabel sizeToFit];
    
    cell.takeMeLabel.text = @"Drive Me";
    [cell.takeMeLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:17.0f]];
    [cell.takeMeLabel sizeToFit];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.backgroundColor=[UIColor clearColor];
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	    
    NSLog(@"The row id is %d",  indexPath.row);

    
    /*analytics add/event per ski center*/
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [centers objectAtIndex:indexPath.row], @"Ski_Center_DriveMe", // Ski Center Main
     nil];
    
    [Flurry logEvent:@"SkiCenterDriveMe" withParameters:articleParams];
    
    if ((indexPath.row ==4) || (indexPath.row ==9) || (indexPath.row == 10) || (indexPath.row == 13) || (indexPath.row ==14)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" Ski Greece"
                                                        message:@" Δεν υπάρχουν διαθέσιμα στοιχεία για το συγκεκριμένο χιονοδρομικό.!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        SingleMap *vc = [sb instantiateViewControllerWithIdentifier:@"SingleMapID"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        CGPoint midCoordinate = CGPointFromString([self getAddress:[centers objectAtIndex:indexPath.row]]);
        CLLocationCoordinate2D _midCoordinate = CLLocationCoordinate2DMake(midCoordinate.x, midCoordinate.y);
        vc.coordinate=_midCoordinate;
        vc.name=[centers_labels objectAtIndex:indexPath.row];
        [self presentViewController:vc animated:YES completion:NULL];
    }
    
	
}

-(NSString*) getAddress :(NSString *) ski_center;
{
    if ([@"parnassos" isEqualToString:ski_center]) {
        return @"{38.587095,22.638292}";
    } else if ([@"kalavryta" isEqualToString:ski_center]) {
        return @"{37.998731,22.190003}";
    } else if ([@"elatohori" isEqualToString:ski_center]) {
        return @"{}";
    } else if ([@"kaimaktsalan" isEqualToString:ski_center]) {
        return @"{40.875752,21.79121}";
    } else if ([@"karpenisi" isEqualToString:ski_center]) {
        return @"{39.942736,21.804047}";
    } else if ([@"pisoderi" isEqualToString:ski_center]) {
        return @"{40.747785,21.312586}";
    } else if ([@"vasilitsa" isEqualToString:ski_center]) {
        return @"{40.046242,21.097717}";
    } else if ([@"metsovo" isEqualToString:ski_center]) {
        return @"{}";
    } else if ([@"pertouli" isEqualToString:ski_center]) {
        return @"{}";
    } else if ([@"lailias" isEqualToString:ski_center]) {
        return @"{}";
    } else if ([@"falakro" isEqualToString:ski_center]) {
        return @"{41.306956,24.071999}";
    } else if ([@"pigadia" isEqualToString:ski_center]) {
        return @"{40.643557,21.962093}";
    } else if ([@"seli" isEqualToString:ski_center]) {
        return @"{}";
    } else if ([@"pilio" isEqualToString:ski_center]) {
        return @"{39.942736,21.804047}";
    } else if ([@"mainalo" isEqualToString:ski_center]) {
        return @"{37.670047,22.295559}";
    }
    return @"{}";
}

@end

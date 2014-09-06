//
//  GalleryViewController.m
//  Ski Greece
//
//  Created by VimaTeamGr on 1/4/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryCell.h"
#import "AppDelegate.h"

@interface GalleryViewController ()
{
    NSString *ski_center;
    NSMutableArray *images_array ;
    NSString *total_images;
}

@end

@implementation GalleryViewController
@synthesize gallery_photos,responseData;

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
    self.responseData = [NSMutableData data];

    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"http://vimateam.gr/projects/skigreece/scripts/number_of_photos.php"]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Do your resizing
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_with_back_5.png"]];
        
        self.backBtn.frame = CGRectMake(self.backBtn.frame.origin.x, self.backBtn.frame.origin.y + OFFSET_IOS_7 , self.backBtn.frame.size.width , self.backBtn.frame.size.height);
        
        
        
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        
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
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ski_center=delegate.center;
    total_images=[res objectForKey:ski_center];
    NSLog(@"Total number of images: %d",[total_images intValue]);
    
    [self.gallery_photos reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [total_images intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"GalleryCell";
    //this is the identifier of the custom cell
    GalleryCell *cell = (GalleryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    /*if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GalleryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }*/
    if (cell == nil) {
        cell = [[GalleryCell alloc]initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:simpleTableIdentifier];
    }
    NSString *urlString;
    if (indexPath.row==[total_images intValue]-1){
        urlString=[NSString stringWithFormat:@"http://vimateam.gr/projects/skigreece/images/send_foto.png"];
    } else {
        urlString=[NSString stringWithFormat:@"http://vimateam.gr/projects/skigreece/images/SkiCenterPhotos/%@/%d.jpg",ski_center,indexPath.row+1];
    }
    NSLog(@"DownLoad GALLERY is:%@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    [cell.galleryphoto setImage:downloadedImage];
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 201;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    gallery_photos = nil;
    [super viewDidUnload];
}
- (IBAction)goBack:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end

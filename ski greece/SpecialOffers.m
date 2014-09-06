//
//  SpecialOffers.m
//  Ski Greece
//
//  Created by VimaTeamGr on 10/27/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "SpecialOffers.h"
#import "OffersAPI.h"
#import "MBProgressHUD.h"
#import "SingleWebview.h"

#define OFFSET_5 88.0f

@interface SpecialOffers ()

@end

@implementation SpecialOffers
{
    BOOL pageControlBeingUsed;
    NSMutableArray* dataFromServer;
    NSMutableArray* urlFromServer;
    MBProgressHUD *hud;
    int remainingImages;
}

@synthesize myScroll=_myScroll;
@synthesize myPageControl=_myPageControl;
@synthesize numberOfOffers=_numberOfOffers;

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
    self.myScroll.delegate=self;
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_only.png"]];
    
    self.myPageControl.numberOfPages = 1;
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading offers";
    [hud show:YES];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.myScroll.frame = CGRectMake(self.myScroll.frame.origin.x, self.myScroll.frame.origin.y, self.myScroll.frame.size.width, 399.0f + OFFSET_5);
        self.homeBtn.frame = CGRectMake(self.homeBtn.frame.origin.x, self.homeBtn.frame.origin.y + OFFSET_5, self.homeBtn.frame.size.width, self.homeBtn.frame.size.height);
        self.myPageControl.frame= CGRectMake(self.myPageControl.frame.origin.x, self.myPageControl.frame.origin.y +OFFSET_5, self.myPageControl.frame.size.width, self.myPageControl.frame.size.height);
    } else {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            self.myScroll.frame = CGRectMake(self.myScroll.frame.origin.x, self.myScroll.frame.origin.y, self.myScroll.frame.size.width, 399.0f);
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
    
    /*NSLog(@"Total Height:%f",screenBounds.size.height);
    NSLog(@"Home button Y: %f Height: %f",self.homeBtn.frame.origin.y,self.homeBtn.frame.size.height);
    NSLog(@"Scroll Y: %f Height: %f",self.myScroll.frame.origin.y,self.myScroll.frame.size.height);*/
    
    urlFromServer=[[NSMutableArray alloc] init];
    [self getData];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.myScroll.frame.size.width;
    int page = floor((self.myScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.myPageControl.currentPage = page;
}

- (IBAction)changePage:(id)sender {
    CGRect frame;
    frame.origin.x = self.myScroll.frame.size.width * self.myPageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.myScroll.frame.size;
    [self.myScroll scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed=YES;
}

- (IBAction)goToHome:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

-(void) openOffer:(UIButton *)button
{
    NSLog(@"Button url is :%@",[urlFromServer objectAtIndex:button.tag]);
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SingleWebview *vc = [sb instantiateViewControllerWithIdentifier:@"SingleWebviewID"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.url=[NSString stringWithFormat:@"%@",[urlFromServer objectAtIndex:button.tag]];
    vc.name=@"";
    [self presentViewController:vc animated:YES completion:NULL];
}

/*get Data from the server*/

-(void) getData
{
    [[OffersAPI sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  @"getOffers",@"command",
                                                  nil]
                                    onCompletion:^(NSDictionary *json) {
                                        //got stream
                                        dataFromServer=[json objectForKey:@"result"];
                                        [self loadImages];
                                    }];
}

-(void) loadImages
{
    [urlFromServer removeAllObjects];

    NSDictionary *data = [dataFromServer objectAtIndex:0];
    NSLog(@"%@",[data description]);

    int total=[[data objectForKey:@"total_number"] intValue];
    NSLog(@"Total Images: %d",total);
    for (int i=0; i<total; i++) {
        NSString * url= [data objectForKey:[NSString stringWithFormat:@"url_%d",(i+1)]];
        NSLog(@"%d: Url => %@",i+1,url);
        [urlFromServer addObject:url];
    }
    
    self.myPageControl.numberOfPages = total;
    /*arrays data ok*/
    [self presentOffers:total];
}

-(void) presentOffers:(int) number
{
    for (int i = 0; i < number; i++) {
        CGRect frame;
        frame.origin.x = self.myScroll.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.myScroll.frame.size;
        
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        
        /*add button and Image for this subview*/
        
        NSURL* imageURL = [[OffersAPI sharedInstance] urlForImageWithId:(i+1)];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320,_myScroll.frame.size.height)];
        [subview addSubview:imgView];
        
        
        AFImageRequestOperation* imageOperation =
        [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL]
                                                          success:^(UIImage *image) {
                                                              //create an image view, add it to the view
                                                              UIImageView* thumbView = [[UIImageView alloc] initWithImage: image];
                                                              thumbView.frame = CGRectMake(0,0,320,self.myScroll.frame.size.height);
                                                              thumbView.contentMode = UIViewContentModeScaleAspectFit;
                                                              //cell.image.image=thumbView.image;
                                                              imgView.image=thumbView.image;
                                                              [hud hide:YES];
                                                          }];
        
        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        [queue addOperation:imageOperation];

        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(openOffer:)
         forControlEvents:UIControlEventTouchDown];
        button.tag = i;
        [button setTitle:@" " forState:UIControlStateNormal];
        button.frame = CGRectMake(0.0, 0.0, 320.0, self.myScroll.frame.size.height);
        [subview addSubview:button];
        
        [self.myScroll addSubview:subview];
    }
    
    if ([_myPageControl respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
        _myPageControl.pageIndicatorTintColor = [UIColor blackColor];
        _myPageControl.currentPageIndicatorTintColor=[UIColor blueColor];
    }
    
    self.myScroll.contentSize = CGSizeMake(self.myScroll.frame.size.width * number, self.myScroll.frame.size.height);
    
    NSLog(@"Height:%f",self.myScroll.frame.size.height);
}




@end

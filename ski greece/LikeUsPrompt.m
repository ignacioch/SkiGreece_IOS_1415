//
//  LikeUsPrompt.m
//  Ski Greece
//
//  Created by VimaTeamGr on 11/2/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "LikeUsPrompt.h"
#import "AFImageRequestOperation.h"

@interface LikeUsPrompt ()

@end

@implementation LikeUsPrompt
{
    NSTimeInterval startTime;
}

@synthesize mainAdImg=_mainAdImg;
@synthesize timerLabel=_timerLabel;
@synthesize skipBtn=_skipBtn;

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

    // add Analytics in this offer
    
    startTime=[NSDate timeIntervalSinceReferenceDate];
    [self updateTime];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Do your resizing
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        
        self.mainAdImg.frame = CGRectMake(self.mainAdImg.frame.origin.x, self.mainAdImg.frame.origin.y + OFFSET_IOS_7, self.mainAdImg.frame.size.width, self.mainAdImg.frame.size.height);
        
        self.timerLabel.frame = CGRectMake(self.timerLabel.frame.origin.x, self.timerLabel.frame.origin.y + OFFSET_IOS_7 + OFFSET_5, self.timerLabel.frame.size.width, self.timerLabel.frame.size.height);
        
        self.skipBtn.frame = CGRectMake(self.skipBtn.frame.origin.x, self.skipBtn.frame.origin.y + OFFSET_IOS_7 + OFFSET_5, self.skipBtn.frame.size.width, self.skipBtn.frame.size.height);
        
        
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        
        self.mainAdImg.frame = CGRectMake(self.mainAdImg.frame.origin.x, self.mainAdImg.frame.origin.y + OFFSET_IOS_7, self.mainAdImg.frame.size.width, self.mainAdImg.frame.size.height - OFFSET_IOS_7);
        
        self.skipBtn.frame = CGRectMake(self.skipBtn.frame.origin.x, self.skipBtn.frame.origin.y + OFFSET_IOS_7, self.skipBtn.frame.size.width, self.skipBtn.frame.size.height);
        
        self.timerLabel.frame = CGRectMake(self.timerLabel.frame.origin.x, self.timerLabel.frame.origin.y + OFFSET_IOS_7, self.timerLabel.frame.size.width, self.timerLabel.frame.size.height);
        
    }
    [self setAd];
    
}

-(void) updateTime
{
    NSTimeInterval currentTime= [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsedTime= currentTime - startTime;
    
    int mins= (int) (elapsedTime/60.0);
    elapsedTime-=mins*60;
    int secs=(int) (elapsedTime);
    
    NSLog(@"secs:%u",secs);
    
    self.timerLabel.text=[NSString stringWithFormat:@"App will continue in %u",5-secs];
    [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
    
    if (secs==5) {
        NSLog(@"I should exit");
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self.delegate likeUsCompleted:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipAction:(id)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.delegate likeUsCompleted:self];
}

-(void) setAd
{
    NSURL * imageURL = [NSURL URLWithString:self.offerUrl];
    NSLog(@"Opening offer:%@",self.offerUrl);
    
    AFImageRequestOperation* imageOperation =
    [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL]
                                                      success:^(UIImage *image) {
                                                          //create an image view, add it to the view
                                                          UIImageView* thumbView = [[UIImageView alloc] initWithImage: image];
                                                          thumbView.frame = CGRectMake(0,0,_mainAdImg.frame.size.width,_mainAdImg.frame.size.width);
                                                          thumbView.contentMode = UIViewContentModeScaleAspectFit;
                                                          [self.mainAdImg setImage:thumbView.image];
                                                      }];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperation:imageOperation];
}
@end

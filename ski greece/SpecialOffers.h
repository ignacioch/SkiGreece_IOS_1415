//
//  SpecialOffers.h
//  Ski Greece
//
//  Created by VimaTeamGr on 10/27/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"
#import "AFNetworking.h"



@interface SpecialOffers : UIViewController <UIScrollViewDelegate >

@property (strong, nonatomic) IBOutlet UIButton *homeBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *myScroll;
@property (strong, nonatomic) IBOutlet UIPageControl *myPageControl;
@property (nonatomic,assign) int numberOfOffers;
- (IBAction)changePage:(id)sender;
- (IBAction)goToHome:(id)sender;
@end

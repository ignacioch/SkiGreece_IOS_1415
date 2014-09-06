//
//  SingleWebview.h
//  Ski Greece
//
//  Created by VimaTeamGr on 10/27/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleWebview : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,assign) NSString * url;
@property (strong, nonatomic) IBOutlet UINavigationBar *topBar;
@property (nonatomic,assign) NSString * name;
@end

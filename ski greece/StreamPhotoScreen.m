//
//  StreamPhotoScreen.m
//  Ski Greece
//
//  Created by VimaTeamGr on 8/15/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "StreamPhotoScreen.h"
#import "API.h"
#import "LoginScreen.h"
#import "UIAlertView+error.h"
#import "MBProgressHUD.h"


#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 2.0f

@interface StreamPhotoScreen ()

@end

@implementation StreamPhotoScreen
{
    CGRect keyboardFrameBeginRect;
    int photoNumber;
    MBProgressHUD *hud;

}
@synthesize photo=_photo;
@synthesize photoDescription=_photoDescription;
@synthesize commentPlaceholder=_commentPlaceholder;
@synthesize comments=_comments;
@synthesize commentsTable=_commentsTable;
@synthesize stats=_stats;
@synthesize photoPlace=_photoPlace;
@synthesize dataFromServer=_dataFromServer;
@synthesize littleArrow=_littleArrow;
@synthesize imgBack=_imgBack;
@synthesize topBar=_topBar;
@synthesize commentBtnPlaceholder=_commentBtnPlaceholder;
@synthesize formerBackBtn=_formerBackBtn;
@synthesize likeButton=_likeButton;

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
        
    int IdPhoto = [[self.stats objectForKey:@"IdPhoto"] intValue];
    photoNumber = IdPhoto;
    int type=[[self.stats objectForKey:@"type"] intValue];
    NSString * user= [self.stats objectForKey:@"username"];
    NSString * text= [self.stats objectForKey:@"title"];
    NSString * no_likes=[self.stats objectForKey:@"likes"];
    NSString * no_comments=[self.stats objectForKey:@"comments"];
    NSString * place=[self.stats objectForKey:@"place"];
    NSString * date=[self.stats objectForKey:@"date"];
    
    API* api = [API sharedInstance];
    NSURL* imageURL = [api urlForImageWithId:[NSNumber numberWithInt:IdPhoto] isThumb:NO];
    if (type == 1) {
        [self.photo setImageWithURL:imageURL];
    } else {
       /* UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 90, 140, 110)];
        imgView.image = [UIImage imageNamed:@"intro_community.png"];
        imgView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:imgView];*/
        [self.photo setImage:[UIImage imageNamed:@"ski_greece_cover.jpg"]];
    }
    
    

    
    //load the big size photo
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.comments setText:no_comments];
    [self.likes setText:no_likes];
    [self.photoDescription setText:text];
    
    if (place == nil || [place isEqual:[NSNull null]]) {
        // handle the place not being available
    } else {
        // handle the place being available
        if ([place isEqualToString:@"None"] || [place isEqualToString:@""]) {

        } else {
            [self.photoPlace setText:place];
            [self.photoPlace sizeToFit];
        }
    }
    
    
    
    self.imgBack.backgroundColor = [UIColor colorWithRed:(50/255.f) green:(199/255.f) blue:(240/255.f) alpha:1.0f];

     if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
         self.topBar.tintColor = [UIColor colorWithRed:(163/255.f) green:(163/255.f) blue:(163/255.f) alpha:1.0f];
     } else {
          self.topBar.barTintColor = [UIColor colorWithRed:(163/255.f) green:(163/255.f) blue:(163/255.f) alpha:1.0f];
         //TO DO ADD CODE FOR IOS 7.0
     }
    
    UINavigationItem *buttonCarrier = [[UINavigationItem alloc]initWithTitle:@""];
    
    buttonCarrier.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"skigreece_topbar_logo.png"]];
    
    //Creating some buttons:
    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    
    
    //Putting the Buttons on the Carrier
    [buttonCarrier setLeftBarButtonItem:barBackButton];
    
    //The NavigationBar accepts those "Carrier" (UINavigationItem) inside an Array
    NSArray *barItemArray = [[NSArray alloc]initWithObjects:buttonCarrier,nil];
    
    // Attaching the Array to the NavigationBar
    [self.topBar setItems:barItemArray];
    
    /*change likes buttons*/
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:[NSString stringWithFormat:@"myLikes%d",([API sharedInstance].getUserid)]];
    if ([array containsObject:[NSString stringWithFormat:@"%d",IdPhoto]]) {
        NSLog(@"User %d likes photo :%d", [API sharedInstance].getUserid, IdPhoto);
        [self.likeButton setImage:[UIImage imageNamed:@"like_done.png"] forState:UIControlStateNormal];
        self.likeButton.userInteractionEnabled=NO;
    }


    
    [self.commentsTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

    
    [self loadComments];
    
    self.commentPlaceholder.delegate = self;
    
    self.originalCenter = self.view.center;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationMethod:) name:UIKeyboardDidShowNotification object:nil];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.commentPlaceholder action:@selector(resignFirstResponder)];
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:gestureRecognizer];
    
    /*round the box*/
    self.commentBtnPlaceholder.layer.cornerRadius = 10; // this value vary as per your desire
    self.commentBtnPlaceholder.clipsToBounds = YES;
    
    //hide former button in case needed later
    self.formerBackBtn.hidden=YES;
    self.formerBackBtn.userInteractionEnabled=NO;
    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        
        self.commentsTable.frame = CGRectMake(self.commentsTable.frame.origin.x, self.commentsTable.frame.origin.y + OFFSET_IOS_7 , self.commentsTable.frame.size.width, 101.0f + OFFSET_5);
        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            if (subview.tag == 20) {                // 20 is the triangle
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + OFFSET_5, subview.frame.size.width, subview.frame.size.height);
            } else  if (subview.tag != 10) {
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7, subview.frame.size.width, subview.frame.size.height);
            }
        }
        
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        
        self.commentsTable.frame = CGRectMake(self.commentsTable.frame.origin.x, self.commentsTable.frame.origin.y + OFFSET_IOS_7 , self.commentsTable.frame.size.width, 101.0f);
        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            if (subview.tag == 20) {                // 20 is the triangle
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 , subview.frame.size.width, subview.frame.size.height);
            } else  if (subview.tag != 10) {
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7, subview.frame.size.width, subview.frame.size.height);
            }
        }
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_back.png"]];
    [tempImageView setFrame:self.commentsTable.frame];
    NSLog(@"Table Y: %f  Back Y: %f",self.commentsTable.frame.origin.y, tempImageView.frame.origin.y);
    NSLog(@"Height Table Y: %f  Back Y: %f",self.commentsTable.frame.size.height, tempImageView.frame.size.height);

    
    if ([no_comments intValue]!=0) {
        self.commentsTable.backgroundView = tempImageView;
        self.commentsTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.littleArrow.hidden=NO;
    } else {
        self.littleArrow.hidden=YES;
        self.commentsTable.separatorStyle = UITableViewCellSeparatorStyleNone;

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
    
    [self.photoDescription sizeToFit];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)makeComment:(id)sender
{
    if ([API sharedInstance].user == nil){
        
        NSLog(@"User is not logged in");
        
        [self.view endEditing:YES];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LoginScreen *vc = [sb instantiateViewControllerWithIdentifier:@"CommunityLogin"];
        vc.delegate=self;
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];
        
    } else {
                
        [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 @"comment",@"command",
                                                 [self.stats objectForKey:@"IdPhoto"],@"IdPhoto",
                                                 self.commentPlaceholder.text, @"text",
                                                 nil]
                                   onCompletion:^(NSDictionary *json) {
                                       
                                       //completion
                                       if (![json objectForKey:@"error"]) {
                                           
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];

                                           
                                           //success
                                           [self loadComments];
                                           self.commentPlaceholder.text=@"";
                                           int previous_num_comments= [self.comments.text intValue];
                                           self.comments.text=[NSString stringWithFormat:@"%d",previous_num_comments+1];
                                           
                                           if (previous_num_comments==0) {
                                               UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_back.png"]];
                                               [tempImageView setFrame:self.commentsTable.frame];
                                               self.commentsTable.backgroundView = tempImageView;
                                               self.commentsTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                                               self.littleArrow.hidden=NO;
                                           }
                                           
                                       } else {
                                           
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];

                                           
                                           //error, check for expired session and if so - authorize the user
                                           NSString* errorMsg = [json objectForKey:@"error"];
                                           [UIAlertView error:errorMsg];
                                           
                                           if ([@"Authorization required" compare:errorMsg]==NSOrderedSame) {
                                               
                                               [self.view endEditing:YES];
                                               
                                               UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                                               LoginScreen *vc = [sb instantiateViewControllerWithIdentifier:@"CommunityLogin"];
                                               vc.delegate=self;
                                               vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                                               [self presentViewController:vc animated:YES completion:NULL];
                                           }
                                       }
                                       
                                   }];
        
        
    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataFromServer count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* photo = [_dataFromServer objectAtIndex:indexPath.row];
    NSString *com=[photo objectForKey:@"comment_des"];
    NSString *usr=[photo objectForKey:@"username"];
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (com == nil || [com isEqual:[NSNull null]]) {
        // handle the place not being available
        NSLog(@"Comment is null for an unknown reason");
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",com,usr];
    }
    
    
   /* NSInteger _commLen = [com length]+ 2;
    NSInteger _usrLen = [usr length];
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ - %@",com,usr]];
    UIColor *_black=[UIColor blackColor];
    UIColor *_white=[UIColor whiteColor];
    [attString addAttribute:NSForegroundColorAttributeName value:_black range:NSMakeRange(0, _commLen)];
    [attString addAttribute:NSForegroundColorAttributeName value:_white range:NSMakeRange(_commLen+1, _usrLen)];
    NSLog(@"attrString = %@", attString);
    cell.textLabel.attributedText = attString;*/
    
    /*add for label height*/
    [cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
    [cell.textLabel setNumberOfLines:0];



    /*[cell.textLabel setTextColor:[UIColor colorWithRed:(167/255.f) green:(167/255.f) blue:(167/255.f) alpha:1.0f]];*/
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:14.0f]];
    
    cell.backgroundColor=[UIColor clearColor];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //return 30.0f;
    NSDictionary* photo = [_dataFromServer objectAtIndex:indexPath.row];
    NSString *com=[photo objectForKey:@"comment_des"];
    NSString *usr=[photo objectForKey:@"username"];
    NSString *text = [NSString stringWithFormat:@"%@ - %@",com,usr];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);
}


- (IBAction)goBack:(id)sender {
    [self.delegate streamPhotoScreenCompleted:self];
}

-(void) loadComments
{
    NSLog(@"Load comments for: %@",[self.stats objectForKey:@"IdPhoto"]);
    
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"loadComments",@"command",
                                             [self.stats objectForKey:@"IdPhoto"],@"IdPhoto",
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   //got stream
                                   NSLog(@"got stream with total number of data: %d",[[json objectForKey:@"result"] count]);
                                   NSLog(@"Printing result:%@",[[json objectForKey:@"result"] description]);
                                   _dataFromServer= [[NSMutableArray alloc] initWithCapacity:[[json objectForKey:@"result"]count]];
                                   _dataFromServer=[json objectForKey:@"result"];
                                   [self.commentsTable reloadData];
                               }];

}

-(void) goBack
{
    [self.delegate streamPhotoScreenCompleted:self];
}

#pragma mark - LoginScreenDelegate

- (void)loginScreenCompleted:(LoginScreen *)controller
{
	[self dismissViewControllerAnimated:NO completion:nil];
}

- (void)myNotificationMethod:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    NSLog(@"Size is:%f",keyboardFrameBeginRect.size.height);
    
    self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y - keyboardFrameBeginRect.size.height);
}

#pragma mark - textField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.center = self.originalCenter;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 100) ? NO : YES;
}

- (IBAction)likeAction:(id)sender
{
    NSLog(@"Like Action - IdPhoto is :%d",photoNumber);
    NSString *indexString=[NSString stringWithFormat:@"%d",photoNumber];

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud show:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"like",@"command",
                                             indexString, @"IdPhoto",
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   
                                   //completion
                                   if (![json objectForKey:@"error"]) {
                                       
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       
                                       
                                       //success
                                       /*[[[UIAlertView alloc]initWithTitle:@"Success!"
                                                                  message:@"Post liked"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Yay!"
                                                        otherButtonTitles: nil] show];*/
                                       
                                       //reload the likes
                                       int previous_num_likes= [self.likes.text intValue];
                                       self.likes.text=[NSString stringWithFormat:@"%d",previous_num_likes+1];
                                       [self.likeButton setImage:[UIImage imageNamed:@"like_done.png"] forState:UIControlStateNormal];
                                       self.likeButton.userInteractionEnabled=NO;
                                       
                                       //save into nsmutableArray in NSUsers to retrieve maybe later
                                       NSMutableArray *array = [NSMutableArray arrayWithArray:[defaults objectForKey:[NSString stringWithFormat:@"myLikes%d",[API sharedInstance].getUserid]]];
                                       if (array == nil) {
                                           NSLog(@"This is the first like that I make");
                                           NSMutableArray * temp = [NSMutableArray array];
                                           [temp addObject:[NSString stringWithFormat:@"%d",photoNumber]];
                                           [defaults setObject:temp forKey:[NSString stringWithFormat:@"myLikes%d",[API sharedInstance].getUserid]];
                                           [defaults synchronize];
                                       } else {
                                           NSLog(@"User already has likes: %@",array.description);
                                           int n= [array count];
                                           [array insertObject: [NSString stringWithFormat:@"%d",photoNumber] atIndex:n];
                                           [[NSUserDefaults standardUserDefaults] setObject:array forKey:[NSString stringWithFormat:@"myLikes%d",[API sharedInstance].getUserid]];
                                           [defaults synchronize];
                                           NSLog(@"User made a like - New array of likes: %@",array.description);
                                           
                                       }
                                       
                                   } else {
                                       
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];

                                       
                                       //error, check for expired session and if so - authorize the user
                                       NSString* errorMsg = [json objectForKey:@"error"];
                                       [UIAlertView error:errorMsg];
                                       
                                       if ([@"Authorization required" compare:errorMsg]==NSOrderedSame) {
                                           
                                           [self.view endEditing:YES];
                                           
                                           UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                                           LoginScreen *vc = [sb instantiateViewControllerWithIdentifier:@"CommunityLogin"];
                                           vc.delegate=self;
                                           vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                                           [self presentViewController:vc animated:YES completion:NULL];
                                       }
                                   }
                                   
                               }];
}
@end

//
//  StreamScreen.m
//  Ski Greece
//
//  Created by VimaTeamGr on 8/15/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "StreamScreen.h"
#import "PhotoScreen.h"
#import "LoginScreen.h"
#import "API.h"
#import "UIAlertView+error.h"
#import "PhotoStreamCell.h"
#import "UserProfile.h"
#import "PostStreamCell.h"
#import "StreamPhotoScreen.h"
#import "MBProgressHUD.h"
#import "Flurry.h"

@interface StreamScreen (private)
-(void)takePhoto;
-(void)choosePhoto;
@end



@implementation StreamScreen
{
    NSMutableArray * dataFromSever;
    UITableViewController *tableViewController;
    NSMutableArray *imageArray ;
    NSMutableArray *descriptionsArray ;
    MBProgressHUD *hud;

}

@synthesize postDescription=_postDescription;
@synthesize streamTable=_streamTable;
@synthesize refreshControl=_refreshControl;
@synthesize logButton=_logButton;
@synthesize profImage=_profImage;
@synthesize loginBtnLabel=_loginBtnLabel;
@synthesize label1=_label1;
@synthesize label3=_label3;

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
    
    
    tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.streamTable;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getConnections) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.postDescription action:@selector(resignFirstResponder)];
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:gestureRecognizer];
    
    
    [self checkForProfileImage];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud show:YES];
    
    imageArray= [NSMutableArray array];
    descriptionsArray = [NSMutableArray array];
    
    
    [Flurry logEvent:@"CommunityStream" timed:YES];
    
        
    [self refreshStream];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        
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
    
    self.postDescription.delegate = self;
    

    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.isOpen) {
        NSLog(@"FBSession is open. Will populate user details.");
        [self populateUserDetails];
    } else {
        NSLog(@"Session is not open");
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)attachAPhoto:(id)sender
{
    
    if([self.postDescription isEditing]) {
        NSLog(@"Focus is on textfield");
        [self.postDescription resignFirstResponder];
    }
    
    
    if (![[API sharedInstance] isAuthorized]) {
        NSLog(@"I should Open login screen");
        
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LoginScreen *vc = [sb instantiateViewControllerWithIdentifier:@"CommunityLogin"];
        vc.delegate=self;
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];
    } else {
    //show the app menu
    [[[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle:@"Close"
                   destructiveButtonTitle:nil
                        otherButtonTitles:@"Take photo", @"Choose from library", nil]
     showInView:self.view];
        
    }
}

- (IBAction)logout:(id)sender {
    
    if ([API sharedInstance].isAuthorized){
        
        //this should be visible only when the user is logged in
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UserProfile *vc = [sb instantiateViewControllerWithIdentifier:@"CommunityUserProf"];
        vc.delegate=self;
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];
        

    } else {
        [self.view endEditing:YES];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LoginScreen *vc = [sb instantiateViewControllerWithIdentifier:@"CommunityLogin"];
        vc.delegate=self;
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];
    }
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self takePhoto]; break;
        case 1:
            [self choosePhoto];break;
    }
}

-(void) takePhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
/*#if TARGET_IPHONE_SIMULATOR
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else*/
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//#endif
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

-(void) choosePhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    [self presentViewController:imagePickerController animated:YES completion:NULL];
  
}

#pragma mark - Image picker delegate methdos
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	//UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"Image is taken");
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    PhotoScreen *vc = [sb instantiateViewControllerWithIdentifier:@"CommunityPhoto"];
    vc.delegate=self;
    vc.imageFromCamera=[info objectForKey:UIImagePickerControllerOriginalImage];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:NULL];
}

#pragma mark - PhotoScreenDelegate

- (void)photoScreenCompleted:(PhotoScreen *)controller
{
	[self dismissViewControllerAnimated:NO completion:nil];
    [self refreshStream];
}

- (IBAction)makePost:(id)sender {
    
    if ([API sharedInstance].user == nil){
        
        NSLog(@"User is not logged in");
        
        [self.view endEditing:YES];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LoginScreen *vc = [sb instantiateViewControllerWithIdentifier:@"CommunityLogin"];
        vc.delegate=self;
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];

    } else {
        
        //[spinner startAnimating];
        [hud show:YES];

        
        [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 @"newPost",@"command",
                                                 self.postDescription.text, @"title",
                                                 nil]
                                   onCompletion:^(NSDictionary *json) {
                                       
                                       //completion
                                       if (![json objectForKey:@"error"]) {
                                           
                                           [hud hide:YES];
                                           
                                           //success
                                           /*[[[UIAlertView alloc]initWithTitle:@"Success!"
                                                                      message:@"Your post is created"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Yay!"
                                                            otherButtonTitles: nil] show];*/
                                           
                                           //I should reload data instead of alertview to see my new post
                                           //and clear the textfield
                                           [self refreshStream];
                                           self.postDescription.text=@"";
                                           
                                       } else {
                                           
                                           [hud hide:YES];
                                           
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

#pragma mark - LoginScreenDelegate

- (void)loginScreenCompleted:(LoginScreen *)controller
{
	[self dismissViewControllerAnimated:NO completion:nil];
    [self checkForProfileImage];
    [self refreshStream];
}

#pragma mark - UserProfileDelegate

- (void)userLoggedOut:(UserProfile *)controller
{
	[self dismissViewControllerAnimated:NO completion:nil];
    [self checkForProfileImage];
    [self refreshStream];
}

#pragma mark -StreamPhotoScreenDelegate

- (void)streamPhotoScreenCompleted:(StreamPhotoScreen *)controller
{
	[self dismissViewControllerAnimated:NO completion:nil];
    [self refreshStream];
}




-(void) userReturns:(UserProfile *)controller withImage:(UIImage *)image
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.profilePicture setImage:[self loadImage]];
}

-(void) checkForProfileImage
{
    if ([API sharedInstance].isAuthorized){
        if ([self loadImage] ==nil) {
            [self.profilePicture setImage:[UIImage imageNamed:@"com_main_profile_back.png"]];
        } else {
            [self.profilePicture setImage:[self loadImage]];
        }
        self.loginBtnLabel.text=@"Edit your profile";
    } else {
        self.loginBtnLabel.text=@"Login";
        [self.profilePicture setImage:[UIImage imageNamed:@"com_main_profile_back.png"]];
    }
    
    //self.label3.text = [NSString stringWithFormat:@"%d",[self getPostsCounter]];
    if ([API sharedInstance].isAuthorized){
        [self setPostsCounter];
    } else {
        self.label3.text= @"0";
    }
    
    if ([API sharedInstance].isAuthorized){
        int km=[API sharedInstance].getUserKm;
        if (km > 1000) {
            self.label1.text = [NSString stringWithFormat:@"%d", km/1000];
            self.label1Sub.text = @"km";
        } else {
            self.label1.text = [NSString stringWithFormat:@"%d", km];
            self.label1Sub.text =@"m";
        }
    }

}

-(void) setPostsCounter
{
    
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"numberOfPosts",@"command",
                                             [NSString stringWithFormat:@"%d",[API sharedInstance].getUserid], @"IdUser",
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   
                                   //completion
                                   if (![json objectForKey:@"error"]) {
                                       NSMutableArray *postsFromSever= [[NSMutableArray alloc] initWithCapacity:[[json objectForKey:@"result"]count]];
                                       postsFromSever=[json objectForKey:@"result"];
                                       NSDictionary* photo = [postsFromSever objectAtIndex:0];
                                       int number = [[photo objectForKey:@"userPosts"] intValue];
                                       self.label3.text =[NSString stringWithFormat:@"%d",number];
                                   }
                                   
                               }];
}

- (UIImage*)loadImage
{
    NSLog(@"Trying to fetch:%@",[NSString stringWithFormat:@"http://www.vimateam.gr/projects/skigreece/community/profiles/%d.jpg",[API sharedInstance].getUserid]);
    UIImage* image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.vimateam.gr/projects/skigreece/community/profiles/%d.jpg",[API sharedInstance].getUserid]]]];
    return image;
}

- (UIImage*)loadImageForUser: (int) user
{
    NSLog(@"POST :Trying to fetch:%@",[NSString stringWithFormat:@"http://www.vimateam.gr/projects/skigreece/community/profiles/%d.jpg",user]);
    UIImage* image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.vimateam.gr/projects/skigreece/community/profiles/%d.jpg",user]]]];
    return image;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataFromSever count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary* photo = [dataFromSever objectAtIndex:indexPath.row];
    int IdPhoto = [[photo objectForKey:@"IdPhoto"] intValue];
    int userId=[[photo objectForKey:@"IdUser"] intValue];
    int type=[[photo objectForKey:@"type"] intValue];
    NSString * user= [photo objectForKey:@"username"];
    NSString * text= [photo objectForKey:@"title"];
    NSString * no_likes=[photo objectForKey:@"likes"];
    NSString * no_comments=[photo objectForKey:@"comments"];
    NSString * place=[photo objectForKey:@"place"];
    NSString * date=[photo objectForKey:@"date"];
    
    static NSString *CellIdentifier1 = @"PhotoStreamCell";
    
    [descriptionsArray addObject:text];
    
    //NSLog(@"%d: Comparing between: Server Side: %@ vs User:%@",indexPath.row,[[API sharedInstance].user objectForKey:@"username"],user);
    
    //if(type==1) {
        PhotoStreamCell *cell = (PhotoStreamCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoStreamCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        //load content and colours
    
        if (user == nil || [user isEqual:[NSNull null]]) {
        // handle the place not being available
        } else {
            cell.headerUser.text = [NSString stringWithFormat:@"@%@",user];
        }

        /*[cell.headerUser setTextColor:[UIColor colorWithRed:(78/255.f) green:(75/255.f) blue:(99/255.f) alpha:1.0f]];*/
        [cell.headerUser setFont:[UIFont fontWithName:@"Myriad Pro" size:13.0f]];
        
        [cell.imageText setFont:[UIFont fontWithName:@"Myriad Pro" size:14.0f]];
    
        if (text == nil || [text isEqual:[NSNull null]]) {
        // handle the place not being available
        } else {
            cell.imageText.text=text;
        }
    
        
        if (place == nil || [place isEqual:[NSNull null]]) {
            // handle the place not being available
            cell.datePlace.text= [NSString stringWithFormat:@"%@",date];

        } else {
            // handle the place being available
            if ([place isEqualToString:@"None"] || [place isEqualToString:@""]) {
                cell.datePlace.text= [NSString stringWithFormat:@"%@",date];
            } else {
                cell.datePlace.text= [NSString stringWithFormat:@"%@, %@",date,place];
            }
        }

        
        [cell.datePlace setTextColor:[UIColor colorWithRed:(0/255.f) green:(81/255.f) blue:(103/255.f) alpha:1.0f]];
        
        [cell.deletePhoto addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.likeButton.tag=IdPhoto;
        cell.deletePhoto.tag=IdPhoto;
    
        /*[cell.facebookBtn addTarget:self action:@selector(fbShare:) forControlEvents:UIControlEventTouchUpInside];
        [cell.twitterBtn addTarget:self action:@selector(twitterShare:) forControlEvents:UIControlEventTouchUpInside];
        cell.facebookBtn.tag=indexPath.row;
        cell.twitterBtn.tag=indexPath.row;*/
    cell.facebookBtn.hidden = YES;
    cell.facebookBtn.userInteractionEnabled = NO;
    cell.twitterBtn.hidden = YES;
    cell.twitterBtn.userInteractionEnabled = NO;

        //load the image
    if (type ==1) {
        API* api = [API sharedInstance];
        NSURL* imageURL = [api urlForImageWithId:[NSNumber numberWithInt: IdPhoto] isThumb:YES];
        
        AFImageRequestOperation* imageOperation =
        [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL]
                                                          success:^(UIImage *image) {
                                                              //create an image view, add it to the view
                                                              UIImageView* thumbView = [[UIImageView alloc] initWithImage: image];
                                                              thumbView.frame = CGRectMake(0,0,90,90);
                                                              thumbView.contentMode = UIViewContentModeScaleAspectFit;
                                                              cell.thumbnail.image=thumbView.image;
                                                          }];
        
        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        [queue addOperation:imageOperation];
        
    } else {
        /*if ([self loadImageForUser:userId] ==nil) {
            [cell.thumbnail setImage:[UIImage imageNamed:@"com_main_profile_back.png"]];
        } else {
            [cell.thumbnail setImage:[self loadImageForUser:userId]];
        }*/
        
        NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.vimateam.gr/projects/skigreece/community/profiles/%d.jpg",userId]];
        
        cell.thumbnail.frame = CGRectMake(cell.thumbnail.frame.origin.x, cell.thumbnail.frame.origin.y+5, 90, 90);
        cell.imgBack.frame = CGRectMake(cell.imgBack.frame.origin.x, cell.imgBack.frame.origin.y+5, 98, 96);
        
        AFImageRequestOperation* imageOperation =
        [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL]
                                                          success:^(UIImage *image) {
                                                              //create an image view, add it to the view
                                                              UIImageView* thumbView = [[UIImageView alloc] initWithImage: image];
                                                              thumbView.frame = CGRectMake(0,0,90,90);
                                                              thumbView.contentMode = UIViewContentModeScaleAspectFit;
                                                              if (thumbView.image == nil) {
                                                                  [cell.thumbnail setImage:[UIImage imageNamed:@"com_main_profile_back.png"]];
                                                              } else {
                                                                  cell.thumbnail.image=thumbView.image;
                                                              }
                                                          }];
        
        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        [queue addOperation:imageOperation];
    }
    
       
        
        if (![API sharedInstance].isAuthorized) {
            //user is not LoggedIn
            //NSLog(@"User is not Logged in - Delete Button will be hidden");
            cell.deletePhoto.hidden=YES;
            cell.deletePhoto.enabled=NO;
        } else {
            //user is logged in - I should check the username
            if([[[API sharedInstance].user objectForKey:@"username"] isEqualToString:user]){
                cell.deletePhoto.hidden=NO;
                cell.deletePhoto.enabled=YES;
            } else {
                cell.deletePhoto.hidden=YES;
                cell.deletePhoto.enabled=NO;
            }
        }
        
        /*change likes buttons*/
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *array = [defaults objectForKey:[NSString stringWithFormat:@"myLikes%d",([API sharedInstance].getUserid)]];
        if ([array containsObject:[NSString stringWithFormat:@"%d",IdPhoto]]) {
            NSLog(@"User %d likes photo :%d", [API sharedInstance].getUserid, IdPhoto);
            [cell.likeButton setImage:[UIImage imageNamed:@"like_done.png"] forState:UIControlStateNormal];
            cell.likeButton.userInteractionEnabled=NO;
        }
        
        cell.no_comments.text=[NSString stringWithFormat:@"%@",no_comments];
        cell.no_likes.text=[NSString stringWithFormat:@"%@",no_likes];
        
        cell.imgBack.backgroundColor = [UIColor colorWithRed:(163/255.f) green:(163/255.f) blue:(163/255.f) alpha:1.0f];

        [cell.headerUser sizeToFit];

    
        return cell;
        
}

-(void)deleteAction:(UIButton *)button
{
    NSLog(@"IdPhoto is :%d",button.tag);
    NSString *indexString=[NSString stringWithFormat:@"%d",button.tag];
    [hud show:YES];
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"deletePost",@"command",
                                             indexString, @"index",
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   
                                   //completion
                                   if (![json objectForKey:@"error"]) {
                                       
                                       [hud hide:YES];
                                       
                                       
                                       //success
                                       /*[[[UIAlertView alloc]initWithTitle:@"Success!"
                                                                  message:@"Post deleted"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Yay!"
                                                        otherButtonTitles: nil] show];*/
                                       
                                       //I should reload data instead of alertview to see my new post
                                       //and clear the textfield
                                       [self refreshStream];
                                       
                                   } else {
                                       
                                       [hud hide:YES];
                                       
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


-(void)likeAction:(UIButton *)button
{
    NSLog(@"Like Action - IdPhoto is :%d",button.tag);
    NSString *indexString=[NSString stringWithFormat:@"%d",button.tag];
    [hud show:YES];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"like",@"command",
                                             indexString, @"IdPhoto",
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   
                                   //completion
                                   if (![json objectForKey:@"error"]) {
                                       
                                       [hud hide:YES];
                                       
                                       
                                       //success
                                       /*[[[UIAlertView alloc]initWithTitle:@"Success!"
                                                                  message:@"Post liked"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Yay!"
                                                        otherButtonTitles: nil] show];*/
                                       
                                       //I should reload data instead of alertview to see my new post
                                       //and clear the textfield
                                       [self refreshStream];
                                       
                                       //save into nsmutableArray in NSUsers to retrieve maybe later
                                       NSMutableArray *array = [NSMutableArray arrayWithArray:[defaults objectForKey:[NSString stringWithFormat:@"myLikes%d",[API sharedInstance].getUserid]]];
                                       if (array == nil) {
                                           NSLog(@"This is the first like that I make");
                                           NSMutableArray * temp = [NSMutableArray array];
                                           [temp addObject:[NSString stringWithFormat:@"%d",button.tag]];
                                           [defaults setObject:temp forKey:[NSString stringWithFormat:@"myLikes%d",[API sharedInstance].getUserid]];
                                           [defaults synchronize];
                                       } else {
                                           NSLog(@"User already has likes: %@",array.description);
                                           int n= [array count];
                                           [array insertObject: [NSString stringWithFormat:@"%d",button.tag] atIndex:n];
                                           [[NSUserDefaults standardUserDefaults] setObject:array forKey:[NSString stringWithFormat:@"myLikes%d",[API sharedInstance].getUserid]];
                                           [defaults synchronize];
                                           NSLog(@"User made a like - New array of likes: %@",array.description);

                                       }
                                       
                                   } else {
                                       
                                       [hud hide:YES];
                                       
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

-(void)fbShare:(UIButton *)button
{
    NSLog(@"IdPhoto is :%d",button.tag);
}

-(void)twitterShare:(UIButton *)button
{
    NSLog(@"IdPhoto is :%d",button.tag);
    
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSString stringWithFormat:@"%d",button.tag], @"Image",
     @"Twitter",@"Social Media",
     nil];
    
    [Flurry logEvent:@"CommunityStream_SocialMediaShare" withParameters:articleParams];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"%@",[descriptionsArray objectAtIndex:button.tag]]];
        //[tweetSheet addImage:image];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"Δεν μπορείτε να ποστάρετε αυτή την στιγμή. Βεβαιωθείτε ότι είστε συνδεδεμένοι και ότι έχετε ένα λογαριασμό twitter στις ρυθμίσεις σας."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 140.0f;

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Selected row:%d",indexPath.row);
    NSLog(@"Data to be passed to the view controller %@",[[dataFromSever objectAtIndex:indexPath.row] description]);
    
    [self.view endEditing:YES];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    StreamPhotoScreen *vc = [sb instantiateViewControllerWithIdentifier:@"EnlargedPhoto"];
    vc.delegate=self;
    vc.stats=[dataFromSever objectAtIndex:indexPath.row];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}

-(void)getConnections
{
    [self refreshStream];
    [self.refreshControl endRefreshing];
}

-(void)refreshStream {
    //just call the "stream" command from the web API
    [hud show:YES];

    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"stream",@"command",
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   //got stream
                                   NSLog(@"got stream with total number of data: %d",[[json objectForKey:@"result"] count]);
                                   NSLog(@"Printing result:%@",[[json objectForKey:@"result"] description]);
                                   dataFromSever= [[NSMutableArray alloc] initWithCapacity:[[json objectForKey:@"result"]count]];
                                   dataFromSever=[json objectForKey:@"result"];
                                   [self.streamTable reloadData];
                                   [hud hide:YES];
                                   //[self showStream:[json objectForKey:@"result"]];
                               }];
    
    
    //update the title
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSTimeZone *currentTimeZone=[NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:currentTimeZone];
    NSDate *date=[NSDate date];
    
    tableViewController.refreshControl.attributedTitle=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Last Updated: %@",[dateFormatter stringFromDate:date]]];
    NSLog(@"Date is :%@",[dateFormatter stringFromDate:date]);

}




- (IBAction)backButton:(id)sender {
    /*stop analytics*/
    [Flurry endTimedEvent:@"CommunityStream" withParameters:nil]; // You can pass in additional
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)label1Info:(id)sender {
    [[[UIAlertView alloc]initWithTitle:@"Θες να ανεβάσεις τα χλμ σου?"
                               message:@"Γράψε παραπάνω χλμ από το Track My Day της εφαρμογης. Μην ξεχνάς πως πρέπει να είσαι logged in για να μετρήσουν!"
                              delegate:nil
                     cancelButtonTitle:@"ΟΚ"
                     otherButtonTitles: nil] show];
}

- (IBAction)label2Info:(id)sender {
    [[[UIAlertView alloc]initWithTitle:@"Ski Greece Fan"
                               message:@"Κάνε τα πιο πολλά ποστ μέσα στην χρονιά στο community και ένα απίθανο δώρο σε περιμένει στο τέλος της φετινής περιόδου!"
                              delegate:nil
                     cancelButtonTitle:@"Super!"
                     otherButtonTitles: nil] show];

}

#pragma mark - facebook functions

- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 /*self.userNameLabel.text = user.name;
                 self.userProfileImage.profileID = user.id;*/
                 //NSLog(@"Name: %@",user.name);
                // NSLog(@"User Id: %@",user.id);
             }
         }];
    }
}

#pragma mark - textField delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 100) ? NO : YES;
}


@end

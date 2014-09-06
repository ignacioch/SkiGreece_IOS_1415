//
//  PhotoScreen.m
//  Ski Greece
//
//  Created by VimaTeamGr on 8/15/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "PhotoScreen.h"
#import "API.h"
#import "LoginScreen.h"
#import "UIImage+Resize.h"
#import "UIAlertView+error.h"
#import  "QuartzCore/QuartzCore.h"
#import "MBProgressHUD.h"



@interface PhotoScreen ()

@end

@implementation PhotoScreen
{
    UIImage *previousImage;
    NSArray *tableData;
    NSString * placeofPhoto;
    CGRect keyboardFrameBeginRect;
    
    MBProgressHUD *hud;


}
@synthesize photo=_photo;
@synthesize imageFromCamera=_imageFromCamera;
@synthesize imgDescription=_imgDescription;
@synthesize applyEffects=_applyEffects;
@synthesize delegate = _delegate;
@synthesize originalCenter=_originalCenter;

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
    
    
    [self cropImage:self.imageFromCamera];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.imgDescription action:@selector(resignFirstResponder)];
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:gestureRecognizer];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud hide:YES];
    
    
    /* self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
     self.tableView.backgroundColor = [UIColor clearColor];*/

    
    tableData = [NSArray arrayWithObjects:@"None",@"Χ.Κ. Παρνασσού",@"Χ.Κ. Καλαβρύτων",@"Χ.Κ. Βασιλίτσας",@"Χ.Κ. Καιμακτσαλάν",@"Χ.Κ. Σελίου",@"Χ.Κ. Πηλίου",@"Χ.Κ. 3-5 Πηγάδια",@"Χ.Κ. Πισοδερίου",@"Χ.Κ. Καρπενησίου",@"Χ.Κ. Ελατοχωρίου",@"Χ.Κ. Λαιλιά",@"Χ.Κ. Μαινάλου",@"Χ.Κ. Φαλακρού",@"Χ.Κ. Ανηλίου",@"Χ.Κ. Περτουλίου",nil];
    
    placeofPhoto=@"None";
    
    self.imgDescription.delegate = self;
    
    self.originalCenter = self.view.center;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationMethod:) name:UIKeyboardDidShowNotification object:nil];
    
    
    self.photo.backgroundColor = [UIColor grayColor];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        
        self.backgroundImg.frame = CGRectMake(0, 0 + [UIApplication sharedApplication].statusBarFrame.size.height  , 320, 550);
        [self.backgroundImg setImage:[UIImage imageNamed:@"background_with_back_5.png"]];
        
        self.bakBtn.frame = CGRectMake(self.bakBtn.frame.origin.x, self.bakBtn.frame.origin.y + OFFSET_IOS_7 , self.bakBtn.frame.size.width , self.bakBtn.frame.size.height);
        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            if (subview.tag == 10) {                // 10 is the delete button
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 10.0f, subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag == 20) {                // 20 is the image
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 10.0f , subview.frame.size.width, 243.0f);
            } else if (subview.tag == 30) {                // 30 is the placeholder
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 10.0f + 15.0f + 10.0f, subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag == 40) {                // 40 is the apply effect button
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 10.0f + 15.0f + 10.0f + 15.0f, subview.frame.size.width, subview.frame.size.height);
            } else if (subview.tag == 50) {                // 50 is the choose place
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 + 10.0f + 15.0f + 10.0f + 15.0f + 20.0f, subview.frame.size.width, subview.frame.size.height);
            }
        }
        
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        
        NSArray *subviews = [self.view subviews];
        
        for (UIView *subview in subviews) {
            if (subview.tag == 20) {                // 20 is the image
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7 , subview.frame.size.width, 243.0f);
            } else {
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y + OFFSET_IOS_7, subview.frame.size.width, subview.frame.size.height);
            }
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

-(void)viewDidAppear:(BOOL)animated
{
    

}

-(void) cropImage:(UIImage*) imgToCrop
{
    UIImage *image = imgToCrop;
    UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(self.photo.frame.size.width, self.photo.frame.size.height) interpolationQuality:kCGInterpolationHigh];
    // Crop the image to a square (yikes, fancy!)
    UIImage *croppedImage = [scaledImage croppedImage:CGRectMake((scaledImage.size.width -self.photo.frame.size.width)/2, (scaledImage.size.height -self.photo.frame.size.height)/2, self.photo.frame.size.width, self.photo.frame.size.height)];
    // Show the photo on the screen
    self.photo.image = croppedImage;
    previousImage=croppedImage;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)applyEffectsAction:(id)sender {
    
    previousImage=self.photo.image;
    
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(self.photo.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    self.photo.image = [UIImage imageWithCGImage:cgimg];
    
    CGImageRelease(cgimg);
}
- (IBAction)uploadPhoto:(id)sender {
    //upload the image and the title to the web service
    [hud show:YES];
    
    NSLog(@"Place of photo to be uploaded is :%@",placeofPhoto);
    
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"upload",@"command",
                                             UIImageJPEGRepresentation(self.photo.image,70),@"file",
                                             self.imgDescription.text, @"title",
                                             placeofPhoto, @"place",
                                             nil]
                               onCompletion:^(NSDictionary *json) {
                                   
                                   //completion
                                   if (![json objectForKey:@"error"]) {
                                       
                                       [hud hide:YES];

                                       //success
                                       /*[[[UIAlertView alloc]initWithTitle:@"Success!"
                                                                  message:@"Your photo is uploaded"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Yay!"
                                                        otherButtonTitles: nil] show];*/
                                       
                                       //add delegate for going back after the image is uploaded
                                       [self.delegate photoScreenCompleted:self];

                                       
                                   } else {
                                       //error, check for expired session and if so - authorize the user
                                       NSString* errorMsg = [json objectForKey:@"error"];
                                       [UIAlertView error:errorMsg];
                                       
                                       if ([@"Authorization required" compare:errorMsg]==NSOrderedSame) {
                                           UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                                           LoginScreen *vc = [sb instantiateViewControllerWithIdentifier:@"CommunityLogin"];
                                           vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                                           [self presentViewController:vc animated:YES completion:NULL];
                                       }
                                   }
                                   
                               }];
}
- (IBAction)undoEffect:(id)sender {
    self.photo.image=previousImage;
}

- (IBAction)getInitialImage:(id)sender {
    [self cropImage:self.imageFromCamera];
}

- (IBAction)cancelCamera:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)choosePlace:(id)sender {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];

    if (defaultPickerView == nil) {
        /*defaultPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(0,245,320,216) backgroundImage:@"PickerBG.png" shadowImage:@"PickerShadow.png" glassImage:@"pickerGlass.png" title:@"Δίαλεξε τοποθεσία"];*/
        if (screenBounds.size.height == 568) {
            defaultPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(0,245 + OFFSET_IOS_7 +  + OFFSET_5 ,320,216) backgroundImage:@"PickerBG.png" shadowImage:@"PickerShadow.png" glassImage:@"pickerGlass.png" title:@" Επίλεξε Χιονοδρομικό"];
            
        } else {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
                defaultPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(0,245 + OFFSET_IOS_7,320,216) backgroundImage:@"PickerBG.png" shadowImage:@"PickerShadow.png" glassImage:@"pickerGlass.png" title:@" Επίλεξε Χιονοδρομικό"];
            } else {
                defaultPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(0,245,320,216) backgroundImage:@"PickerBG.png" shadowImage:@"PickerShadow.png" glassImage:@"pickerGlass.png" title:@" Επίλεξε Χιονοδρομικό"];
            }
        }
        defaultPickerView.dataSource = self;
        defaultPickerView.delegate = self;
        [self.view addSubview:defaultPickerView];
    }
    
    
    [defaultPickerView showPicker];
    [defaultPickerView reloadData];
}

- (IBAction)backButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
    /* keyboard is visible, move views */
    //NSLog(@"textViewDidBeginEditing:");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /* resign first responder, hide keyboard, move views */
    //NSLog(@"textViewDidEndEditing:");
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


#pragma mark - AFPickerViewDataSource

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView {
    return [tableData count];
}


- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%@", [tableData objectAtIndex:row]];
}


#pragma mark - AFPickerViewDelegate

- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row {
    placeofPhoto=[tableData objectAtIndex:row];
    NSLog(@"place: %@",placeofPhoto);
}

- (void)pickerView:(AFPickerView *)pickerView hidedRow:(NSInteger)row
{
}



@end

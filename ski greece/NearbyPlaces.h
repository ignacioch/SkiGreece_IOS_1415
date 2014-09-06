//
//  NearbyPlaces.h
//  Ski Greece
//
//  Created by VimaTeamGr on 10/12/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"
#import <MapKit/MapKit.h>
#import "AFPickerView.h"
#import <QuartzCore/QuartzCore.h>


@class V8HorizontalPickerView;

@interface NearbyPlaces : UIViewController<V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource,MKMapViewDelegate,AFPickerViewDataSource, AFPickerViewDelegate>
{
     AFPickerView *defaultPickerView;
}

@property (nonatomic, strong) IBOutlet V8HorizontalPickerView *pickerView;
@property (nonatomic, strong) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) IBOutlet UIButton *reloadButton;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, weak) id <V8HorizontalPickerViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet MKMapView *placesMap;
@property (strong, nonatomic) IBOutlet UITableView *postsTable;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImage;
@property (strong, nonatomic) IBOutlet UIButton *arrowForCenter;
@property (strong, nonatomic) IBOutlet UITextField *skiCenterplaceholder;
@property (strong, nonatomic) IBOutlet UINavigationBar *topBar;
@property (strong, nonatomic) IBOutlet UIImageView *tableBorder;


- (IBAction)backAction:(id)sender;
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (IBAction)selectSki:(id)sender;

@end

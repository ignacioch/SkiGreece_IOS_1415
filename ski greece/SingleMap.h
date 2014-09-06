//
//  SingleMap.h
//  Ski Greece
//
//  Created by VimaTeamGr on 10/27/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SingleMap : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet UINavigationBar *topBar;
@property (strong, nonatomic) IBOutlet MKMapView *mainMap;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,assign) NSString * name;
@property (nonatomic) int driveme;


@end

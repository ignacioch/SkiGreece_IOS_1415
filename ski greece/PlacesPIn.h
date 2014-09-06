//
//  PlacesPIn.h
//  Ski Greece
//
//  Created by VimaTeamGr on 10/13/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


typedef NS_ENUM(NSInteger, PVAttractionType) {
    VTAttractionDefault = 0,
    VTAttractionHotel,
    VTAttractionFood,
    VTAttractionCoffee,
    VTAttractionSki,
    VTAttractionLocal,
    VTAttractionSkiCenter
};

@interface PlacesPIn : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic) PVAttractionType type;

@end

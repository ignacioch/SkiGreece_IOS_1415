//
//  VTSkiCenterMapOverlay.m
//  Ski Greece
//
//  Created by VimaTeamGr on 8/12/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "VTSkiCenterMapOverlay.h"
#import "VTSkiCenter.h"

@implementation VTSkiCenterMapOverlay

@synthesize coordinate;
@synthesize boundingMapRect;

- (instancetype)initWithPark:(VTSkiCenter *)park {
    self = [super init];
    if (self) {
        boundingMapRect = park.overlayBoundingMapRect;
        coordinate = park.midCoordinate;
        NSLog(@"midCoordinate: %f - %f",coordinate.latitude,coordinate.longitude);
    }
    
    return self;
}

@end

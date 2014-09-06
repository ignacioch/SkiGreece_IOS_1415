//
//  VTSkiCenterMapOverlay.h
//  Ski Greece
//
//  Created by VimaTeamGr on 8/12/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class VTSkiCenter;

@interface VTSkiCenterMapOverlay : NSObject <MKOverlay>

- (instancetype)initWithPark:(VTSkiCenter *)park;

@end

//
//  SkiCenterMapOverlayView.h
//  Ski Greece
//
//  Created by VimaTeamGr on 8/12/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SkiCenterMapOverlayView : MKOverlayView

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage;


@end

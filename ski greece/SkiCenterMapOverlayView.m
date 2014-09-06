//
//  SkiCenterMapOverlayView.m
//  Ski Greece
//
//  Created by VimaTeamGr on 8/12/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//

#import "SkiCenterMapOverlayView.h"

@interface SkiCenterMapOverlayView ()

@property (nonatomic, strong) UIImage *overlayImage;

@end



@implementation SkiCenterMapOverlayView

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage {
    self = [super initWithOverlay:overlay];
    if (self) {
        _overlayImage = overlayImage;
    }
    
    return self;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    CGImageRef imageReference = self.overlayImage.CGImage;
    
    MKMapRect theMapRect = self.overlay.boundingMapRect;
    CGRect theRect = [self rectForMapRect:theMapRect];
    
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -theRect.size.height);
    CGContextDrawImage(context, theRect, imageReference);
    
    //CGImageRelease(imageReference);
}

@end

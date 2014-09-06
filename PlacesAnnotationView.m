//
//  PlacesAnnotationView.m
//  Ski Greece
//
//  Created by VimaTeamGr on 10/13/13.
//  Copyright (c) 2013 VimaTeamGr. All rights reserved.
//



#import "PlacesAnnotationView.h"
#import "PlacesPIn.h"

@implementation PlacesAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        PlacesPIn *attractionAnnotation = self.annotation;
        switch (attractionAnnotation.type) {
            case VTAttractionHotel:
                self.image = [UIImage imageNamed:@"hotel"];
                break;
            case VTAttractionFood:
                self.image = [UIImage imageNamed:@"food"];
                break;
            case VTAttractionCoffee:
                self.image = [UIImage imageNamed:@"coffee"];
                break;
            case VTAttractionSki:
                self.image = [UIImage imageNamed:@"ski"];
                break;
            case VTAttractionLocal:
                self.image = [UIImage imageNamed:@"ski"];
                break;
            default:
                self.image = [UIImage imageNamed:@"ski"];
                break;
        }
    }
    
    return self;
}


@end

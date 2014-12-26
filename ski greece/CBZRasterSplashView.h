//
//  CBZRasterSplashView.h
//  Telly
//
//  Created by Mazyad Alabduljaleel on 8/7/14.
//  Copyright (c) 2014 Telly, Inc. All rights reserved.
//

#import "CBZSplashView.h"

/**
 *  RasterSplash animates in a rasterized UIImage while fading the whole view
 */
@interface CBZRasterSplashView : CBZSplashView

- (instancetype)initWithIconImage:(UIImage *)icon backgroundColor:(UIColor *)color;
- (instancetype)initWithIconImage:(UIImage *)icon backgroundImage:(UIImage *)imageBg;


@end

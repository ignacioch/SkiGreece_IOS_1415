//
//  CBZRasterSplashView.m
//  Telly
//
//  Created by Mazyad Alabduljaleel on 8/7/14.
//  Copyright (c) 2014 Telly, Inc. All rights reserved.
//

#import "CBZRasterSplashView.h"

@interface CBZRasterSplashView ()

@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation CBZRasterSplashView

- (instancetype)initWithIconImage:(UIImage *)icon backgroundColor:(UIColor *)color
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        
        self.backgroundColor = color;
        
        UIImageView *iconImageView = [UIImageView new];
        iconImageView.image = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        iconImageView.tintColor = self.iconColor;
        iconImageView.frame = CGRectMake(0, 0, self.iconStartSize.width, self.iconStartSize.height);
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        iconImageView.center = self.center;
        
        //NSLog(@"X : %f, Y : %f, H : %f, W: %f",iconImageView.frame.origin.x,iconImageView.frame.origin.y,iconImageView.frame.size.height,iconImageView.frame.size.width);
        
        [self addSubview:iconImageView];
        
        _iconImageView = iconImageView;
    }
    return self;
}

- (instancetype)initWithIconImage:(UIImage *)icon backgroundImage:(UIImage *)imageBg
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        NSLog(@"initImage is called");
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.image = imageBg;
        bgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        bgImageView.center = self.center;
        [self addSubview:bgImageView];

        
        UIImageView *iconImageView = [UIImageView new];
        iconImageView.image = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        iconImageView.tintColor = self.iconColor;
        //iconImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        iconImageView.frame = CGRectMake(0, 0, self.iconStartSize.width, self.iconStartSize.height);
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        iconImageView.center = self.center;
        
        //NSLog(@"BG : X : %f, Y : %f, H : %f, W: %f",bgImageView.frame.origin.x,bgImageView.frame.origin.y,bgImageView.frame.size.height,bgImageView.frame.size.width);
        //NSLog(@"ICON :X : %f, Y : %f, H : %f, W: %f",iconImageView.frame.origin.x,iconImageView.frame.origin.y,iconImageView.frame.size.height,iconImageView.frame.size.width);

        
        [self addSubview:iconImageView];
        
        _iconImageView = iconImageView;
    }
    return self;
}

- (void)startAnimationWithCompletionHandler:(void (^)())completionHandler
{
    __block __weak typeof(self) weakSelf = self;
    
    if (!self.animationDuration) {
        return;
    }
    
    CGFloat shrinkDuration = self.animationDuration * 0.3;
    CGFloat growDuration = self.animationDuration * 0.7;
    
    [UIView animateWithDuration:shrinkDuration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.75, 0.75);
        weakSelf.iconImageView.transform = scaleTransform;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:growDuration animations:^{
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(20, 20);
            weakSelf.iconImageView.transform = scaleTransform;
            weakSelf.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
            if (completionHandler) {
                completionHandler();
            }
        }];
    }];
}

@end

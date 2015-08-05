//
//  RICatalogueCollectionViewCell.m
//  RefreshCatalogue
//
//  Created by Ondrej Rafaj on 01/08/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RICatalogueCollectionViewCell.h"


@interface RICatalogueCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIView *countIndicatorView;

@end


@implementation RICatalogueCollectionViewCell

BOOL animating = NO;


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = 20;
    [_countIndicatorView.layer setCornerRadius:(height / 2)];
}

#pragma mark Initialization

- (void)setup {
    
}

#pragma mark Settings

- (void)spinWithOptions:(UIViewAnimationOptions)options {
    // This spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration:0.5f delay:0.0f options:options | UIViewAnimationOptionBeginFromCurrentState animations:^{
        _loadingIndicator.transform = CGAffineTransformRotate(_loadingIndicator.transform, M_PI / 2);
    } completion:^(BOOL finished) {
        if (finished) {
            if (animating) {
                // If flag still set, keep spinning with constant speed
                [self spinWithOptions:UIViewAnimationOptionCurveLinear];
            }
            else if (options != UIViewAnimationOptionCurveEaseOut) {
                // One last spin, with deceleration
                [self spinWithOptions:UIViewAnimationOptionCurveEaseOut];
            }
        }
    }];
}

#pragma mark Settings

- (void)startLoadingAnimation {
    if (!_loadingIndicator.image) {
        FAKIonIcons *icon = [FAKIonIcons loadCIconWithSize:34];
        [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        UIImage *iconImage = [icon imageWithSize:CGSizeMake(34, 34)];
        [_loadingIndicator setImage:iconImage];
    }
    
    animating = YES;
    [self spinWithOptions:UIViewAnimationOptionCurveEaseIn];
}

- (void)stopLoadingAnimation {
    animating = NO;
}


@end

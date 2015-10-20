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

- (void)spinWithOptions {
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    animation.duration = 2;
    animation.repeatCount = INFINITY;
    [_loadingIndicator.layer addAnimation:animation forKey:@"SpinAnimation"];
}

#pragma mark Settings

- (void)startLoadingAnimation {
    [_loadingIndicator.layer removeAllAnimations];
    
    if (!_loadingIndicator.image) {
        FAKIonIcons *icon = [FAKIonIcons loadCIconWithSize:34];
        [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        UIImage *iconImage = [icon imageWithSize:CGSizeMake(34, 34)];
        [_loadingIndicator setImage:iconImage];
    }
    
    animating = YES;
    [self spinWithOptions];
}

- (void)stopLoadingAnimation {
    animating = NO;
}


@end

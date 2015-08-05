//
//  RICatalogueCollectionViewCell.h
//  RefreshCatalogue
//
//  Created by Ondrej Rafaj on 01/08/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RICollectionViewCell.h"


@interface RICatalogueCollectionViewCell : RICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *subtitle;

@property (nonatomic, weak) IBOutlet UIImageView *loadingIndicator;

@property (nonatomic, weak) IBOutlet UILabel *countIndicatorLabel;

- (void)startLoadingAnimation;


@end

//
//  RICatalogueCollectionViewCell.h
//  RefreshCatalogue
//
//  Created by Ondrej Rafaj on 01/08/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RICollectionViewCell.h"


@interface RICatalogueCollectionViewCell : RICollectionViewCell

@property (nonatomic, copy) IBOutlet UIImageView *imageView;

@property (nonatomic, copy) IBOutlet UILabel *title;
@property (nonatomic, copy) IBOutlet UILabel *subtitle;


@end

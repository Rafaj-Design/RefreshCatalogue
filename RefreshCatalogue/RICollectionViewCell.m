//
//  RICollectionViewCell.m
//  RefreshCatalogue
//
//  Created by Ondrej Rafaj on 01/08/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RICollectionViewCell.h"


@implementation RICollectionViewCell


#pragma mark Initialization

- (void)setup {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


@end

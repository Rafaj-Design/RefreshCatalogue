//
//  RIGallery.m
//  RefreshCatalogue
//
//  Created by Ondrej Rafaj on 05/08/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIGallery.h"

@implementation RIGallery


#pragma mark Fake getters

- (NSString *)title {
    return @"Lorem ipsum title";
}

- (NSString *)subtitle {
    return @"London, UK, 20/04/2015";
}

- (NSString *)desc {
    return @"Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.\nLorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. \nLorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.\n\nLorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.";
}

- (NSArray *)photos {
    return @[@"", @"", @"", @""];
}

- (NSArray *)attachments {
    return nil;
}


@end

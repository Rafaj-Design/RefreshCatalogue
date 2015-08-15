//
//  RICatalogueObject.m
//  RefreshCatalogue
//
//  Created by Ondrej Rafaj on 14/08/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RICatalogueObject.h"


@implementation RICatalogueObject


#pragma mark Mapping

+ (NSDictionary *)map {
    return @{
                @"title": @"title",
                @"date": @"date",
                @"content": @"content",
                @"hero": @"hero",
                @"photos": @"photos",
                @"pdf": @"pdf",
                @"location": @"location"
             };
}


@end

//
//  RIFile.h
//  RefreshCatalogue
//
//  Created by Ondrej Rafaj on 11/09/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <CoreData/CoreData.h>


@class RIGallery;

@interface RIFile : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *size;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *section;
@property (nonatomic, retain) NSString *file;
@property (nonatomic, retain) NSString *extension;
@property (nonatomic, retain) RIGallery *gallery;


@end

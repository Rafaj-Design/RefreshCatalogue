//
//  RIGallery.h
//  RefreshCatalogue
//
//  Created by Ondrej Rafaj on 11/09/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <CoreData/CoreData.h>


@class RIFile;

@interface RIGallery : NSManagedObject

@property (nonatomic) NSInteger itemId;
@property (nonatomic) NSInteger status;
@property (nonatomic, retain) NSDate *publishtime;
@property (nonatomic, retain) NSDate *modified;
@property (nonatomic, retain) NSDate *created;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) RIFile *hero;
@property (nonatomic, retain) RIFile *pdf;


@end


@interface RIGallery (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(RIFile *)value;
- (void)removePhotosObject:(RIFile *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;


@end

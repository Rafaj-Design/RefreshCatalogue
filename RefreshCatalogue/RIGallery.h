//
//  RIGallery.h
//  RefreshCatalogue
//
//  Created by Ondrej Rafaj on 05/08/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RIGallery : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *attachments;


@end

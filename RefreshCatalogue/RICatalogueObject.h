//
//  RICatalogueObject.h
//  RefreshCatalogue
//
//  Created by Ondrej Rafaj on 14/08/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <LUIDataFramework/LUIDataFramework.h>


@interface RICatalogueObject : NSObject <LUIDataLanguageObjectProtocol>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) LUIDataFileObject *hero;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) LUIDataFileObject *pdf;


@end

//
//  RIHomeViewController.m
//  RefreshCatalogue
//
//  Created by Ondrej Rafaj on 01/08/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RICatalogueViewController.h"
#import <LUIDataFramework/LUIDataFramework.h>
#import "RICatalogueCollectionViewCell.h"
#import "SlideNavigationController.h"
#import "RICatalogueObject.h"


@interface RICatalogueViewController () <SlideNavigationControllerDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, readonly) LUIDynamicData *service;

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end


@implementation RICatalogueViewController

static NSString * const reuseHeaderIdentifier = @"catalogueHeaderCell";
static NSString * const reuseIdentifier = @"catalogueCell";


#pragma mark Creating elements

- (void)setupRefreshControl {
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl setTintColor:[UIColor colorWithWhite:1 alpha:0.5]];
    [_refreshControl addTarget:self action:@selector(doRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:_refreshControl];
    [self.collectionView setAlwaysBounceVertical:YES];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [self setupRefreshControl];
    
    _service = [[LUIDynamicData alloc] initWithApiKey:@"55CDDA7F-E3F4-40EF-B057-0BCF5C574A68"];
    [_service registerDataObjectClass:[RICatalogueObject class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshData];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark Data

- (void)refreshData {
    __weak typeof(self) weakSelf = self;
    [_service getAll:^(NSArray *data, NSDictionary *map, NSError *error) {
        [weakSelf setData:data];
        [weakSelf.collectionView reloadData];
        
        if ([weakSelf.refreshControl isRefreshing]) {
            [weakSelf.refreshControl endRefreshing];
        }
    }];
}

#pragma mark Actions

- (void)doRefresh:(UIRefreshControl *)sender {
    [self refreshData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    if (indexPath.row == 0) {
        identifier = reuseHeaderIdentifier;
    }
    else {
        identifier = reuseIdentifier;
    }
    RICatalogueCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell startLoadingAnimation];
    
    RICatalogueObject *item = [_data[indexPath.row] content][@"en"];
    [cell.title setText:item.title];
    [cell.subtitle setText:[NSString stringWithFormat:@"%@", item.location]];
    [cell.countIndicatorLabel setText:[NSString stringWithFormat:@"%ld", item.photos.count]];
    
    if (item.hero.fileData) {
        UIImage *img = [[UIImage alloc] initWithData:item.hero.fileData];
        [cell.imageView setImage:img];
    }
    else {
        [cell.imageView setImage:[[UIImage alloc] init]];
        
        [item.hero getFileDataWithSuccessBlock:^(NSData *data, NSError *error) {
            //[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            [self.collectionView reloadData];
        }];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) {
        if (indexPath.row == 0) {
            return CGSizeMake(self.view.frame.size.width, 420);
        }
        else {
            return CGSizeMake(((self.view.frame.size.width / 2) - 1), 320);
        }
    }
    else {
        if (indexPath.row == 0) {
            return CGSizeMake(self.view.frame.size.width, 280);
        }
        else {
            return CGSizeMake(((self.view.frame.size.width / 2) - 1), 170);
        }
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);  // top, left, bottom, right
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

#pragma mark Slide controller delegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu {
    return NO;
}


@end

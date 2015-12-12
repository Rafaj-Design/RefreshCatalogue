//
//  RIHomeViewController.m
//  RefreshCatalogue
//
//  Created by Ondrej Rafaj on 01/08/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RICatalogueViewController.h"
#import <LUIDataFramework/LUIDataFramework.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MHVideoPhotoGallery/MHGallery.h>
#import <Reachability/Reachability.h>
#import "RICatalogueCollectionViewCell.h"
#import "SlideNavigationController.h"
#import "RICatalogueObject.h"


@interface RICatalogueViewController () <SlideNavigationControllerDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, readonly) LUIDynamicData *service;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, readonly) UIRefreshControl *refreshControl;

@property (nonatomic, readonly) Reachability *reachability;

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
    
    __weak typeof(self) weakSelf = self;
    _reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    [_reachability setReachableBlock:^(Reachability *reachability) {
        [weakSelf.collectionView reloadData];
    }];
    [_reachability setUnreachableBlock:^(Reachability *reachability) {
        [weakSelf.collectionView reloadData];
    }];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_data) {
        [self refreshData];
    }
    else {
        [self.collectionView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    //return 1;
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
    [cell.countIndicatorLabel setText:[NSString stringWithFormat:@"%ld", (long)(item.photos.count + 1)]];
    
    NSString *imageKey = item.hero.name;
    UIImage *img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageKey];
    if (img) {
        [cell.imageView setImage:img];
        if (cell.imageView.alpha < 1) {
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [cell.imageView setAlpha:1];
                [cell.loadingIndicator setAlpha:0];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    else {
        [cell.imageView setAlpha:0];
        [cell.loadingIndicator setAlpha:1];
        
        if (_reachability.isReachable) {
            [item.hero getFileDataWithSuccessBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        UIImage *img = [[UIImage alloc] initWithData:data];
                        [[SDImageCache sharedImageCache] storeImage:img forKey:imageKey toDisk:YES];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                        });
                    });
                }
            }];
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = self.view.frame.size.width;
    if (w < 40) {
        w = 40;
    }
    if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) {
        if (indexPath.row == 0) {
            return CGSizeMake(w, 420);
        }
        else {
            return CGSizeMake(((w / 2) - 1), 320);
        }
    }
    else {
        if (indexPath.row == 0) {
            return CGSizeMake(w, 280);
        }
        else {
            return CGSizeMake(((w / 2) - 1), 170);
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    UIImageView *imageView = [(RICatalogueCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath] imageView];
    
    MHGalleryItem *hero = [MHGalleryItem itemWithImage:imageView.image];
    MHGalleryItem *image1 = [MHGalleryItem itemWithURL:@"https://pbs.twimg.com/profile_images/641656002568261632/Gnw8AJ4J.jpg" galleryType:MHGalleryTypeImage];
    MHGalleryItem *image2 = [MHGalleryItem itemWithURL:@"http://www.ondrej-rafaj.co.uk/data/xpl1.jpg" galleryType:MHGalleryTypeImage];
    MHGalleryItem *youtube = [MHGalleryItem itemWithYoutubeVideoID:@"dBgMVtxrIN0"];
    
    NSArray *galleryData = @[hero, image1,image2,youtube];
    
    MHGalleryController *gallery = [MHGalleryController galleryWithPresentationStyle:MHGalleryViewModeImageViewerNavigationBarHidden];
    [gallery.overViewViewController.view setBackgroundColor:[UIColor blackColor]];
    gallery.galleryItems = galleryData;
    gallery.presentingFromImageView = imageView;
    gallery.presentationIndex = 0;
    
    __weak MHGalleryController *blockGallery = gallery;
    
    gallery.finishedCallback = ^(NSInteger currentIndex, UIImage *image, MHTransitionDismissMHGallery *interactiveTransition, MHGalleryViewMode viewMode){
        NSIndexPath *newIndex = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:newIndex atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *imageView = [(RICatalogueCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath] imageView];
            [blockGallery dismissViewControllerAnimated:YES dismissImageView:imageView completion:nil];
        });
        
    };    
    [self presentMHGalleryController:gallery animated:YES completion:nil];
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

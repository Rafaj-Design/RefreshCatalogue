//
//  RIHomeViewController.m
//  RefreshCatalogue
//
//  Created by Ondrej Rafaj on 01/08/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RICatalogueViewController.h"
#import "RICatalogueCollectionViewCell.h"
#import "SlideNavigationController.h"
#import "UIImageView+AFNetworking.h"


@interface RICatalogueViewController () <SlideNavigationControllerDelegate, UICollectionViewDelegateFlowLayout>

@end


@implementation RICatalogueViewController

static NSString * const reuseHeaderIdentifier = @"catalogueHeaderCell";
static NSString * const reuseIdentifier = @"catalogueCell";


#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 21;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    if (indexPath.row == 0 && ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) {
        identifier = reuseHeaderIdentifier;
    }
    else {
        identifier = reuseIdentifier;
    }
    RICatalogueCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell startLoadingAnimation];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://lorempixel.com/600/420/?x=%ld", (long)indexPath.row]];
    [cell.imageView setImageWithURL:url placeholderImage:[[UIImage alloc] init]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 220;
    if (self.view.frame.size.width < 500) {
        return CGSizeMake(self.view.frame.size.width, height);
    }
    else {
        if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) && indexPath.row == 0) {
            height = 450;
            return CGSizeMake(self.view.frame.size.width, height);
        }
        else {
            if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) {
                UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
                if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
                    height += 100;
                }
            }
        }
        return CGSizeMake(((self.view.frame.size.width / 2) - 1), height);
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

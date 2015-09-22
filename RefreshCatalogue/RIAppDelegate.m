//
//  RIAppDelegate.m
//  RefreshCatalogue
//
//  Created by Ondrej Rafaj on 01/08/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIAppDelegate.h"
#import <LUIFramework/LUIFramework.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "SlideNavigationController.h"
#import "RIMenuViewController.h"


@interface RIAppDelegate ()

@property (nonatomic, readonly) RIMenuViewController *menuViewController;

@end


@implementation RIAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[CrashlyticsKit]];
    
    // LiveUI
    //[[LUIURLs sharedInstance] setCustomApiUrlString:@"http://localhost/api.liveui.io"];
    //[[LUIURLs sharedInstance] setCustomAssetsUrlString:@"http://localhost/images.liveui.io"];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _menuViewController = (RIMenuViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"menu"];
    
    [[SlideNavigationController sharedInstance] setLeftMenu:_menuViewController];
    
    // Calculate portrait values for the menu offset values
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if (screenWidth > screenHeight) {
        screenWidth = screenHeight;
        screenHeight = screenRect.size.width;
    }
    [[SlideNavigationController sharedInstance] setPortraitSlideOffset:(screenWidth - 280)];
    [[SlideNavigationController sharedInstance] setLandscapeSlideOffset:(screenHeight - 280)];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

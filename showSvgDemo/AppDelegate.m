//
//  AppDelegate.m
//  showSvgDemo
//
//  Created by GB on 2016/11/16.
//  Copyright © 2016年 gb. All rights reserved.
//

#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "MapSvgViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    MapSvgViewController *svgVC=[[MapSvgViewController alloc] init];
    svgVC.svgMapName=[[NSBundle mainBundle] pathForResource:@"map.svg" ofType:nil];
    svgVC.svgMapPath=[[NSBundle mainBundle] pathForResource:@"paths.xml" ofType:nil];
    svgVC.svgMapPoint=[[NSBundle mainBundle] pathForResource:@"points.xml" ofType:nil];
    
    UINavigationController *navVC=[[UINavigationController alloc] initWithRootViewController:svgVC];
    navVC.navigationBar.backgroundColor=[UIColor colorWithRed:69/255.0 green:61/255.0 blue:50/255.0 alpha:1.0];
    
    self.window.rootViewController=navVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [AMapServices sharedServices].apiKey =@"c76230a5f61ba0aa812165c83f10c823";
    
    //设置SVProgressHUD样式
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
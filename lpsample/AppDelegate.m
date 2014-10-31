//
//  AppDelegate.m
//
//  Copyright (c) 2014 spotlight. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <lpsdk/lpsdk.h>

#import "BeaconDeviceListViewController.h"
#import "AppDelegate.h"


@interface AppDelegate () <LPFBeaconRegionDelegate>
@property (nonatomic, strong) UINavigationController *navicationController;
@property (nonatomic, strong) BeaconDeviceListViewController *beaconViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"Light Platform SDK Version: %s", lpsdkVersionString);

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }

    self.beaconViewController = [[BeaconDeviceListViewController alloc] initWithStyle:UITableViewStylePlain];
    self.navicationController = [[UINavigationController alloc] initWithRootViewController:self.beaconViewController];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navicationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)didEnterBeaconRegion {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"found ibeacon";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [LPFBeaconManager startiBeaconSearch];
}


@end

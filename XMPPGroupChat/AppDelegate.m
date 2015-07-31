//
//  AppDelegate.m
//  XMPPGroupChat
//
//  Created by Dylan Shine on 7/30/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPManager.h"
#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDTTYLogger.h>
#import <XMPPLogging.h>

@interface AppDelegate ()
@property (nonatomic) XMPPManager *xmppManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:~0];

    self.xmppManager = [XMPPManager sharedManager];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self.xmppManager disconnect];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.xmppManager connect];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

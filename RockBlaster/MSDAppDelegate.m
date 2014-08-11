//
//  MSDAppDelegate.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/6/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDAppDelegate.h"
#import "PHLoadingViewController.h"


@interface MSDAppDelegate ()

@property (nonatomic, strong) PHLoadingViewController *loadingView;

@property (nonatomic, strong) PHBridgeSearching *bridgeSearch;
@property (nonatomic, strong) UIAlertView *noConnectionAlert;
@property (nonatomic, strong) UIAlertView *noBridgeFoundAlert;
@property (nonatomic, strong) UIAlertView *authenticationFailedAlert;

@property (nonatomic, strong) PHBridgePushLinkViewController *pushLinkViewController;
@property (nonatomic, strong) PHBridgeSelectionViewController *bridgeSelectionViewController;


@end

@implementation MSDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.phHueSDK = [[PHHueSDK alloc] init];
    [self.phHueSDK startUpSDK];
    [self.phHueSDK enableLogging:YES];
    
    PHNotificationManager *notificationManager = [PHNotificationManager defaultManager];
    
    [notificationManager registerObject:self withSelector:@selector(localConnection) forNotification:LOCAL_CONNECTION_NOTIFICATION];
    [notificationManager registerObject:self withSelector:@selector(noLocalConnection) forNotification:NO_LOCAL_CONNECTION_NOTIFICATION];
    [notificationManager registerObject:self withSelector:@selector(notAuthenticated) forNotification:NO_LOCAL_AUTHENTICATION_NOTIFICATION];
    
    [self enableLocalHeartbeat];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self disableLocalHeartbeat];
    
    // Remove any open popups
    if (self.noConnectionAlert != nil) {
        [self.noConnectionAlert dismissWithClickedButtonIndex:[self.noConnectionAlert cancelButtonIndex] animated:NO];
        self.noConnectionAlert = nil;
    }
    if (self.noBridgeFoundAlert != nil) {
        [self.noBridgeFoundAlert dismissWithClickedButtonIndex:[self.noBridgeFoundAlert cancelButtonIndex] animated:NO];
        self.noBridgeFoundAlert = nil;
    }
    if (self.authenticationFailedAlert != nil) {
        [self.authenticationFailedAlert dismissWithClickedButtonIndex:[self.authenticationFailedAlert cancelButtonIndex] animated:NO];
        self.authenticationFailedAlert = nil;
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self enableLocalHeartbeat];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) localConnection {
    [self checkConnectionState];
}

- (void) noLocalConnection {
    [self checkConnectionState];
}

- (void) notAuthenticated {
    NSLog(@"Not authenticated. Let us authenticate perhaps?");
    [self performSelector:@selector(doAuthentication) withObject:nil afterDelay:0.5];
}

- (void) checkConnectionState {
    if (!self.phHueSDK.localConnected) {
        NSLog(@"No local connection. RockBlaster doesn't handle this scenario!");
    } else {
        NSLog(@"We have a local connection!");
    }
}

- (void) enableLocalHeartbeat {
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    if (cache != nil && cache.bridgeConfiguration != nil && cache.bridgeConfiguration.ipaddress != nil) {
        NSLog(@"Connecting to Hue...");
        [self.phHueSDK enableLocalConnectionUsingInterval:10];
    } else {
        [self searchForBridgeLocal];
    }
}

- (void) disableLocalHeartbeat {
    [self.phHueSDK disableLocalConnection];
}

- (void) searchForBridgeLocal {
    [self disableLocalHeartbeat];
    
    self.bridgeSearch = [[PHBridgeSearching alloc] initWithUpnpSearch:YES andPortalSearch:YES andIpAdressSearch:YES];
    [self.bridgeSearch startSearchWithCompletionHandler:^(NSDictionary *bridgesFound) {
        
        if (bridgesFound.count > 0) {
            self.bridgeSelectionViewController = [[PHBridgeSelectionViewController alloc] initWithNibName:@"PHBridgeSelectionViewController" bundle:[NSBundle mainBundle] bridges:bridgesFound delegate:self];
            [self.window.rootViewController presentViewController:self.bridgeSelectionViewController animated:YES completion:^{
                NSLog(@"Done presenting bridge selection");
            }];
        } else {
            NSLog(@"No bridges found. Try again...");
        }
        
    }];
}

- (void) bridgeSelectedWithIpAddress:(NSString *)ipAddress andMacAddress:(NSString *)macAddress {
    
    self.bridgeSelectionViewController = nil;
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Done dismissing bridge selection");
    }];
    
    [self.phHueSDK setBridgeToUseWithIpAddress:ipAddress macAddress:macAddress];
    [self performSelector:@selector(enableLocalHeartbeat) withObject:nil afterDelay:1];
}

- (void)doAuthentication {
    [self disableLocalHeartbeat];
    
    self.pushLinkViewController = [[PHBridgePushLinkViewController alloc] initWithNibName:@"PHBridgePushLinkViewController" bundle:[NSBundle mainBundle] hueSDK:self.phHueSDK delegate:self];
    
    [self.window.rootViewController presentViewController:self.pushLinkViewController animated:YES completion:^{
        NSLog(@"Completed presenting link push");
        [self.pushLinkViewController startPushLinking];
    }];
}

- (void) pushlinkSuccess {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissing completed for link controller");
    }];
    
    self.pushLinkViewController = nil;
    [self performSelector:@selector(enableLocalHeartbeat) withObject:nil afterDelay:1];
}

- (void) pushlinkFailed:(PHError *)error {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissing completed for link controller");
    }];
    
    self.pushLinkViewController = nil;
    if (error.code == PUSHLINK_NO_CONNECTION) {
        // No local connection to bridge
        [self noLocalConnection];
        
        // Start local heartbeat (to see when connection comes back)
        [self performSelector:@selector(enableLocalHeartbeat) withObject:nil afterDelay:1];
    } else {
        NSLog(@"Other Error:%@", error.description);
    }
}

@end


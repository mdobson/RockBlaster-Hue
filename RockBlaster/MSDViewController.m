//
//  MSDViewController.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/6/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDViewController.h"
#import "MSDTitleScene.h"
#import "MSDAppDelegate.h"

#import <HueSDK_iOS/HueSDK.h>
#define MAX_HUE 65535

@implementation MSDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    PHNotificationManager *notificationManager = [PHNotificationManager defaultManager];
    // Register for the local heartbeat notifications
    [notificationManager registerObject:self withSelector:@selector(localConnection) forNotification:LOCAL_CONNECTION_NOTIFICATION];
    [notificationManager registerObject:self withSelector:@selector(noLocalConnection) forNotification:NO_LOCAL_CONNECTION_NOTIFICATION];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MSDTitleScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
//    MSDAppDelegate *delegate = (MSDAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [delegate searchForBridgeLocal];
    // Present the scene.
    [skView presentScene:scene];
}

- (void)localConnection{
    
    [self loadConnectedBridgeValues];
    
}

- (void) noLocalConnection {
    NSLog(@"No local connection");
}

- (void)loadConnectedBridgeValues{
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    
    // Check if we have connected to a bridge before
    if (cache != nil && cache.bridgeConfiguration != nil && cache.bridgeConfiguration.ipaddress != nil){
        
        MSDAppDelegate *delegate = (MSDAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (delegate.phHueSDK.localConnected) {
            
            // Show current time as last successful heartbeat time when we are connected to a bridge
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterNoStyle];
            [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
            
            PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
            id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
            
            for (PHLight *light in cache.lights.allValues) {
                
                PHLightState *lightState = [[PHLightState alloc] init];
                
                [lightState setHue:[NSNumber numberWithInt:arc4random() % MAX_HUE]];
                [lightState setBrightness:[NSNumber numberWithInt:254]];
                [lightState setSaturation:[NSNumber numberWithInt:254]];
                
                // Send lightstate to light
                [bridgeSendAPI updateLightStateForId:light.identifier withLighState:lightState completionHandler:^(NSArray *errors) {
                    if (errors != nil) {
                        NSString *message = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Errors", @""), errors != nil ? errors : NSLocalizedString(@"none", @"")];
                        
                        NSLog(@"Response: %@",message);
                    }
                }];
            }
            
        } else {
            NSLog(@"Can't play with lights...");
        }
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end

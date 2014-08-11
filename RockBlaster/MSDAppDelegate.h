//
//  MSDAppDelegate.h
//  RockBlaster
//
//  Created by Matthew Dobson on 8/6/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HueSDK_iOS/HueSDK.h>
#import "PHBridgeSelectionViewController.h"
#import "PHBridgePushLinkViewController.h"

@interface MSDAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, PHBridgeSelectionViewControllerDelegate, PHBridgePushLinkViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PHHueSDK *phHueSDK;

- (void)enableLocalHeartbeat;
- (void)disableLocalHeartbeat;
- (void)searchForBridgeLocal;

@end

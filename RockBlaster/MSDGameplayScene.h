//
//  MSDGameplayScene.h
//  RockBlaster
//
//  Created by Matthew Dobson on 8/7/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MSDGameOverDelegate.h"

@interface MSDGameplayScene : SKScene<SKPhysicsContactDelegate,MSDGameOverDelegate,UIGestureRecognizerDelegate>

@end

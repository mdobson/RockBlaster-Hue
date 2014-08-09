//
//  MSDGameplayScene.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/7/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "MSDGameplayScene.h"
#import "MSDBackgroundNode.h"
#import "MSDPlayerShipNode.h"
#import "MSDProjectileNode.h"
#import "MSDAsteroidNode.h"
#import "MSDBlasterUtil.h"

@interface MSDGameplayScene ()

@property (nonatomic, retain) MSDBackgroundNode *background;
@property (nonatomic, retain) MSDPlayerShipNode *ship;
@property (nonatomic) NSTimeInterval lastAsteroidInterval;
@property (nonatomic) NSTimeInterval asteroidInterval;
@property (nonatomic) NSTimeInterval totalInterval;
@property (nonatomic) NSTimeInterval lastUpdateInterval;
@property (nonatomic, retain) CMMotionManager *manager;

@end

@implementation MSDGameplayScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.asteroidInterval = 1.25;
        self.manager = [[CMMotionManager alloc] init];
        self.manager.deviceMotionUpdateInterval = 0.2;
        MSDBackgroundNode *background = [MSDBackgroundNode createBackgroundNodeWithPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        self.background = background;
        [self addChild:self.background];

        self.ship = [MSDPlayerShipNode shipWithPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 150)];
        self.ship.zPosition = 10;
        [self addChild:self.ship];
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        //CGPoint position = [touch locationInNode:self];
        MSDProjectileNode *projectile = [MSDProjectileNode projectileNodeAtPosition:CGPointMake(self.ship.position.x, self.ship.size.height)];
        [self addChild:projectile];
        [projectile moveProjectileToPosition:CGPointMake(self.ship.position.x, self.frame.size.height + projectile.frame.size.height + 10)];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self.background scrollBackground];
    if (self.lastUpdateInterval) {
        self.lastAsteroidInterval += currentTime - self.lastUpdateInterval;
    }
    
    if (self.lastAsteroidInterval > self.asteroidInterval) {
        [self addAsteroid];
        self.lastAsteroidInterval = 0;
    }
    self.lastUpdateInterval = currentTime;
    
}

- (void) addAsteroid{
    MSDAsteroidNode *asteroid = [MSDAsteroidNode asteroidNode];
    float dy = [MSDBlasterUtil randomWithMin:MSDAsteroidMinSpeed max:MSDAsteroidMaxSpeed];
    asteroid.physicsBody.velocity = CGVectorMake(0, dy);
    float y = self.frame.size.height + asteroid.frame.size.height;
    float x = [MSDBlasterUtil randomWithMin:10+asteroid.size.width max:self.frame.size.width - asteroid.size.width - 10];
    asteroid.position = CGPointMake(x, y);
    [self addChild:asteroid];
}


- (void)didMoveToView:(SKView *)view {
    [self.manager startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        if (error) {
            NSLog(@"Error:%@", error);
        } else {
            float quat = motion.attitude.quaternion.y;
            if (quat > 0) {
                NSLog(@"GREATER THAN 0: %f", quat);
                self.ship.physicsBody.velocity = CGVectorMake(450 * quat, 0);
            } else {
                NSLog(@"LESS THAN 0: %f", quat);
                self.ship.physicsBody.velocity = CGVectorMake(450 * quat, 0);
            }
        }
    }];
}

@end

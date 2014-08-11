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
#import "MSDWallNode.h"
#import "MSDGameState.h"
#import "MSDHudNode.h"
#import "MSDGameOverNode.h"
#import "MSDEnemyNode.h"
#import <HueSDK_iOS/HueSDK.h>

#define RED 225
#define BLUE 46500
#define PURPLE 60000
#define MAX_HUE 65535

@interface MSDGameplayScene ()

@property (nonatomic, retain) MSDBackgroundNode *background;
@property (nonatomic, retain) MSDPlayerShipNode *ship;
@property (nonatomic) NSTimeInterval lastAsteroidInterval;
@property (nonatomic) NSTimeInterval asteroidInterval;
@property (nonatomic) NSTimeInterval totalInterval;
@property (nonatomic) NSTimeInterval lastUpdateInterval;
@property (nonatomic, retain) CMMotionManager *manager;
@property (nonatomic, retain) MSDGameState *state;
@property (nonatomic, retain) MSDHudNode *hud;
@property (nonatomic) BOOL restart;

@property (nonatomic, retain) UIPanGestureRecognizer *dragGestureRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation MSDGameplayScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.asteroidInterval = 1.25;
        self.manager = [[CMMotionManager alloc] init];
        self.manager.deviceMotionUpdateInterval = 0.2;
        self.state = [MSDGameState gameStateWithLives:3 andScoreIncrement:10];
        self.restart = NO;
        self.physicsWorld.contactDelegate = self;
        MSDBackgroundNode *background = [MSDBackgroundNode createBackgroundNodeWithPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        self.background = background;
        [self addChild:self.background];

        self.ship = [MSDPlayerShipNode shipWithPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 150)];
        self.ship.zPosition = 10;
        [self addChild:self.ship];
        
        CGSize wallSize = CGSizeMake(1, self.frame.size.height);
        MSDWallNode *leftWall = [MSDWallNode wallWithSize:wallSize];
        MSDWallNode *rightWall = [MSDWallNode wallWithSize:wallSize];
        leftWall.position = CGPointMake(CGRectGetMinX(self.frame), 0);
        rightWall.position = CGPointMake(CGRectGetMaxX(self.frame), 0);
        [self addChild:leftWall];
        [self addChild:rightWall];
        self.hud = [MSDHudNode hudNodeWithPosition:CGPointMake(0, self.frame.size.height - 20) inFrame:self.frame withGameState:self.state];
        self.state.hudDelegate = self.hud;
        self.state.gameOverDelegate = self;
        [self addChild:self.hud];
        [self setLightsToColor:BLUE];
//        MSDEnemyNode *enemy = [MSDEnemyNode enemyWithPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
//        [self addChild:enemy];
    }
    return self;
}

-(void) gameover {
    [self debrisAtPosition:self.ship.position];
    [self.ship removeFromParent];
    MSDGameOverNode *gameOver = [MSDGameOverNode gameOverNodeWithPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [self addChild:gameOver];
    [self setLightsToColor:RED];
    self.restart = YES;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //for (UITouch *touch in touches) {
        //CGPoint position = [touch locationInNode:self];
    //}
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self enumerateChildNodesWithName:@"Missle" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y > self.frame.size.height) {
            [node removeFromParent];
        }
    }];
    
    [self enumerateChildNodesWithName:@"Asteroid" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0) {
            [node removeFromParent];
        }
    }];
    
    [self.background scrollBackground];
    if (self.lastUpdateInterval) {
        self.lastAsteroidInterval += currentTime - self.lastUpdateInterval;
        self.totalInterval += currentTime - self.lastUpdateInterval;
    }
    
    if (self.lastAsteroidInterval > self.asteroidInterval && ![self.state isGameover]) {
        [self addAsteroid];
        self.lastAsteroidInterval = 0;
    }
    self.lastUpdateInterval = currentTime;
    
    if (self.totalInterval > 120) {
        self.asteroidInterval = 0.50;
    } else if (self.totalInterval > 90) {
        self.asteroidInterval = 0.65;
    } else if (self.totalInterval > 60) {
        self.asteroidInterval = 0.75;
    } else if (self.totalInterval > 30) {
        self.asteroidInterval = 1.0;
    }
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
    if (NO) {
        [self.manager startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            if (error) {
                NSLog(@"Error:%@", error);
            } else {
                //float quat = motion.attitude.quaternion.y;
                double yaw = motion.attitude.yaw;
                //NSLog(@"YAW:%f", yaw);
                if (yaw < 0) {
                    //NSLog(@"GREATER THAN 0: %f", quat);
                    self.ship.physicsBody.velocity = CGVectorMake(60 * yaw, 0);
                } else {
                    //NSLog(@"LESS THAN 0: %f", quat);
                    self.ship.physicsBody.velocity = CGVectorMake(60 * yaw, 0);
                }
            }
        }];
    } else {
        self.dragGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
        [view addGestureRecognizer:self.dragGestureRecognizer];
        
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [view addGestureRecognizer:self.tapGestureRecognizer];
    }
}

- (void) handleDrag:(UIPanGestureRecognizer*) recognizer{
    CGPoint translation = [recognizer translationInView:self.view];
    SKAction *move = [SKAction moveByX:translation.x y:0 duration:0];
    [self.ship runAction:move];
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void) handleTap:(UITapGestureRecognizer*) recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (![self.state isGameover]) {
            MSDProjectileNode *projectile = [MSDProjectileNode projectileNodeAtPosition:CGPointMake(self.ship.position.x, self.ship.size.height)];
            [self addChild:projectile];
            [projectile moveProjectileToPosition:CGPointMake(self.ship.position.x, self.frame.size.height + projectile.frame.size.height + 10)];
        } else if (self.restart) {
            for (SKNode *node in [self children]) {
                [node removeFromParent];
            }
            
            MSDGameplayScene *scene = [MSDGameplayScene sceneWithSize:self.view.bounds.size];
            [self.view presentScene:scene];
        }
    }
}


- (void) didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (firstBody.categoryBitMask == MSDCollisionCategoryEnemy && secondBody.categoryBitMask == MSDCollisionCategoryProjectile) {
        [self debrisAtPosition:contact.contactPoint];
        [firstBody.node removeFromParent];
        [secondBody.node removeFromParent];
        [self.state updateScore];
        [self randomLightToColor];
    }
    
    if (firstBody.categoryBitMask == MSDCollisionCategoryEnemy && secondBody.categoryBitMask == MSDCollisionCategoryPlayer) {
        [self debrisAtPosition:contact.contactPoint];
        [firstBody.node removeFromParent];
        [self.state removeLife];
    }
}

- (void) debrisAtPosition:(CGPoint) position {
    NSInteger numberOfPieces = [MSDBlasterUtil randomWithMin:5 max:10];
    
    for (int i = 0; i < numberOfPieces; i++) {
        NSInteger randomPiece = [MSDBlasterUtil randomWithMin:1 max:11];
        NSString *imageName = [NSString stringWithFormat:@"debris_%02d", (int)randomPiece];
        SKSpriteNode *debris = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        debris.position = position;
        [self addChild:debris];
        
        debris.name = @"Debris";
        debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debris.frame.size];
        debris.physicsBody.contactTestBitMask = 0;
        debris.physicsBody.collisionBitMask = MSDCollisionCategoryDebris;
        debris.physicsBody.categoryBitMask = MSDCollisionCategoryDebris;
        debris.physicsBody.velocity = CGVectorMake([MSDBlasterUtil randomWithMin:-150 max:150], [MSDBlasterUtil randomWithMin:-150 max:150]);
    }
    
    NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    explosion.position = position;
    [self addChild:explosion];
    [explosion runAction:[SKAction waitForDuration:2.0] completion:^{
        [explosion removeFromParent];
    }];
}

- (void) setLightsToColor:(int)code {
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
    
    for (PHLight *light in cache.lights.allValues) {
        
        PHLightState *lightState = [[PHLightState alloc] init];
        [lightState setHue:[NSNumber numberWithInt:code]];
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

}

- (void) randomLightToColor {
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
    NSNumber *color = [NSNumber numberWithInt:arc4random() % MAX_HUE];
    PHLight *light = cache.lights.allValues[[MSDBlasterUtil randomWithMin:1 max:cache.lights.allValues.count - 1]];
    PHLightState *lightState = [[PHLightState alloc] init];
    [lightState setHue:color];
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

@end

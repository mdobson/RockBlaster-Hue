//
//  MSDTransitionShip.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/7/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDPlayerShipNode.h"
#import "MSDBlasterUtil.h"

@implementation MSDPlayerShipNode

+ (instancetype) shipWithPosition:(CGPoint)position {
    MSDPlayerShipNode *ship = [self spriteNodeWithImageNamed:@"ship-small_01"];
    
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"ship-small_01"],
                          [SKTexture textureWithImageNamed:@"ship-small_02"],
                          [SKTexture textureWithImageNamed:@"ship-small_03"],
                          [SKTexture textureWithImageNamed:@"ship-small_04"]];
    SKAction *animate = [SKAction animateWithTextures:textures timePerFrame:0.2];
    NSString *afterburnerPath = [[NSBundle mainBundle] pathForResource:@"Afterburner" ofType:@"sks"];
    SKEmitterNode *afterburner = [NSKeyedUnarchiver unarchiveObjectWithFile:afterburnerPath];
    afterburner.position = CGPointMake(CGRectGetMidX(ship.frame), CGRectGetMinY(ship.frame) + 10);
    afterburner.zPosition = 15;
    [ship addChild:afterburner];
    
    
    [ship runAction:[SKAction repeatActionForever:animate]];
    ship.position = position;
    [ship setupPhysics];
    return ship;
}

- (void) setupPhysics {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.categoryBitMask = MSDCollisionCategoryPlayer;
    self.physicsBody.collisionBitMask = MSDCollisionCategoryWall;
    self.physicsBody.contactTestBitMask = MSDCollisionCategoryEnemy;
}

@end

//
//  MSDProjectileNode.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/8/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDProjectileNode.h"
#import "MSDBlasterUtil.h"

@implementation MSDProjectileNode

+ (instancetype) projectileNodeAtPosition:(CGPoint)position {
    MSDProjectileNode *projectile = [self spriteNodeWithImageNamed:@"missile"];
    projectile.xScale = 0.5;
    projectile.yScale = 0.5;
    projectile.position = position;
    projectile.name = @"Missle";
    [projectile setupPhysics];
    return projectile;
}

- (void) moveProjectileToPosition:(CGPoint)position {
    SKAction *move = [SKAction moveTo:position duration:1.0];
    [self runAction:move];
}

- (void) setupPhysics {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = MSDCollisionCategoryProjectile;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = MSDCollisionCategoryEnemy;
}

@end

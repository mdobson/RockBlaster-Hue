//
//  MSDAsteroidNode.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/8/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDAsteroidNode.h"
#import "MSDBlasterUtil.h"

@implementation MSDAsteroidNode

+ (instancetype) asteroidAtPosition:(CGPoint)position {
    MSDAsteroidNode *asteroid = [MSDAsteroidNode asteroidNode];
    asteroid.position = position;
    return asteroid;
}

+ (instancetype) asteroidNode {
    MSDAsteroidNode *asteroid = [self spriteNodeWithImageNamed:@"rock"];
    [asteroid setupRotation];
    [asteroid setupPhysics];
    return asteroid;
}

- (void) setupRotation {
    NSInteger duration = [MSDBlasterUtil randomWithMin:5 max:10];
    SKAction *rotation = [SKAction rotateByAngle:35.0f duration:duration];
    SKAction *animation = [SKAction repeatActionForever:rotation];
    [self runAction:animation];
}

- (void) setupPhysics {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
}

@end

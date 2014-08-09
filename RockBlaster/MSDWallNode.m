//
//  MSDWallNode.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/8/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDWallNode.h"
#import "MSDBlasterUtil.h"

@implementation MSDWallNode

+ (instancetype) wallWithSize:(CGSize)size {
    MSDWallNode *wall = [self node];
    [wall setPath:CGPathCreateWithRect(CGRectMake(0, 0, size.width, size.height), nil)];
    [wall setupPhysics];
    wall.strokeColor = wall.fillColor = [SKColor clearColor];
    return wall;
}

- (void) setupPhysics {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.categoryBitMask = MSDCollisionCategoryWall;
    self.physicsBody.dynamic = NO;
}
@end

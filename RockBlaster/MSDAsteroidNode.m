//
//  MSDAsteroidNode.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/8/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDAsteroidNode.h"

@implementation MSDAsteroidNode

+ (instancetype) asteroidAtPosition:(CGPoint)position {
    MSDAsteroidNode *asteroid = [self spriteNodeWithImageNamed:@"rock"];
    asteroid.position = position;
    return asteroid;
}

@end

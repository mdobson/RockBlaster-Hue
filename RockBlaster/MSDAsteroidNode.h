//
//  MSDAsteroidNode.h
//  RockBlaster
//
//  Created by Matthew Dobson on 8/8/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MSDAsteroidNode : SKSpriteNode

+ (instancetype) asteroidAtPosition:(CGPoint)position;
+ (instancetype) asteroidNode;
@end

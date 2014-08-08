//
//  MSDTransitionShip.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/7/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDPlayerShip.h"

@implementation MSDPlayerShip

+ (instancetype) shipWithPosition:(CGPoint)position {
    MSDPlayerShip *ship = [self spriteNodeWithImageNamed:@"ship-small_01"];
    
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"ship-small_01"],
                          [SKTexture textureWithImageNamed:@"ship-small_02"],
                          [SKTexture textureWithImageNamed:@"ship-small_03"],
                          [SKTexture textureWithImageNamed:@"ship-small_04"]];
    SKAction *animate = [SKAction animateWithTextures:textures timePerFrame:0.2];
    [ship runAction:[SKAction repeatActionForever:animate]];
    ship.position = position;
    return ship;
}

@end

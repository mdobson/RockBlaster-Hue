//
//  MSDTitleShipNode.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/6/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDTitleShipNode.h"

@interface MSDTitleShipNode ()

@property (nonatomic) NSMutableArray *textures;

@end

@implementation MSDTitleShipNode

+ (instancetype) largeShipWithPosition:(CGPoint)position {
    MSDTitleShipNode *ship = [self spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"ship-morph0001"]];
    ship.textures = [[NSMutableArray alloc] init];
    for (int i = 1; i < 41; i++) {
        [ship.textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"ship-morph%04d", i]]];
    }
    ship.position = position;
    return ship;
}

-(void) animateShip {
    SKAction *animation = [SKAction animateWithTextures:self.textures timePerFrame:0.05];
    [self runAction:animation];
}

@end

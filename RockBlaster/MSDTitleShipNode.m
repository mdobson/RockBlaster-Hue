//
//  MSDTitleShipNode.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/6/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDTitleShipNode.h"

@implementation MSDTitleShipNode

+ (instancetype) largeShipWithPosition:(CGPoint)position {
    MSDTitleShipNode *ship = [self spriteNodeWithImageNamed:@"ship-big"];
    ship.position = position;
    return ship;
}

@end

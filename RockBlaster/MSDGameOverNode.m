//
//  MSDGameOverNode.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/9/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDGameOverNode.h"

@implementation MSDGameOverNode

+(instancetype) gameOverNodeWithPosition:(CGPoint)position {
    MSDGameOverNode *gameOverNode = [self node];
    SKLabelNode *gameOverText = [SKLabelNode labelNodeWithFontNamed:@"Orbitron-Bold"];
    gameOverText.text = @"Game Over";
    gameOverText.fontSize = 32;
    gameOverText.position = position;
    [gameOverNode addChild:gameOverText];
    return gameOverNode;
}

@end

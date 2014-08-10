//
//  MSDEnemyNode.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/10/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDEnemyNode.h"

@implementation MSDEnemyNode

+ (instancetype) enemyWithPosition:(CGPoint) position {
    MSDEnemyNode *enemy = [self spriteNodeWithImageNamed:@"ship-small_01"];
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"ship-small_01"],
                          [SKTexture textureWithImageNamed:@"ship-small_02"],
                          [SKTexture textureWithImageNamed:@"ship-small_03"],
                          [SKTexture textureWithImageNamed:@"ship-small_04"]];
    SKAction *animate = [SKAction animateWithTextures:textures timePerFrame:0.2];
    NSString *afterburnerPath = [[NSBundle mainBundle] pathForResource:@"EnemyAfterburner" ofType:@"sks"];
    SKEmitterNode *afterburner = [NSKeyedUnarchiver unarchiveObjectWithFile:afterburnerPath];
    afterburner.position = CGPointMake(CGRectGetMidX(enemy.frame), CGRectGetMinY(enemy.frame) + 10);
    afterburner.zPosition = 15;
    [enemy addChild:afterburner];
    
    
    
    [enemy runAction:[SKAction repeatActionForever:animate]];
    SKAction *rotate = [SKAction rotateByAngle:M_PI duration:0];
    [enemy runAction:rotate];
    [afterburner runAction:rotate];
    
    SKAction *scaleDown = [SKAction scaleBy:0.80f duration:0];
    
    [enemy runAction:scaleDown];
    [afterburner runAction:scaleDown];
    enemy.position = position;

    return enemy;
}

@end

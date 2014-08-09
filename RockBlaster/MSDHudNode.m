//
//  MSDHudNode.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/9/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDHudNode.h"

@interface MSDHudNode()

@property (nonatomic,retain) MSDGameState *state;

@end

@implementation MSDHudNode

+ (instancetype) hudNodeWithPosition:(CGPoint)position inFrame:(CGRect) frame withGameState:(MSDGameState *)state {
    MSDHudNode *hud = [self node];
    hud.state = state;
    hud.position = position;
    hud.zPosition = 50;
    
    SKSpriteNode *lastLife;
    
    for (int i = 0; i < hud.state.lives; i++) {
        SKSpriteNode *life = [SKSpriteNode spriteNodeWithImageNamed:@"life"];
        life.name = [NSString stringWithFormat:@"Life%d", i];
        [hud addChild:life];
        if (lastLife == nil) {
            life.position = CGPointMake(30, -10);
        } else {
            life.position = CGPointMake(lastLife.position.x + 30, lastLife.position.y);
        }
        lastLife = life;
    }
    
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Orbitron-Regular"];
    scoreLabel.name = @"Score";
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 24;
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    scoreLabel.position = CGPointMake(frame.size.width - 20, -10);
    [hud addChild:scoreLabel];
    
    return hud;
}

- (void) scoreChanged:(NSInteger)score {
    SKLabelNode *scoreLabel = (SKLabelNode *)[self childNodeWithName:@"Score"];
    scoreLabel.text = [NSString stringWithFormat:@"%d", (int)score];
}

- (void) livesChanged:(NSInteger)lives {
    if (lives >= 0) {
        NSString *lifeNodeName = [NSString stringWithFormat:@"Life%d", (int)lives];
        NSLog(@"%@", lifeNodeName);
        SKNode *lifeToRemove = [self childNodeWithName:lifeNodeName];
        [lifeToRemove removeFromParent];
    }
}


@end

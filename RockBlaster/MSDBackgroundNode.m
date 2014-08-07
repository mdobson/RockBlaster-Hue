//
//  MSDBackgroundNode.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/6/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDBackgroundNode.h"

@interface MSDBackgroundNode()

@property (nonatomic) NSInteger backgroundCount;

@end

@implementation MSDBackgroundNode

+ (instancetype) createBackgroundNodeWithPosition:(CGPoint)position {
    
    MSDBackgroundNode *background = [self node];
    background.name = @"Background";
    
    for (int i = 0; i < 3; i++) {
        NSString *imageName = [NSString stringWithFormat:@"bg-stars_%02d", i];
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        bg.name = @"bg";
        bg.position = CGPointMake(position.x, i * bg.size.height);
        [background addChild:bg];
    }
    
    background.backgroundCount = background.children.count;
    return background;
}

- (void) scrollBackground {
    [self enumerateChildNodesWithName:@"bg" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *bg = (SKSpriteNode *)node;
        [bg runAction:[SKAction moveBy:CGVectorMake(0, -15) duration:0]];
        
        if (bg.position.y <= -bg.size.height) {
            bg.position = CGPointMake(bg.position.x, bg.position.y + bg.size.height * self.backgroundCount);
        }
    }];
}

@end

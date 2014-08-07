//
//  MSDBackgroundNode.h
//  RockBlaster
//
//  Created by Matthew Dobson on 8/6/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MSDBackgroundNode : SKSpriteNode

+ (instancetype) createBackgroundNodeWithPosition:(CGPoint)position;
- (void) scrollBackground;
@end

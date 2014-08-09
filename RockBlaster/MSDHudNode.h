//
//  MSDHudNode.h
//  RockBlaster
//
//  Created by Matthew Dobson on 8/9/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MSDGameState.h"
#import "MSDGameStateDelegate.h"

@interface MSDHudNode : SKNode<MSDGameStateDelegate>

+ (instancetype) hudNodeWithPosition:(CGPoint)position inFrame:(CGRect) frame withGameState:(MSDGameState *)state ;

@end

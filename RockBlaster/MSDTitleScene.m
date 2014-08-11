//
//  MSDMyScene.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/6/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDTitleScene.h"
#import "MSDBackgroundNode.h"
#import "MSDTitleShipNode.h"
#import "MSDGameplayScene.h"
#import "MSDAppDelegate.h"

@interface MSDTitleScene ()

@property (nonatomic, retain) MSDBackgroundNode *background;
@property (nonatomic, retain) MSDTitleShipNode *ship;
@property (nonatomic, retain) SKLabelNode *hueLinkNode;

@end

@implementation MSDTitleScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        MSDBackgroundNode *background = [MSDBackgroundNode createBackgroundNodeWithPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        self.background = background;
        [self addChild:self.background];
        
         self.ship = [MSDTitleShipNode largeShipWithPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 30)];
        [self addChild:self.ship];
        
        SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Orbitron-Regular"];
        title.color = [SKColor whiteColor];
        title.text = @"RockBlaster!";
        title.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+ 170 );
        [self addChild:title];
        
        SKLabelNode *instructions = [SKLabelNode labelNodeWithFontNamed:@"Orbitron-Regular"];
        instructions.color = [SKColor whiteColor];
        instructions.text = @"Tap to start";
        instructions.fontSize = title.fontSize / 2;
        instructions.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 130);
        
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.5];
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.5];
        SKAction *fadeSequence = [SKAction repeatActionForever:[SKAction sequence:@[fadeOut, fadeIn]]];
        [self addChild:instructions];
        [instructions runAction:fadeSequence];
        
        self.hueLinkNode = [SKLabelNode labelNodeWithFontNamed:@"Orbitron-Regular"];
        self.hueLinkNode.color = [SKColor whiteColor];
        self.hueLinkNode.text = @"Link with Hue!";
        self.hueLinkNode.name = @"LinkHue";
        self.hueLinkNode.fontSize = title.fontSize / 2;
        self.hueLinkNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + 40);
        [self addChild:self.hueLinkNode];
        [self.hueLinkNode runAction:fadeSequence];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    BOOL flag = NO;
    BOOL linking = NO;
    for (UITouch *touch in touches) {
        CGPoint locationInNode = [touch locationInNode:self];
        for (SKNode *node in [self nodesAtPoint:locationInNode]) {
            if ([node.name isEqualToString:@"LinkHue"]) {
                MSDAppDelegate *delegate = (MSDAppDelegate *) [[UIApplication sharedApplication] delegate];
                [delegate searchForBridgeLocal];
                linking = YES;
                break;
            }
        }
        if (!linking) {
            flag = YES;
        }

    }
    
    if (flag) {
        MSDGameplayScene *game = [MSDGameplayScene sceneWithSize:self.frame.size];
        SKTransition *transition = [SKTransition doorsOpenHorizontalWithDuration:0.5];
        [self.view presentScene:game transition:transition];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self.background scrollBackground];
}

-(void) didMoveToView:(SKView *)view {
    [self.ship animateShip];
}

@end

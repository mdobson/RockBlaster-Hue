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

@interface MSDTitleScene ()

@property (nonatomic, retain) MSDBackgroundNode *background;
@property (nonatomic, retain) MSDTitleShipNode *ship;

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
                                                                                                        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    MSDGameplayScene *game = [MSDGameplayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:game transition:transition];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self.background scrollBackground];
}

-(void) didMoveToView:(SKView *)view {
    [self.ship animateShip];
}

@end

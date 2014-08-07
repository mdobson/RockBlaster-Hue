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

@interface MSDTitleScene ()

@property (nonatomic, retain) MSDBackgroundNode *background;

@end

@implementation MSDTitleScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        MSDBackgroundNode *background = [MSDBackgroundNode createBackgroundNodeWithPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        self.background = background;
        [self addChild:self.background];
        
        MSDTitleShipNode *ship = [MSDTitleShipNode largeShipWithPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 30)];
        [self addChild:ship];
        
        SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Orbitron-Regular"];
        title.color = [SKColor whiteColor];
        title.text = @"RockBlaster!";
        title.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+ 130 );
        [self addChild:title];
                                                                                                        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self.background scrollBackground];
}

@end

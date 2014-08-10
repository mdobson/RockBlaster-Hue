//
//  MSDGameState.h
//  RockBlaster
//
//  Created by Matthew Dobson on 8/9/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSDGameStateDelegate.h"
#import "MSDGameOverDelegate.h"

@interface MSDGameState : NSObject

@property (nonatomic) NSInteger lives;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger scoreInterval;
@property (nonatomic, retain) id<MSDHudDelegate> hudDelegate;
@property (nonatomic, retain) id<MSDGameOverDelegate> gameOverDelegate;

+ (instancetype) gameStateWithLives:(NSInteger) lives andScoreIncrement:(NSInteger) scoreIncrement;

- (NSInteger) updateScore;
- (NSInteger) addLife;
- (NSInteger) removeLife;
- (BOOL) isGameover;
- (void) resetGameState;

@end

//
//  MSDGameState.h
//  RockBlaster
//
//  Created by Matthew Dobson on 8/9/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSDGameStateDelegate.h"

@interface MSDGameState : NSObject

@property (nonatomic) NSInteger lives;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger scoreInterval;
@property (nonatomic, retain) id<MSDGameStateDelegate> delegate;

+ (instancetype) gameStateWithLives:(NSInteger) lives andScoreIncrement:(NSInteger) scoreIncrement;

- (NSInteger) updateScore;
- (NSInteger) addLife;
- (NSInteger) removeLife;

@end

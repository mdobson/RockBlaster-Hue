//
//  MSDGameState.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/9/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDGameState.h"

@implementation MSDGameState

+ (instancetype) gameStateWithLives:(NSInteger)lives andScoreIncrement:(NSInteger)scoreIncrement {
    
    MSDGameState *state = [[MSDGameState alloc] init];
    state.scoreInterval = scoreIncrement;
    state.lives = lives;
    return state;
}

- (NSInteger) addLife {
    self.lives++;
    if (self.delegate && [self.delegate respondsToSelector:@selector(livesChanged:)]) {
        [self.delegate livesChanged:self.lives];
    }
    return self.lives;
}

- (NSInteger) removeLife {
    self.lives--;
    if (self.delegate && [self.delegate respondsToSelector:@selector(livesChanged:)]) {
        [self.delegate livesChanged:self.lives];
    }
    return self.lives;
}

- (NSInteger) updateScore {
    self.score += self.scoreInterval;
    if (self.delegate && [self.delegate respondsToSelector:@selector(scoreChanged:)]) {
        [self.delegate scoreChanged:self.score];
    }
    return self.score;
}
@end

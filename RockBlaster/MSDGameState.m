//
//  MSDGameState.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/9/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDGameState.h"

@interface MSDGameState()

@property (nonatomic) NSInteger startingLives;

@end

@implementation MSDGameState

+ (instancetype) gameStateWithLives:(NSInteger)lives andScoreIncrement:(NSInteger)scoreIncrement {
    
    MSDGameState *state = [[MSDGameState alloc] init];
    state.scoreInterval = scoreIncrement;
    state.lives = lives;
    state.startingLives = lives;
    return state;
}

- (NSInteger) addLife {
    self.lives++;
    if (self.hudDelegate && [self.hudDelegate respondsToSelector:@selector(livesChanged:)]) {
        [self.hudDelegate livesChanged:self.lives];
    }
    return self.lives;
}

- (NSInteger) removeLife {
    self.lives--;
    if (self.hudDelegate && [self.hudDelegate respondsToSelector:@selector(livesChanged:)]) {
        [self.hudDelegate livesChanged:self.lives];
    }
    
    if (self.lives == 0 && self.gameOverDelegate && [self.gameOverDelegate respondsToSelector:@selector(gameover)]) {
        [self.gameOverDelegate gameover];
    }
    return self.lives;
}

- (NSInteger) updateScore {
    self.score += self.scoreInterval;
    if (self.hudDelegate && [self.hudDelegate respondsToSelector:@selector(scoreChanged:)]) {
        [self.hudDelegate scoreChanged:self.score];
    }
    return self.score;
}

- (BOOL) isGameover {
    return self.lives <= 0;
}

- (void) resetGameState {
    self.lives = self.startingLives;
}
@end

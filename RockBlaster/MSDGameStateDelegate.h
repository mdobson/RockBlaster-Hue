//
//  MSDGameStateDelegate.h
//  RockBlaster
//
//  Created by Matthew Dobson on 8/9/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSDGameStateDelegate <NSObject>

- (void) livesChanged:(NSInteger)lives;

- (void) scoreChanged:(NSInteger)score;

@end

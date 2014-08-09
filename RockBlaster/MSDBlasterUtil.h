//
//  MSDBlasterUtil.h
//  RockBlaster
//
//  Created by Matthew Dobson on 8/8/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int MSDAsteroidMinSpeed = -150;
static const int MSDAsteroidMaxSpeed = -50;

typedef NS_OPTIONS(uint32_t, MSDCollisionCategory) {
    MSDCollisionCategoryEnemy      = 1 << 0,
    MSDCollisionCategoryProjectile = 1 << 1,
    MSDCollisionCategoryDebris     = 1 << 2,
    MSDCollisionCategoryPlayer     = 1 << 3,
    MSDCollisionCategoryWall       = 1 << 4
};

@interface MSDBlasterUtil : NSObject

+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max;

@end

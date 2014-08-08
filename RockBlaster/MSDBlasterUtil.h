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

@interface MSDBlasterUtil : NSObject

+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max;

@end

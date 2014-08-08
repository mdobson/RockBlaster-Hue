//
//  MSDBlasterUtil.m
//  RockBlaster
//
//  Created by Matthew Dobson on 8/8/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDBlasterUtil.h"

@implementation MSDBlasterUtil

+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max {
    return arc4random() % (max - min) + min;
}

@end

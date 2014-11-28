//
//  MLWorldGenerator.h
//  Hop Hero
//
//  Created by enterpi on 9/10/14.
//  Copyright (c) 2014 enterpi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MLWorldGenerator : SKNode

+(id)generatorWithWorld:(SKNode *)world;
-(void)populate;
-(void)generate;

@end

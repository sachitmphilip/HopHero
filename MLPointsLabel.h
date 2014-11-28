//
//  MLPointsLabel.h
//  Hop Hero
//
//  Created by enterpi on 9/10/14.
//  Copyright (c) 2014 enterpi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MLPointsLabel : SKLabelNode
@property int number;

+(id)pointsLabelWithFontNamed:(NSString *)fontName;
-(void)increment;
-(void)setPoints:(int)points;
-(void)reset;
@end

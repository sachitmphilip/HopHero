//
//  MLHero.m
//  Hop Hero
//
//  Created by enterpi on 9/10/14.
//  Copyright (c) 2014 enterpi. All rights reserved.
//

#import "MLHero.h"

@interface MLHero()
@property BOOL isJumping;
@end

@implementation MLHero

static const uint32_t heroCategory = 0x1 << 0;
static const uint32_t obstacleCategory = 0x1 <<1;
static const uint32_t groundCategory = 0x1 <<2;

+(id)hero
{
    MLHero *hero = [MLHero spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(40, 40)];
    SKSpriteNode *leftEye = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(5, 5)];
    [hero addChild:leftEye];
    leftEye.position = CGPointMake(-3, 8);
    
    
    SKSpriteNode *rightEye = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(5, 5)];
    rightEye.position = CGPointMake(13, 8);
    [hero addChild:rightEye];
    
    hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hero.size];
    hero.physicsBody.categoryBitMask =  heroCategory;
    hero.physicsBody.contactTestBitMask = obstacleCategory | groundCategory;
    hero.name = @"hero";
    return hero;
}




-(void)jump
{
    
    if (!self.isJumping)
    {
         [self.physicsBody applyImpulse:CGVectorMake(0, 40)];
        [self runAction:[SKAction playSoundFileNamed:@"onJump.wav" waitForCompletion:NO]];
        self.isJumping = YES;
    }
    
    
   
    
}
-(void)land
{
    self.isJumping = NO;
}

-(void)start
{
    SKAction *incrementRight = [SKAction moveByX:1 y:0 duration:0.003];
    SKAction *moveRight  = [SKAction repeatActionForever:incrementRight];
    [self runAction:moveRight];
    NSLog(@"%@",incrementRight);
   
    
}

-(void)stop
{
    [self removeAllActions];
}





































@end

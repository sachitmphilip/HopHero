//
//  MyScene.m
//  Hop Hero
//
//  Created by enterpi on 9/10/14.
//  Copyright (c) 2014 enterpi. All rights reserved.
//

#import "MyScene.h"
#import "MLHero.h"
#import "MLWorldGenerator.h"
#import "MLPointsLabel.h"
#import "GameData.h"


@interface MyScene ()
@property BOOL isStarted;
@property BOOL isGameOver;


@end

@implementation MyScene

{
    MLHero *hero;
    SKNode *world;
    MLWorldGenerator *generator;
}

static NSString *GAME_FONT = @"AmericanTypeWriter-Bold";

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.physicsWorld.contactDelegate = self;
        [self createContent];
        
    }
        return self;
      
        
     
    }
-(void)createContent
{
    self.backgroundColor = [SKColor colorWithRed:0.54 green:0.7853 blue:1.0 alpha:1.0];
    
    world = [SKNode node];
    [self addChild:world];
    
    
    generator = [MLWorldGenerator generatorWithWorld:world];
    [self addChild:generator];
    [generator populate];
    
    hero = [MLHero hero];
    [world addChild:hero];
    
    
    
    SKLabelNode *tapToBeginlabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToBeginlabel.text =@"Tap to begin";
    tapToBeginlabel.name = @"tapToBeginLabel";
    tapToBeginlabel.fontSize = 20;
    
    [self addChild:tapToBeginlabel];
    [self animateWithPulse:tapToBeginlabel];
    [self loadClouds];
    [self loadScoreLabels];
    
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:0.6];
    SKAction *appear = [SKAction fadeAlphaTo:1.0 duration:0.3];
    SKAction *pulse = [SKAction sequence:@[disappear,appear]];
    [tapToBeginlabel runAction:[SKAction repeatActionForever:pulse]];
    
    
    
    

    

    
}
-(void)loadScoreLabels
{
    
    MLPointsLabel *pointsLabel = [MLPointsLabel pointsLabelWithFontNamed:GAME_FONT];
    pointsLabel.position = CGPointMake(-200, 100);
    pointsLabel.name = @"pointsLabel";
    [self addChild:pointsLabel];
    
    
    GameData *data = [GameData data];
    [data load];
    

    
    
    
    MLPointsLabel *highScoreLabel = [MLPointsLabel pointsLabelWithFontNamed:GAME_FONT];
    highScoreLabel.name = @"highScoreLabel";
    highScoreLabel.position = CGPointMake(200, 100);
    [highScoreLabel setPoints:data.highscore];
    [self addChild:highScoreLabel];
    
    SKLabelNode *bestlabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    bestlabel.fontSize = 16.0;
    bestlabel.position = CGPointMake(-30, 0);
    bestlabel.text = @"Best:";
    [highScoreLabel addChild:bestlabel];
    
    
}
-(void)loadClouds
{
    SKShapeNode *cloud1 = [SKShapeNode node];
    cloud1.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 65, 100, 40)].CGPath;
    cloud1.fillColor  = [UIColor whiteColor];
    cloud1.strokeColor = [UIColor blackColor];
    [world addChild:cloud1];
    
    
    SKShapeNode *cloud2 = [SKShapeNode node];
    cloud2.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-250, 45, 100, 40)].CGPath;
    cloud2.fillColor  = [UIColor whiteColor];
    cloud2.strokeColor = [UIColor blackColor];
    [world addChild:cloud2];

}
-(void)start
{
    self.isStarted = YES;
    [hero start];
    [[self childNodeWithName:@"tapToBeginLabel"]removeFromParent];

}
-(void)clear
{
   
    MyScene *scene = [[MyScene alloc]initWithSize:self.frame.size];
    [self.view presentScene:scene];
    
}
-(void)gameOver

{
    self.isGameOver = YES;
    [hero stop];
    [self runAction:[SKAction playSoundFileNamed:@"onGameOver.mp3" waitForCompletion:NO]];
  
    SKLabelNode *gameverLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    gameverLabel.text = @"Game Over";
    gameverLabel.position = CGPointMake(0, 60);

    [self addChild:gameverLabel];
    
    
    
    SKLabelNode *tapToResetlabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToResetlabel.text =@"Tap to reset";
    tapToResetlabel.name = @"tapToResetLabel";
   tapToResetlabel.fontSize = 20.0;
    
    [self addChild:tapToResetlabel];
    [self animateWithPulse:tapToResetlabel];
    [self updateHighScore];

    
}
-(void)updateHighScore
{
    MLPointsLabel *pointsLabel = (MLPointsLabel *)[self childNodeWithName:@"pointsLabel"];
    MLPointsLabel *highScoreLabel = (MLPointsLabel *)[self childNodeWithName:@"highScoreLabel"];
    
    if (pointsLabel.number > highScoreLabel.number)
    {
        [highScoreLabel setPoints:pointsLabel.number];
        GameData *data = [GameData data];
        data.highscore = pointsLabel.number;
        [data save];
    }
    
}
-(void)didSimulatePhysics
{
    [self centerOnNode:hero];
     [self handlePoints];
    [self handleGeneration];
    [self handleCleanUp];
   
    
}
-(void)handlePoints
{
    [world enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < hero.position.x)
        {
            MLPointsLabel *pointsLabel = (MLPointsLabel *)[self childNodeWithName:@"pointsLabel"];
            [pointsLabel increment];
        }
    }];
    
}

-(void)handleGeneration
{
    [world enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *node, BOOL *stop)
    {
        if (node.position.x < hero.position.x)
        {
            node.name = @"obstacle_cancelled";
            [generator generate];
        }
    }];
    
}
-(void)handleCleanUp
{
    [world enumerateChildNodesWithName:@"ground" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < hero.position.x - self.frame.size.width/2 - node.frame.size.width/2)
        {
            [node removeFromParent];
        }
    }];
    [world enumerateChildNodesWithName:@"obstacle_cancelled" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x< hero.position.x - self.frame.size.width/2 - node.frame.size.width/2)
        {
            [node removeFromParent];
        }
    }];
    
}

-(void)centerOnNode:(SKNode *)node
{
    CGPoint positionInScene = [self convertPoint:node.position fromNode:node.parent];
    world.position = CGPointMake(world.position.x - positionInScene.x, world.position.y);
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isStarted)
    {
        [self start];
    }
    else if (self.isGameOver)
    {
        
        [self clear];
        
    }
    else
    {
        [hero jump];
    }
    
   
   

   
}

-(void)didBeginContact:(SKPhysicsContact *)contact

{
    if ([contact.bodyA.node.name isEqualToString:@"ground"]||[contact.bodyB.node.name isEqualToString:@"ground"] )
        
    {
        [hero land];
    }
    else
    {
          [self gameOver];
    }
    
    
    
    
  
}


//**Animation Section
-(void)animateWithPulse:(SKNode *)node
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:0.6];
    SKAction *appear = [SKAction fadeAlphaTo:1.0 duration:0.3];
    SKAction *pulse = [SKAction sequence:@[disappear,appear]];
    [node runAction:[SKAction repeatActionForever:pulse]];
    
    

}




























-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}





















@end

//
//  GameData.h
//  Hop Hero
//
//  Created by enterpi on 9/10/14.
//  Copyright (c) 2014 enterpi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject
@property int highscore;


+(id)data;
-(void)save;
-(void)load;

@end

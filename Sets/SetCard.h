//
//  SetCard.h
//  Matchismo
//
//  Created by Mukhtar Yusuf on 2/8/15.
//  Copyright (c) 2015 Mukhtar Yusuf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface SetCard : Card <NSCopying, NSCoding>
@property(nonatomic, strong) NSString *shape;
@property(nonatomic, strong) NSString *color;
@property(nonatomic, strong) NSString *shading;
@property(nonatomic) int number;

+(NSArray *)validShapes;
+(NSArray *)validColors;
+(NSArray *)validShadings;
+(BOOL)checkNumbersFor:(SetCard *)firstCard with: (NSArray *)otherCards;
+(BOOL)checkShadingsFor:(SetCard *)firstCard with: (NSArray *)otherCards;
+(BOOL)checkColorsFor:(SetCard *)firstCard with: (NSArray *)otherCards;
+(BOOL)checkShapesFor:(SetCard*)firstCard with:(NSArray *)otherCards;

@end


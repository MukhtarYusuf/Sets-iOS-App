//
//  PlayingCard.h
//  Matchismo
//
//  Created by Mukhtar Yusuf on 7/8/14.
//  Copyright (c) 2014 Mukhtar Yusuf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card <NSCopying, NSCoding>

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end

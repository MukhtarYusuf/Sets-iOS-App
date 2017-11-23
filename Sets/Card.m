//
//  Card.m
//  Matchismo
//
//  Created by Mukhtar Yusuf on 7/8/14.
//  Copyright (c) 2014 Mukhtar Yusuf. All rights reserved.
///Users/mukhtaryusuf/Documents/iOS Projects/Stanford/Images

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards{
    int score = 0;
    
    for(Card *card in otherCards){
        if([card.contents isEqualToString:self.contents]){
            score = 1;
        }
    }
    
    return score;
}

@end

//
//  Deck.h
//  Matchismo
//
//  Created by Mukhtar Yusuf on 7/8/14.
//  Copyright (c) 2014 Mukhtar Yusuf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject <NSCopying>
@property (strong, nonatomic) NSMutableArray *cards; //of Card, Protected for subclasses

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;
- (Card *)cardAtIndex:(NSUInteger)index;
- (Card *)drawCardAtIndex:(NSUInteger)index;
-(NSUInteger)cardCount;

@end

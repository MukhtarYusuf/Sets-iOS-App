//
//  Deck.m
//  Matchismo
//
//  Created by Mukhtar Yusuf on 7/8/14.
//  Copyright (c) 2014 Mukhtar Yusuf. All rights reserved.
//

#import "Deck.h"

@interface Deck()

@end

@implementation Deck

- (NSMutableArray *)cards{
    if(!_cards){
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop{
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    }
    else{
        [self.cards addObject:card];
    }
}

- (void)addCard:(Card *)card{
    [self addCard:card atTop:NO];
}

- (Card *)drawRandomCard{
    Card *randomCard = nil;
    
    if([self.cards count]){ //Protect against accessing empty array
        unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    return randomCard;
}

- (Card *)drawCardAtIndex:(NSUInteger)index{
    Card *drawnCard = nil;
    if([self cardCount]){
        drawnCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    return drawnCard;
}

- (Card *)cardAtIndex:(NSUInteger)index{
    Card *peekedCard;
    if([self cardCount]){
        peekedCard = self.cards[index];
    }
    return peekedCard;
}

-(NSUInteger)cardCount{
    return [self.cards count];
}

-(id)copyWithZone:(NSZone *)zone{
    Deck *deckCopy = [[Deck alloc] init];
    
    deckCopy.cards = [[NSMutableArray alloc] initWithArray:self.cards
                                                   copyItems:YES];
    
    return deckCopy;
}
@end

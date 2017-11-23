//
//  SetCardDeck.h
//  Matchismo
//
//  Created by Mukhtar Yusuf on 2/8/15.
//  Copyright (c) 2015 Mukhtar Yusuf. All rights reserved.
//

#import "Deck.h"

@interface SetCardDeck : Deck
- (NSInteger)getIndexForNextPSetCardUsingArray:(NSMutableArray *)pSetCards withStartIndex:(NSUInteger)startIndex;

+ (void)displaySetCardsInArray:(NSArray *)setCards;
@end

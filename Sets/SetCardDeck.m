//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Mukhtar Yusuf on 2/8/15.
//  Copyright (c) 2015 Mukhtar Yusuf. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

-(instancetype)init{
    self = [super init];
    
    if(self){
        for(int i = 1; i <= 3; i++){
            for(NSString *shape in [SetCard validShapes]){
                for(NSString *shading in [SetCard validShadings]){
                    for(NSString *color in [SetCard validColors]){
                        SetCard *card = [[SetCard alloc] init];
                        card.number = i;
                        card.shape = shape;
                        card.shading = shading;
                        card.color = color;
                        [self addCard:card];
                    }
                    
                }
            }
        }
    }
    return self;
}

- (NSInteger)getIndexForNextPSetCardUsingArray:(NSMutableArray *)pSetCards withStartIndex:(NSUInteger)startIndex{
    NSInteger index = 0;
    
    for(index = startIndex; index < [self cardCount]; index++){
//        [SetCardDeck displaySetCardsInArray:pSetCards];
//        NSLog(@"Checking card: %@", ((SetCard *)self.cards[index]).contents);
        if([SetCard checkNumbersFor:self.cards[index] with:pSetCards] && [SetCard checkColorsFor:self.cards[index] with:pSetCards] && [SetCard checkShapesFor:self.cards[index] with:pSetCards] && [SetCard checkShadingsFor:self.cards[index] with:pSetCards]){
            NSLog(@"Should return index");
            return index;
        }
    }
    return -1;
}

-(id)copyWithZone:(NSZone *)zone{
    SetCardDeck *deckCopy = [[SetCardDeck alloc] init];
    
    deckCopy.cards = [[NSMutableArray alloc] initWithArray:self.cards
                                                 copyItems:YES];
    
    return deckCopy;
}

+ (void)displaySetCardsInArray:(NSArray *)setCards{
    for(SetCard *setCard in setCards){
        NSLog(@"Set card in pset array: %@", setCard.contents);
    }
}

@end

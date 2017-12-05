//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Mukhtar Yusuf on 7/30/14.
//  Copyright (c) 2014 Mukhtar Yusuf. All rights reserved.
//

#import "CardMatchingGame.h"
#import "SetCard.h"
#import "SetCardDeck.h"
#import "PlayingCardDeck.h"

@interface CardMatchingGame()
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) Deck *permanentDeck;

@end

@implementation CardMatchingGame

/*
 
 - If time is above certain amount, consider reducing the MATCH_TIME_BONUS
 - The game gets too easy when a lot of time has been accumulated, and there's no more tension
 
*/

static int MISMATCH_PENALTY = 1; //Was 2
static const int MATCH_BONUS = 10; //Was 4
static int COST_TO_CHOOSE = 0;
static const int MISMATCH_PEN_RATIO_DENOMINATOR = 100;
static const int CTC_RATIO_DENOMINATOR = 100;

static const int START_TOTAL_TIME = 60;
static const int SUB_TIME = 60;
static int MATCH_TIME_BONUS = 15;

NSMutableArray *chosenCards;

- (NSMutableArray *)cards{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

//Designated Initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck{
    self = [super init];
    BOOL isGameValid = NO;
    if(self){
        self.permanentDeck = deck;
        self.cardCount = count;
        isGameValid = [self populateGameWithCount:count];
        self.totalTime = START_TOTAL_TIME;
        self.subTime = SUB_TIME;
    }
    if(isGameValid)
        return self;
    else
        return nil;
}

//Return card at index
- (Card *)cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(Card *)drawOneCardIntoGame{
    Card *card = [self.deck drawRandomCard];
    if(card)
        [self.cards addObject:card];
    return card;
}

-(NSMutableArray *)drawThreeCardsIntoGame{
    NSMutableArray *drawnCards; //Of Card
    if([self.deck cardCount] >= 3){
        for(int i = 1; i <= 3; i++){
            Card *drawnCard = [self drawOneCardIntoGame];
            if(drawnCard)
                [drawnCards addObject:drawnCard];
        }
    }
    return drawnCards;
}

//Select card at index and perform operations
- (void)chooseCardAtIndex:(NSUInteger)index{
    self.isGameActive = YES;
    if(!self.timer){
        self.timer = [NSTimer timerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(updateTime)
                                           userInfo:nil
                                            repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.startGameDate = [NSDate date];
    }
    
    if(!chosenCards){
        chosenCards = [[NSMutableArray alloc] init];
    }
    
    Card *card = [self cardAtIndex:index];
    if([card isKindOfClass:[SetCard class]]){
        self.threeCardGame = YES;
    }
    
    int matchScore = 0;
    NSUInteger chosenCardCount = 0;
    
    if(!card.isMatched){
        if(card.isChosen){
            card.chosen = NO;
        }
        else{ // Put Cards that are chosen but not matched in an array
            for(Card *otherCard in self.cards){
                if(otherCard.isChosen && !otherCard.isMatched && ![chosenCards containsObject:otherCard]){
                    [chosenCards addObject:otherCard];
                }
            }
            
            matchScore = [card match:chosenCards];
            chosenCardCount = [chosenCards count];
    
            
            if(!self.threeCardGame && [chosenCards count] == 1){//Matching for a two card game
                if(matchScore){
                    [self updateGameForMatch:card forScore:matchScore];
                }
                else{
                    [self updateGameForMismatch:card];
                }
            }
            else if([chosenCards count] == 2 && self.threeCardGame){//Matching for a three card game
                if(matchScore){
                    [self updateGameForMatch:card forScore:matchScore];
                }
                else{
                    [self updateGameForMismatch:card];
                }
            }
//            if(card == nil)
//                NSLog(@"In card not matched else for update");
            if(self.score >= 200)
                COST_TO_CHOOSE = floor(self.score/CTC_RATIO_DENOMINATOR);
            else
                COST_TO_CHOOSE = 1;
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

//--Helper Methods--
#pragma mark Helper Methods

//Update score for match
-(void)updateGameForMatch:(Card *)chosenCard forScore:(int)score{
//    if(self.totalTime >= 25)
//        MATCH_TIME_BONUS = 2;
//    else
//        MATCH_TIME_BONUS = 5;
    self.score += score * MATCH_BONUS;
    self.totalTime += MATCH_TIME_BONUS;
    chosenCard.matched = YES;
    
    for(Card *otherCard in chosenCards){
        otherCard.matched = YES;
    }

    [chosenCards removeAllObjects];
}

//Update score for mismatch
-(void)updateGameForMismatch:(Card *)chosenCard{
    if(self.score >= 100){
        MISMATCH_PENALTY = ceil(self.score/MISMATCH_PEN_RATIO_DENOMINATOR);
        NSLog(@"Mismatch Penalty: %i", MISMATCH_PENALTY);
    }else{
        MISMATCH_PENALTY = 1;
    }
    self.score -= MISMATCH_PENALTY;
    
    for(Card *otherCard in chosenCards){
        otherCard.chosen = NO;
    }
    [chosenCards removeAllObjects];
}

//Update Time
-(void)updateTime{
//    NSLog(@"In Update Time");
    
    if(self.totalTime > 0){//Game Hasn't Ended
        self.totalPlayTime++;
        self.totalTime--;
        if(self.subTime > 1)
            self.subTime--;
        else{
            if(self.totalTime > SUB_TIME)
                self.subTime = SUB_TIME;
            else
                self.subTime = self.totalTime;
            [self populateGameWithCount:self.cardCount];
            [[NSNotificationCenter defaultCenter] postNotificationName:RESET_CARDS_NOTIFICATION object:nil];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_TIME_NOTIFICATION object:nil];
    }
    if(self.totalTime == 0){//Game Has Ended
        
        //Update Flags Here or Something
        [self.timer invalidate];
        self.isGameActive = NO;
        self.hasGameEnded = YES;
        self.endGameDate = [NSDate dateWithTimeInterval:self.totalPlayTime sinceDate:self.startGameDate];
        [[NSNotificationCenter defaultCenter] postNotificationName:GAME_ENDED_NOTIFICATION object:nil];
    }
}

-(BOOL)populateGameWithCount:(NSUInteger)count{
    id someId = [self.permanentDeck copy];
    if([someId isKindOfClass:[Deck class]])
        self.deck = (Deck *)someId;
    
    if([self.cards count] != 0){
        [self.cards removeAllObjects];
    }
    
    if([self.deck isKindOfClass:[PlayingCardDeck class]]){
        for(int i = 0; i < count; i++){
            Card *randomCard = [self.deck drawRandomCard];
            if(randomCard){
                [self.cards insertObject:randomCard atIndex:[self.cards count]];
            }
            else{
                return false;
            }
        }
        return true;
    }else if([self.permanentDeck isKindOfClass:[SetCardDeck class]]){
        NSLog(@"Deck is Set Card Deck");
        for(int i = 0; i < count - 2; i++){
            Card *randomCard = [self.deck drawRandomCard];
            if(randomCard){
                [self.cards insertObject:randomCard atIndex:[self.cards count]];
            }else{
                return false;
            }
        }
        NSArray *fSet = [self drawSetFromDeck];
        if(fSet){
            [self.cards addObjectsFromArray:fSet];
            NSArray *cardsCopy = [self.cards copy];
            self.cards = [[self.cards shuffledArray] mutableCopy];
            return true;
        }else{
            return false;
        }
    }
    return false;
}

- (NSArray *)drawSetFromDeck{
    SetCardDeck *sCDeck = nil;
    
    if([self.deck isKindOfClass:[SetCardDeck class]])
        sCDeck = (SetCardDeck *)self.deck;
    
    for(Card *card in self.cards){
        if(card.matched == NO){
            NSMutableArray *formedSet = [[NSMutableArray alloc] initWithCapacity:3];
            [formedSet addObject:card];
            long startIndex1 = 0;
            for(long i = startIndex1; i < [sCDeck cardCount]; i++){
                long pSCardIndex1 = [sCDeck getIndexForNextPSetCardUsingArray:formedSet withStartIndex:i];
                if(pSCardIndex1 != -1){
                    [formedSet addObject:[sCDeck cardAtIndex:pSCardIndex1]];
                    i = pSCardIndex1;
                    
                    long startIndex2 = 0;
                    for(long j = startIndex2; j < [sCDeck cardCount]; j++){
                        long pSCardIndex2 = [sCDeck getIndexForNextPSetCardUsingArray:formedSet withStartIndex:j];
                        if(pSCardIndex2 != -1){
                            [sCDeck drawCardAtIndex:pSCardIndex1];
                            if(pSCardIndex2 > pSCardIndex1)
                                pSCardIndex2--;
                            [formedSet addObject:[sCDeck drawCardAtIndex:pSCardIndex2]];
                            NSLog(@"Formed Set Below:");
                            [SetCardDeck displaySetCardsInArray:formedSet];
                            [formedSet removeObject:card];
                            return formedSet;
                        }
                    }
                }
            }
        }
    }
    return nil;
}

@end

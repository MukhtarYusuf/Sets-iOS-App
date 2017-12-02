//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Mukhtar Yusuf on 7/30/14.
//  Copyright (c) 2014 Mukhtar Yusuf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameplayKit/GameplayKit.h>
#import "Deck.h"
#import "Card.h"
#import "NotificationNames.h"

@interface CardMatchingGame : NSObject

//designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck*)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
-(Card *)drawOneCardIntoGame;
-(NSMutableArray *)drawThreeCardsIntoGame;
-(void)updateTime;
- (void)reset;

@property (nonatomic) BOOL isGamePaused;
@property (nonatomic) BOOL isGameActive;
@property (nonatomic) BOOL hasGameEnded;
@property (nonatomic) BOOL threeCardGame;
@property (nonatomic) NSUInteger cardCount;
@property (nonatomic) NSUInteger totalTime;
@property (nonatomic) NSUInteger subTime;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSUInteger totalPlayTime;

@property (strong, nonatomic) NSMutableArray *cards;//of Card
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *startGameDate; //Time when the game started
@property (strong, nonatomic) NSDate *endGameDate; //Time when the game ended

@end


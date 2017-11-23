//
//  PlayingCardGameViewController.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/28/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "HighScoresCDTVC.h"

@interface  PlayingCardGameViewController()

@end

@implementation PlayingCardGameViewController

//--Handle Segues--
#pragma mark - Handle Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //Always pause game while segueing
    if(!self.game.isGamePaused)
        [self pauseGame];
    
    if([segue.identifier isEqualToString:@"Show HighScores"]){
        HighScoresCDTVC *highScoresCDTVC = (HighScoresCDTVC *)segue.destinationViewController;
        [highScoresCDTVC.navigationController setNavigationBarHidden:NO];
        highScoresCDTVC.context = self.document.managedObjectContext;
    }
}

static int NUMBER_OF_COLUMNS = 5;
static int NUMBER_OF_ROWS = 4;

-(void)initializeAndAddCardViews{
    [self.cardViews removeAllObjects];
    [self.cardViewFrames removeAllObjects];
    for(int i = 0; i < self.myGridForCards.numOfRows; i++){
        for(int j = 0; j < self.myGridForCards.numOfColumns; j++){
//            CGFloat initialXValue = arc4random_uniform(self.cardContainerView.bounds.size.width);
            CGRect finalFrame = [self.myGridForCards frameForCellInRow:i andColumn:j];
            CGRect initialFrame;
//            initialFrame.origin = CGPointMake(initialXValue, 0.0);
            initialFrame.origin = CGPointMake(0.0, 0.0);
            initialFrame.size = CGSizeMake(0.0, 0.0);
            PlayingCardView *pcv = [[PlayingCardView alloc] initWithFrame:initialFrame];
            pcv.cardBackImageName = [self.settings objectForKey:CARDBACK_IMAGE];
            [self.cardContainerView addSubview:pcv];
            [self.cardViews addObject:pcv];
            [UIView animateWithDuration:0.4
                             animations:^{
                                 pcv.frame = finalFrame;
                                 [self.cardViewFrames addObject:[NSValue valueWithCGRect:pcv.frame]];
                             }];
        }
    }
}

//-(void)animateCardsToOriginalLocations{
//    int cardIndex = 0;
//    for(int i = 0; i < self.myGridForCards.numOfRows; i++){
//        for(int j = 0; j < self.myGridForCards.numOfColumns; j++){
//            UIView *cardView = self.cardViews[cardIndex];
//            [UIView animateWithDuration:0.3
//                             animations:^{
//                                 cardView.frame = [self.myGridForCards frameForCellInRow:i andColumn:j];
//                             }];
//            cardIndex++; //Check
//        }
//        cardIndex++; //Check
//    }
//}

- (void)setCardBackImages{
    for(PlayingCardView *pcv in self.cardViews){
        pcv.cardBackImageName = [self.settings objectForKey:CARDBACK_IMAGE];
    }
}

-(Deck *)createDeck{
    return [[PlayingCardDeck alloc] init];
}

-(void)setUpMyGrid{
    self.myGridForCards.size = self.cardContainerView.bounds.size;
    self.myGridForCards.numOfColumns = NUMBER_OF_COLUMNS;
    self.myGridForCards.numOfRows = NUMBER_OF_ROWS;
}

//Overriden in order to use local variables
-(int)deductFromHeightFactor{
    return NUMBER_OF_COLUMNS - (NUMBER_OF_ROWS + 1);
}
//Overriden in order to use local variables
-(CGFloat)deductFromHeightCoeff{
    return self.cardContainerView.bounds.size.height/7;
}

- (BOOL)shouldAutorotate{
    return [super shouldAutorotate];
}

@end

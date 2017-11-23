//
//  SetCardGameViewController.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/28/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "HighScoresCDTVC.h"

@interface SetCardGameViewController()

@end

@implementation SetCardGameViewController

#pragma mark Handle Segues
//--Handle Segues--
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //Always pause game while segueing
    if(!self.game.isGamePaused)
        [self pauseGame];
    
    if([segue.identifier isEqualToString:@"Show HighScores"]){
        HighScoresCDTVC *highScoresCDTVC = (HighScoresCDTVC *)segue.destinationViewController;
        [highScoresCDTVC.navigationController setNavigationBarHidden:NO];
        highScoresCDTVC.context = self.document.managedObjectContext;
    }
}

-(void)initializeAndAddCardViews{
    [self.cardViews removeAllObjects];
    [self.cardViewFrames removeAllObjects];
    for(int i = 0; i < self.myGridForCards.numOfRows; i++){
        for(int j = 0; j < self.myGridForCards.numOfColumns; j++){
            CGFloat initialXValue = arc4random_uniform(self.cardContainerView.bounds.size.width);
            CGRect finalFrame = [self.myGridForCards frameForCellInRow:i andColumn:j];
            CGRect initialFrame;
            initialFrame.origin = CGPointMake(initialXValue, 0.0);
            initialFrame.size = CGSizeMake(0.0, 0.0);
            SetCardView *scv = [[SetCardView alloc] initWithFrame:initialFrame];
            [self.cardContainerView addSubview:scv];
            [self.cardViews addObject:scv];
            [UIView animateWithDuration:0.3
                             animations:^{
                                 scv.frame = finalFrame;
                                 [self.cardViewFrames addObject:[NSValue valueWithCGRect:scv.frame]];
                             }];
        }
    }
}

-(Deck *)createDeck{
    return [[SetCardDeck alloc] init];
}

@end

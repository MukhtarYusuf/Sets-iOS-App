//
//  ViewController.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/9/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardView.h"
#import "SetCardView.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;

@property (strong, nonatomic) PlayingCardDeck *playingCardDeck;
@property (strong, nonatomic) SetCardDeck *setCardDeck;

@end

@implementation ViewController

- (PlayingCardDeck *)playingCardDeck{
    if(!_playingCardDeck)
        _playingCardDeck = [[PlayingCardDeck alloc] init];
    return _playingCardDeck;
}

- (SetCardDeck *)setCardDeck{
    if(!_setCardDeck)
        _setCardDeck = [[SetCardDeck alloc] init];
    return _setCardDeck;
}

- (void) drawRandomPlayingCard{
    Card *card = [self.playingCardDeck drawRandomCard];
    if([card isKindOfClass:[PlayingCard class]]){
        PlayingCard *playingCard = (PlayingCard *)card;
        self.playingCardView.rank = playingCard.rank;
        self.playingCardView.suit = playingCard.suit;
    }
}

- (void)drawRandomSetCard{
    Card *card = [self.setCardDeck drawRandomCard];
    if([card isKindOfClass:[SetCard class]]){
        SetCard *setCard = (SetCard *)card;
        self.setCardView.number = setCard.number;
        self.setCardView.shape = setCard.shape;
        self.setCardView.color = setCard.color;
        self.setCardView.shading = setCard.shading;
    }
}

- (void)touchPlayingCard:(UITapGestureRecognizer *)sender{
    if(!self.playingCardView.faceUP)
        [self drawRandomPlayingCard];
    
    [UIView transitionWithView:self.playingCardView
                      duration:0.6
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        self.playingCardView.faceUP = !self.playingCardView.faceUP;
                    }
                    completion:nil];
    //self.playingCardView.faceUP = !self.playingCardView.faceUP;
}

- (void)touchSetCard:(UITapGestureRecognizer *)sender{
    [UIView transitionWithView:self.setCardView
                      duration:0.6
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [self drawRandomSetCard];
                        self.setCardView.faceUp = !self.setCardView.faceUp;
                    }
                    completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.playingCardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchPlayingCard:)]];
    
    [self.setCardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSetCard:)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

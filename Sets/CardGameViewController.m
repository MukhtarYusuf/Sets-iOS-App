//
//  CardGameViewController.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/28/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "CardGameViewController.h"

@interface  CardGameViewController()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UILabel *resultsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pausedLabel;
@property (weak, nonatomic) IBOutlet UILabel *topScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsTotalTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveScoreButton;

@property (weak, nonatomic) IBOutlet UIView *resultsContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *menu;


@property (nonatomic) NSInteger newHSRank;
@property (nonatomic) NSInteger newHSValue;
@property (strong, nonatomic) NSString *nHSName;
@property (strong, nonatomic) NSArray *highScoresLessThanNewScore;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachTopBehavior;
@property (nonatomic) BOOL areCardsInPile;

@end

@implementation CardGameViewController

CGFloat originalAnchorLength;
CGRect originalCardContainerBounds;

static const int INITIAL_NUMBER_OF_CARDS = 12;
static const double CARD_ASPECT_RATIO = 0.5;

static int NUMBER_OF_COLUMNS = 4;
static int NUMBER_OF_ROWS = 3;

BOOL vCAlreadyAppearedOnce;

- (IBAction)pause:(id)sender {
    if(self.game.isGamePaused)
        [self resumeGame];
    else
        [self pauseGame];
}
- (IBAction)reset:(id)sender {
    [self.game reset];
}

- (IBAction)dealAgain:(UIButton *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Deal Again?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *dealAction = [UIAlertAction actionWithTitle:@"Deal Again"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self dealAgainConfirm];
                                                       }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             //Do Nothing
                                                         }];
    [alert addAction:dealAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

- (IBAction)drawThreeCards:(id)sender{
    [self drawThree];
}

- (IBAction)saveScore:(id)sender {
    UIAlertController *saveAlert = [UIAlertController alertControllerWithTitle:@"Save Score" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           //Call Save Function
                                                           UITextField *saveTextField = [saveAlert.textFields firstObject];
                                                           self.nHSName = saveTextField.text;
                                                           
                                                           if(self.highScoresLessThanNewScore){//Not nil and no errors
                                                    
                                                                [HighScore insertHighScoreWithRank:(int)self.newHSRank
                                                                                             name:self.nHSName
                                                                                            value:self.newHSValue
                                                                                         totalTime:self.game.totalPlayTime
                                                                                              date:[NSDate date]
                                                                                         andContext:self.document.managedObjectContext];
                                                           
                                                               for(HighScore *hs in self.highScoresLessThanNewScore){
                                                                   hs.rank++;
                                                                   
                                                                   if(hs.rank > MAX_HIGHSCORES)//Only Keep Top 20 Scores
                                                                       [self.document.managedObjectContext deleteObject:hs];
                                                               }
                                                               //Call success display status function
                                                           }else{
                                                               //Call error display status function
                                                           }
                                                           [self dealAgainConfirm];
                                                           
                                                       }];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              //Do Nothing
                                                          }];
    
    [saveAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = @"My High Score";
    }];
    [saveAlert addAction:saveAction];
    [saveAlert addAction:dismissAction];
    
    [self presentViewController:saveAlert animated:YES completion:nil];
}

-(void)tapRootView:(UITapGestureRecognizer *)sender{
    if(self.areCardsInPile){
        self.areCardsInPile = !self.areCardsInPile;
        [self animateCardsToOriginalLocations];
    }
}

-(void)panRootView:(UIPanGestureRecognizer *)sender{
    if(self.areCardsInPile){
        UIView *topCard = [self.cardViews lastObject];
        if(sender.state == UIGestureRecognizerStateBegan){
            _attachTopBehavior = [[UIAttachmentBehavior alloc] initWithItem:topCard attachedToAnchor:[sender locationInView:self.view]];
            _attachTopBehavior.length = 0.0;
            [self.animator addBehavior:_attachTopBehavior];
        }else if(sender.state == UIGestureRecognizerStateChanged){
            [_attachTopBehavior setAnchorPoint:[sender locationInView:self.view]];
        }else if(sender.state == UIGestureRecognizerStateEnded){
            [self.animator removeBehavior:_attachTopBehavior];
            _attachTopBehavior = nil;
        }
    }
}

-(void)pinchContainer:(UIPinchGestureRecognizer *)sender{
    UIView *topView = [self.cardViews lastObject];
    if(!self.areCardsInPile){
        if(sender.state == UIGestureRecognizerStateBegan){
            for(UIView *cardView in self.cardViews){
                [UIView animateWithDuration:1.0
                                 animations:^{
                                     CGFloat halfWidth = self.cardContainerView.bounds.size.width/2;
                                     CGFloat halfHeight = self.cardContainerView.bounds.size.height/2;
                                     CGPoint containerCenter = CGPointMake(halfWidth, halfHeight);
                                     cardView.center = containerCenter;
                                 }
                                 completion:^(BOOL finished){
                                     if (finished) {
                                         if(cardView != topView){
                                             UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:cardView attachedToItem:topView];
                                             [self.animator addBehavior:attachmentBehavior];
                                         }else if (cardView == topView)
                                             self.areCardsInPile = YES;
                                     }
                                 }
                 ];
            }
        }
//        self.areCardsInPile = !self.areCardsInPile;
    }
}

-(void)tapCard:(UITapGestureRecognizer *)sender{
    
    self.pauseButton.enabled = YES;
    NSUInteger chosenCardIndex = [self.cardViews indexOfObject:sender.view];
//    Card *card = [self.game cardAtIndex:chosenCardIndex];
//    
//    NSLog(@"Is this tapped chosen: %@", card.isChosen ? @"YES":@"NO");
    [self.game chooseCardAtIndex:chosenCardIndex];
    [self updateUI];
}

-(void)drawThree{
    NUMBER_OF_COLUMNS++;
    [self setUpContainerViewHeight];
    [self setUpMyGrid];
    __block int cardIndex = 0;
    for(int i = 0; i < self.myGridForCards.numOfRows; i++){
        for(int j = 0; j < self.myGridForCards.numOfColumns; j++){
            if(j != self.myGridForCards.numOfColumns-1){
                [UIView animateWithDuration:0.4
                                 animations:^{
                                     ((UIView *)self.cardViews[cardIndex]).frame = [self.myGridForCards frameForCellInRow:i andColumn:j]; //Use Introspection?
                                 }];
                cardIndex++;
                 
            }else{
                SetCard *drawnSetCard = (SetCard *)[self.game drawOneCardIntoGame]; //Use Introspection?
                CGRect initialFrame;
                initialFrame.origin = CGPointMake(self.myGridForCards.size.width-[self.myGridForCards cellWidth], 0.0);
                SetCardView *newScv = [[SetCardView alloc] initWithFrame:initialFrame];
                if(drawnSetCard){
                    newScv.shape = drawnSetCard.shape;
                    newScv.color = drawnSetCard.color;
                    newScv.number = drawnSetCard.number;
                    newScv.shading = drawnSetCard.shading;
                    newScv.isChosen = drawnSetCard.isChosen;
                    
                    [self.cardContainerView addSubview:newScv];
                    [self.cardViews insertObject:newScv atIndex:cardIndex];
                    [UIView animateWithDuration:0.4
                                     animations:^{
                                         newScv.frame = [self.myGridForCards frameForCellInRow:i andColumn:j];
                                         [self.cardViewFrames insertObject:[NSValue valueWithCGRect:newScv.frame] atIndex:cardIndex];
                                         cardIndex++;
                                     }];
                }
            }
        }
    }
}

-(void)updateUI{
    NSMutableArray *addedCards = [[NSMutableArray alloc] initWithCapacity:3];
    long cardsInGameCount = [self.game.cards count];
    long cardViewsCount = [self.cardViews count];
    
    if(cardsInGameCount != cardViewsCount){
        for(long i = cardsInGameCount; cardsInGameCount != cardViewsCount;){
            UIView *cardView = self.cardViews[i];
            [cardView removeFromSuperview];
            [self.cardViews removeObjectAtIndex:i];
            cardViewsCount--;
        }
    }
    for(UIView *cardView in self.cardViews){
        NSUInteger cardIndex = [self.cardViews indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardIndex];
        if([card isKindOfClass:[PlayingCard class]]){
            if([cardView isKindOfClass:[PlayingCardView class]]){
                PlayingCardView *playingCardView = (PlayingCardView *)cardView;
                PlayingCard *playingCard = (PlayingCard *)card;
                playingCardView.rank = playingCard.rank;
                playingCardView.suit = playingCard.suit;
                playingCardView.isMatched = playingCard.isMatched;
                if(card.isChosen != playingCardView.faceUP){
                    [UIView transitionWithView:playingCardView
                                  duration:0.4
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                    animations:nil
                                completion:nil];
                }
                playingCardView.faceUP = playingCard.isChosen;
            }
        }else if([card isKindOfClass:[SetCard class]]){
            if([cardView isKindOfClass:[SetCardView class]]){
                SetCardView *setCardView = (SetCardView *)cardView;
                SetCard *setCard = (SetCard *)card;
                setCardView.shape = setCard.shape;
                setCardView.color = setCard.color;
                setCardView.number = setCard.number;
                setCardView.shading = setCard.shading;
                setCardView.isChosen = setCard.isChosen;
                if(setCard.isMatched != setCardView.isMatched){
                    setCardView.isMatched = setCard.isMatched;
                    if(setCardView.isMatched == YES){
                        CGRect rectForMatchedCard = setCardView.frame;
                        CGFloat initialXValue = arc4random_uniform(self.cardContainerView.bounds.size.width);
                        CGRect initialFrame;
                        initialFrame.origin = CGPointMake(initialXValue, 0);
                        initialFrame.size = rectForMatchedCard.size;
                        
                        SetCard *drawnCard = (SetCard *)[self.game drawOneCardFromFSetIntoGame];//Use Introspection?
                        if(!drawnCard)
                            drawnCard = (SetCard *)[self.game drawOneCardIntoGame];
                        if(drawnCard){
                            SetCardView *newScv = [[SetCardView alloc] initWithFrame:initialFrame];
                            newScv.shape = drawnCard.shape;
                            newScv.color = drawnCard.color;
                            newScv.number = drawnCard.number;
                            newScv.shading = drawnCard.shading;
                            newScv.isChosen = drawnCard.isChosen;
                            [self.cardContainerView addSubview:newScv];
                            [addedCards addObject:newScv];
                            [newScv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)]];
                            
                            [UIView animateWithDuration:1.0
                                             animations:^{
                                                 newScv.frame = rectForMatchedCard;
                                                 [self.cardViewFrames addObject:[NSValue valueWithCGRect:newScv.frame]];
                                             }];
                        }
                    }
                }
            }
        }
    }
    [self.cardViews addObjectsFromArray:addedCards];
    
    self.pauseButton.enabled = self.game.isGameActive;
    NSString *scoreLabelString = [self.numberFormatter stringFromNumber:[NSNumber numberWithInteger:self.game.score]];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %@", scoreLabelString];
    
    [self updateTimeLabels];
    [self updateUIForGamePaused];
    [self updateUIForGameEnded];
}

-(void)updateTimeLabels{
    self.totalTimeLabel.text = [NSString stringWithFormat:@"Total Time: %li", (unsigned long)self.game.totalTime];
    self.subTimeLabel.text = [NSString stringWithFormat:@"Reset In: %li", (unsigned long)self.game.subTime];
}

- (void)updateUIForGameEnded{
    if(self.game.hasGameEnded){
        self.cardContainerView.hidden = YES;
        self.scoreLabel.hidden = YES;
        self.resultsContainerView.hidden = NO;
    }
}

- (void)updateUIForGamePaused{
    if(self.game.isGamePaused && self.game.isGameActive){
        self.cardContainerView.hidden = YES;
        self.pausedLabel.hidden = NO;
        [self.pauseButton setImage:[UIImage imageNamed:@"Resume_Filled"] forState:UIControlStateNormal];
    }else{
        self.cardContainerView.hidden = NO;
        self.pausedLabel.hidden = YES;
        [self.pauseButton setImage:[UIImage imageNamed:@"Pause_Filled"] forState:UIControlStateNormal];
    }
}

-(void)animateCardsToOriginalLocations{
    for(int i = 0; i < [self.cardViews count]; i++){
        [UIView animateWithDuration:0.3
                         animations:^{
                            ((UIView *)self.cardViews[i]).frame = ((NSValue *)self.cardViewFrames[i]).CGRectValue;
                         }];
    }
}

//--Getters and Setters--
#pragma mark - Getters and Setters
- (NSNumberFormatter *)numberFormatter{
    if(!_numberFormatter){
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return _numberFormatter;
}

- (NSString *)nHSName{
    if(!_nHSName)
        _nHSName = @"";
    
    return _nHSName;
}

- (NSUserDefaults *)userDefaults{
    if(!_userDefaults)
        _userDefaults = [NSUserDefaults standardUserDefaults];
    
    return _userDefaults;
}

- (NSDictionary *)settings{
    if(!_settings)
        _settings = [self.userDefaults objectForKey:SETTINGS];
    
    return _settings;
}

-(Grid *)gridForCards{
    if(!_gridForCards)
        _gridForCards = [[Grid alloc] init];
    return _gridForCards;
}

-(MyGrid *)myGridForCards{
    if(!_myGridForCards)
        _myGridForCards = [[MyGrid alloc] init];
    return _myGridForCards;
}

-(CardMatchingGame *)game{
    if(!_game)
        _game = [self createGame];
    _game.threeCardGame = NO;
    return _game;
}

-(NSMutableArray *)cardViews{
    if(!_cardViews)
        _cardViews = [[NSMutableArray alloc] init];
    return _cardViews;
}
-(UIDynamicAnimator *)animator{
    if(!_animator)
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardContainerView];
    return _animator;
}
-(NSMutableArray *)cardViewFrames{
    if(!_cardViewFrames)
        _cardViewFrames = [[NSMutableArray alloc] init];
    return _cardViewFrames;
}
-(NSUInteger)numOfRows{
    return 0;
}

//--Setup Code--
#pragma mark - Setup

- (void)setUpBackgroundImage{
    if([self.settings objectForKey:HAS_BACKGROUND_IMAGE]){
        self.backgroundImage.hidden = NO;
        [self.backgroundImage setImage:[UIImage imageNamed:[self.settings objectForKey:BACKGROUND_IMAGE]]];
    }else{
        self.backgroundImage.hidden = YES;
    }
}

- (void)setUpMenuColor{
    NSDictionary *menuColor = [self.settings objectForKey:MENU_COLOR];
    
    float red = [[menuColor objectForKey:RED] floatValue] / 255;
    float green = [[menuColor objectForKey:GREEN] floatValue] / 255;
    float blue = [[menuColor objectForKey:BLUE] floatValue] / 255;
    double alpha = [[menuColor objectForKey:ALPHA] doubleValue];
    
    self.menu.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)setUpSaveButtonColor{
    NSDictionary *saveButtonColor = [self.settings objectForKey:SAVE_BUTTON_COLOR];
    
    float red = [[saveButtonColor objectForKey:RED] floatValue] / 255;
    float green = [[saveButtonColor objectForKey:GREEN] floatValue] / 255;
    float blue = [[saveButtonColor objectForKey:BLUE] floatValue] / 255;
    double alpha = [[saveButtonColor objectForKey:ALPHA] doubleValue];
    
    UIColor *saveButtonCol = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    self.saveScoreButton.backgroundColor = saveButtonCol;
}

-(void)hideNavBar{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)setUpMyGrid{
    self.myGridForCards.size = self.cardContainerView.bounds.size;
    self.myGridForCards.numOfColumns = NUMBER_OF_COLUMNS;
    self.myGridForCards.numOfRows = NUMBER_OF_ROWS;
}

-(void)setUpGrid{
    self.gridForCards.size = self.cardContainerView.bounds.size;
    self.gridForCards.minimumNumberOfCells = INITIAL_NUMBER_OF_CARDS;
    self.gridForCards.cellAspectRatio = CARD_ASPECT_RATIO;
}

//Implemented in subclasses
-(void)initializeAndAddCardViews{
}
                 
//Implemented in subclasses
-(Deck *)createDeck{
    return nil;
}

-(CardMatchingGame *)createGame{
    return [[CardMatchingGame alloc] initWithCardCount:(NUMBER_OF_ROWS*NUMBER_OF_COLUMNS) usingDeck:[self createDeck]];
}

-(void)addWillResignActiveNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(prepareForResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)addSettingsChangedNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(settingsUpdated)
                                                 name:SETTINGS_CHANGED_NOTIFICATION
                                               object:nil];
}

-(void)addResetCardsNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI)
                                                 name:RESET_CARDS_NOTIFICATION
                                               object:nil];
}

-(void)addUpdateTimeNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTimeLabels)
                                                 name:UPDATE_TIME_NOTIFICATION
                                               object:nil];
}

-(void)addGameEndedNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(processEndOfGame)
                                                 name:GAME_ENDED_NOTIFICATION
                                               object:nil];
}

- (void)addNotifications{
    [self addSettingsChangedNotification];
    [self addWillResignActiveNotification];
    [self addResetCardsNotification];
    [self addUpdateTimeNotification];
    [self addGameEndedNotification];
}

-(void)addTapGestureRecognizerToCards{
    for(UIView *cardView in self.cardViews){
        [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)]];
    }
}

-(void)addPinchRecognizerToCardContainer{
    [self.cardContainerView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchContainer:)]];
}

-(void)addPanRecognizerToRootView{
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRootView:)]];
}

-(void)addTapRecognizerToRootView{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRootView:)]];
}

- (void)addGestureRecognizers{
    [self addTapGestureRecognizerToCards];
}

-(void)setUpContainerViewHeight{
    CGFloat deductFromHeight = self.cardContainerView.bounds.size.height - [self deductFromHeightFactor]*[self deductFromHeightCoeff];
    [self.cardContainerView setBounds:CGRectMake(self.cardContainerView.bounds.origin.x, self.cardContainerView.bounds.origin.y, self.cardContainerView.bounds.size.width, deductFromHeight)];
}

-(int)deductFromHeightFactor{
    return NUMBER_OF_COLUMNS - (NUMBER_OF_ROWS + 1);
}

-(CGFloat)deductFromHeightCoeff{
    return self.cardContainerView.bounds.size.height/7;
}

-(void)removeAllCardSubViews{
    for(UIView *view in self.cardContainerView.subviews){
        [view removeFromSuperview];
    }
}

//--Core Data Setup Code--
#pragma mark Core Data Setup Code
-(void)createAndOpenManagedDocument{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"SetsDB";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    BOOL fileExists = [fileManager fileExistsAtPath:[url path]];
    if(fileExists){
        [self.document openWithCompletionHandler:^(BOOL success){
            [self insertDefaultValuesIntoDB];
//            [self displayDBContents];
        }];
    }else{
        [self.document saveToURL:url
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:^(BOOL success) {
                   //Populate Database for the first time
                   [self insertDefaultValuesIntoDB];
               }];
    }
}

//--Helper Methods--
#pragma mark Helper Methods
- (NSString *)stringFromTotalPlayTime:(NSInteger)totalPlayTime{
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [NSDate dateWithTimeInterval:totalPlayTime sinceDate:startDate];
    
    NSCalendar *gregCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit totalPlayTimeUnits = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *totalPlayTimeComponents = [gregCalendar components:totalPlayTimeUnits fromDate:startDate toDate:endDate options:0];
    
    NSString *result;
    NSString *dayString;
    NSString *hourString;
    NSString *minuteString;
    NSString *secondString;
    
    if(totalPlayTimeComponents.day == 0)
        dayString = @"";
    else
        dayString = [NSString stringWithFormat:@" %lid", (long)totalPlayTimeComponents.day];
    
    if(totalPlayTimeComponents.hour == 0)
        hourString = @"";
    else
        hourString = [NSString stringWithFormat:@" %lih", (long)totalPlayTimeComponents.hour];
    
    if(totalPlayTimeComponents.minute == 0)
        minuteString = @"";
    else
        minuteString = [NSString stringWithFormat:@" %lim", (long)totalPlayTimeComponents.minute];
    
    secondString = [NSString stringWithFormat:@" %lis", (long)totalPlayTimeComponents.second];
    result = [NSString stringWithFormat:@"%@%@%@%@", dayString,hourString,minuteString,secondString];
    
    return result;
}

- (void)prepareForResignActive{
    [self pauseGame];
    [self saveGameState];
}

- (void)saveGameState{
    if(self.game.isGameActive){
    //    self.userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *cardsData = [[NSMutableArray alloc] init]; //of NSData
        
        for(Card *card in self.game.cards){
            if([card isKindOfClass:[PlayingCard class]]){
                PlayingCard *playingCard = (PlayingCard *)card;
                NSData *cardData = [NSKeyedArchiver archivedDataWithRootObject:playingCard];
                [cardsData addObject:cardData];
            }
            if([card isKindOfClass:[SetCard class]]){
                SetCard *setCard = (SetCard *)card;
                NSData *cardData = [NSKeyedArchiver archivedDataWithRootObject:setCard];
                [cardsData addObject:cardData];
            }
        }
        NSDictionary *gameState = @{
                                        IS_GAME_ACTIVE : [NSNumber numberWithBool:self.game.isGameActive],
                                        IS_GAME_PAUSED : [NSNumber numberWithBool:self.game.isGamePaused],
                                        SCORE : [NSNumber numberWithLong:self.game.score],
                                        TOTAL_PLAY_TIME : [NSNumber numberWithLong:self.game.totalPlayTime],
                                        TOTAL_TIME : [NSNumber numberWithLong:self.game.totalTime],
                                        SUB_TIME : [NSNumber numberWithLong:self.game.subTime],
                                        CARDS : cardsData
                                    };
        [self.userDefaults setObject:gameState forKey:GAME_STATE];
        [self.userDefaults synchronize];
    }
}

- (void)restoreGameState{
//    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *gameState = [self.userDefaults objectForKey:GAME_STATE];
    if(gameState){
        NSMutableArray *loadedCards = [[NSMutableArray alloc] init];
        NSArray *loadedCardsData = [gameState objectForKey:CARDS]; //Of NSData
        for(NSData *loadedCardData in loadedCardsData){
            id loadedObject = [NSKeyedUnarchiver unarchiveObjectWithData:loadedCardData];
            
            if([loadedObject isKindOfClass:[PlayingCard class]]){//Loading Playing Card
                PlayingCard *loadedCard = (PlayingCard *)loadedObject;
                [loadedCards addObject:loadedCard];
            }
            if([loadedObject isKindOfClass:[SetCard class]]){
                SetCard *loadedCard = (SetCard *)loadedObject;
                [loadedCards addObject:loadedCard];
            }
        }
        
        self.game.isGameActive = [[gameState objectForKey:IS_GAME_ACTIVE] boolValue];
        self.game.isGamePaused = [[gameState objectForKey:IS_GAME_PAUSED] boolValue];
        self.game.score = [[gameState objectForKey:SCORE] longValue];
        self.game.totalPlayTime = [[gameState objectForKey:TOTAL_PLAY_TIME] longValue];
        self.game.totalTime = [[gameState objectForKey:TOTAL_TIME] longValue];
        self.game.subTime = [[gameState objectForKey:SUB_TIME] longValue];
        self.game.cards = loadedCards;
        [self.userDefaults setObject:nil forKey:GAME_STATE];
        [self.userDefaults synchronize];
    }
}

- (void)settingsUpdated{
//    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.settings = [self.userDefaults objectForKey:SETTINGS];
    [self setUpBackgroundImage];
    [self setUpMenuColor];
    [self setUpSaveButtonColor];
    [self setCardBackImages];
}

//Implemented in subclass
- (void)setCardBackImages{
}

-(void)dealAgainConfirm{
    [self.userDefaults setObject:nil forKey:GAME_STATE];
    self.pausedLabel.hidden = YES;
    self.saveScoreButton.hidden = NO;
    self.resultsContainerView.hidden = YES;
    self.scoreLabel.hidden = NO;
    self.cardContainerView.hidden = NO;
    self.pauseButton.enabled = NO;
    NUMBER_OF_COLUMNS = 4;
    NUMBER_OF_ROWS = 3;
    self.cardContainerView.bounds = originalCardContainerBounds;
    [self setUpContainerViewHeight];
    [self setUpMyGrid];
    self.game = [self createGame];
    [self removeAllCardSubViews];
    [self initializeAndAddCardViews];
    [self addTapGestureRecognizerToCards];
    [self updateUI];
}

-(void)pauseGame{
    if(self.game.isGameActive){//Only Pause if the game's started and not ended
        if(!self.game.isGamePaused){
            [self.game.timer invalidate];
            self.game.isGamePaused = YES;
            [self updateUI];
        }
    }
}

-(void)resumeGame{
    if(self.game.isGamePaused){
        self.game.timer = [NSTimer timerWithTimeInterval:1.0f
                                             target:self.game
                                           selector:@selector(updateTime)
                                           userInfo:nil
                                            repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.game.timer forMode:NSRunLoopCommonModes];
        self.game.isGamePaused = NO;
        [self updateUI];
    }
}

-(void)insertDefaultValuesIntoDB{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"HighScore"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rank"
                                                                     ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSArray *highScores = [[NSArray alloc] init];
    
    highScores = [self.document.managedObjectContext executeFetchRequest:fetchRequest
                                                                   error:nil];
    
    if(!highScores || [highScores count] == 0){//If Database is empty
        NSLog(@"Database is empty");
        NSArray *ranks = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15, @16, @17, @18, @19, @20];
        NSArray *names = @[@"Sets_Master", @"Sets_Pro", @"ProGamer", @"Dude", @"Legend", @"Winner", @"Champion", @"Mr Incredible", @"The Destroyer", @"Stewie", @"WorldClass", @"Player", @"The Great", @"Gamer", @"Couch_Lad", @"Nerdy", @"Specimen", @"King", @"Joker", @"Ace"];
        NSArray *scores = @[@3500, @3000, @2980, @2900, @2860, @2800, @2000, @1600, @500, @300, @100, @90, @80, @70, @60, @50, @40, @30, @25, @20];
        NSArray *totalPlayTimes = @[@1000, @950, @940, @925, @900, @850, @800, @750, @740, @700, @600, @550, @500, @450, @400, @350, @300, @250, @200, @150];
        
        for(int i = 0; i < [ranks count]; i++){
            [HighScore insertHighScoreWithRank:[(NSNumber *)ranks[i] intValue]
                                          name:names[i]
                                         value:[(NSNumber *)scores[i] longValue]
                                     totalTime:[(NSNumber *)totalPlayTimes[i] longValue]
                                          date:[NSDate date]
                                    andContext:self.document.managedObjectContext];
        }
    }
}

-(void)displayDBContents{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"HighScore"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rank"
                                                                     ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSArray *highScores = [[NSArray alloc] init];
    
    highScores = [self.document.managedObjectContext executeFetchRequest:fetchRequest
                                                                       error:nil];
    
    for(HighScore *highScore in highScores){
        NSLog(@"Rank: %i   Name: %@  Score: %lli", highScore.rank, highScore.name, highScore.value);
    }
}

-(void)processEndOfGame{
    
    BOOL isTopScore = NO;
    BOOL isHighScore = NO;
    
    self.newHSValue = self.game.score;
    
    NSString *totalPlayTimeString = [self stringFromTotalPlayTime:self.game.totalPlayTime];
    
    NSDateFormatter *totalPlayTimeFormatter = [[NSDateFormatter alloc] init];
    totalPlayTimeFormatter.dateStyle = NSDateFormatterNoStyle;
    totalPlayTimeFormatter.timeStyle = NSDateFormatterMediumStyle;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"HighScore"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rank"
                                                                     ascending:YES];
    NSString *predicateStringForHighScoresLessThanNew = @"(rank <= %i) AND (value < %i)";
    NSString *predicateStringForAllHighScores = @"rank <= %i";
    
    NSPredicate *predicateForHighScoresLessThanNew = [NSPredicate predicateWithFormat:predicateStringForHighScoresLessThanNew, MAX_HIGHSCORES, self.newHSValue];
    
    NSPredicate *predicateForAllHighScores = [NSPredicate predicateWithFormat:predicateStringForAllHighScores, MAX_HIGHSCORES];
    
    
    fetchRequest.sortDescriptors = @[sortDescriptor];
    fetchRequest.predicate = predicateForHighScoresLessThanNew;
    
    NSError *error;
    self.highScoresLessThanNewScore = [self.document.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSArray *highScoresLessThanNewScore = self.highScoresLessThanNewScore;
    
    fetchRequest.predicate = predicateForAllHighScores;
    NSArray *allHighScores = [self.document.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if([highScoresLessThanNewScore count] > 0)
        isHighScore = YES;
    
    HighScore *topScore = [allHighScores firstObject];
    if(self.newHSValue > topScore.value)
        isTopScore = YES;
    
    //--Added code block--
    
    if(isHighScore){
        HighScore *firstHighScore = (HighScore *)[highScoresLessThanNewScore firstObject];
        self.newHSRank = firstHighScore.rank;
    }
    self.pauseButton.enabled = NO;
    
    self.topScoreLabel.text = [NSString stringWithFormat:@"Top Score: %lli", topScore.value];
    self.resultsScoreLabel.text = [NSString stringWithFormat:@"Your Score: %li", (long)self.newHSValue];
    self.resultsRankLabel.text = isHighScore ? [NSString stringWithFormat:@"Rank: %li", (long)self.newHSRank] : @"Rank: Not top 20";
    self.resultsTotalTimeLabel.text = [NSString stringWithFormat:@"Total Play Time: %@", totalPlayTimeString];
    self.saveScoreButton.hidden = isHighScore ? NO : YES;
    
    NSString *resultsTitle = @"";
    if(isHighScore){
        if(isTopScore)
            resultsTitle = @"Excellent! You Beat the Top Score!";
        else
            resultsTitle = @"Congratulations! You Got a High Score!";
    }else
        resultsTitle = @"Game Over";
    self.resultsTitleLabel.text = resultsTitle;
    
    [self updateUIForGameEnded];
    //--End of added code block--
}

//--Creation Method for Core Data--
//+ (void)insertHighScoreWithRank:(int)rank name:(NSString *)name value:(int)value andContext:(nonnull NSManagedObjectContext *)context{
//    HighScore *highScore = [NSEntityDescription insertNewObjectForEntityForName:@"HighScore" inManagedObjectContext:context];
//    
//    highScore.rank = rank;
//    highScore.name = name;
//    highScore.value = value;
//}


//--View Controller Life Cycle--
#pragma mark - View Controller Lifecycle
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpBackgroundImage];
    [self setUpMenuColor];
    [self setUpSaveButtonColor];
    //    originalCardContainerBounds = self.cardContainerView.bounds;
    [self hideNavBar];
    //    [self setUpContainerViewHeight];
    //    [self setUpMyGrid];
    //    [self initializeAndAddCardViews];
    [self addNotifications];
    
    //    [self restoreGameState];
    [self createAndOpenManagedDocument];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.title = @"Back";
    
    [self pauseGame];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideNavBar];
    self.title = @"";
}

- (void)viewDidAppear:(BOOL)animated{
    if(vCAlreadyAppearedOnce == NO){
        //Add Stuff That was Previously in viewDidLoad
        originalCardContainerBounds = self.cardContainerView.bounds;
        [self setUpContainerViewHeight];
        [self setUpMyGrid];
        [self initializeAndAddCardViews];
        [self addTapGestureRecognizerToCards];
        [self restoreGameState];
        //        self.pauseButton.enabled = self.game.isGameActive;
        [self updateUI];
    }
    vCAlreadyAppearedOnce = YES;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
